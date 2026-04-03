# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'openssl'

module Lokka
  module Antispam
    def self.registered(app)
      app.before do
        path = request.env['PATH_INFO']
        if params['comment'] && %r{^/admin/comments} !~ path
          params['comment']['status'] = if logged_in?
                                          Comment::APPROVED
                                        elsif antispam_detected?
                                          Comment::SPAM
                                        else
                                          Comment::MODERATED
                                        end
        end
      end

      app.get '/admin/plugins/antispam' do
        login_required
        @settings = antispam_settings
        haml :"#{antispam_view}index", layout: :'admin/layout'
      end

      app.put '/admin/plugins/antispam' do
        login_required
        antispam_save_settings(params[:antispam] || {})
        flash[:notice] = t('antispam.settings_saved')
        redirect to('/admin/plugins/antispam')
      end
    end
  end

  module Helpers
    ANTISPAM_SECRET_KEY = 'antispam_secret'

    def antispam_view
      'plugin/lokka-antispam/views/'
    end

    def antispam_settings
      {
        honeypot_enabled: Option.antispam_honeypot_enabled != 'false',
        timing_enabled: Option.antispam_timing_enabled != 'false',
        timing_min_seconds: (Option.antispam_timing_min_seconds || 3).to_i,
        content_enabled: Option.antispam_content_enabled != 'false',
        content_max_urls: (Option.antispam_content_max_urls || 3).to_i,
        content_ng_words: Option.antispam_content_ng_words || '',
        turnstile_enabled: Option.antispam_turnstile_enabled == 'true',
        turnstile_site_key: Option.antispam_turnstile_site_key || '',
        turnstile_secret_key: Option.antispam_turnstile_secret_key || '',
        rate_limit_enabled: Option.antispam_rate_limit_enabled != 'false',
        rate_limit_max: (Option.antispam_rate_limit_max || 3).to_i,
        rate_limit_window: (Option.antispam_rate_limit_window || 60).to_i
      }
    end

    def antispam_save_settings(params)
      Option.antispam_honeypot_enabled = params[:honeypot_enabled] == '1' ? 'true' : 'false'
      Option.antispam_timing_enabled = params[:timing_enabled] == '1' ? 'true' : 'false'
      Option.antispam_timing_min_seconds = params[:timing_min_seconds].to_i
      Option.antispam_content_enabled = params[:content_enabled] == '1' ? 'true' : 'false'
      Option.antispam_content_max_urls = params[:content_max_urls].to_i
      Option.antispam_content_ng_words = params[:content_ng_words].to_s.strip
      Option.antispam_turnstile_enabled = params[:turnstile_enabled] == '1' ? 'true' : 'false'
      Option.antispam_turnstile_site_key = params[:turnstile_site_key].to_s.strip
      Option.antispam_turnstile_secret_key = params[:turnstile_secret_key].to_s.strip
      Option.antispam_rate_limit_enabled = params[:rate_limit_enabled] == '1' ? 'true' : 'false'
      Option.antispam_rate_limit_max = params[:rate_limit_max].to_i
      Option.antispam_rate_limit_window = params[:rate_limit_window].to_i
    end

    def antispam_detected?
      settings = antispam_settings

      return true if settings[:honeypot_enabled] && honeypot_spam?
      return true if settings[:timing_enabled] && timing_spam?(settings[:timing_min_seconds])
      return true if settings[:content_enabled] && content_spam?(settings[:content_max_urls], settings[:content_ng_words])
      return true if settings[:turnstile_enabled] && turnstile_spam?(settings[:turnstile_secret_key])
      return true if settings[:rate_limit_enabled] && rate_limited?(settings[:rate_limit_max], settings[:rate_limit_window])

      false
    end

    # Honeypot: hidden field that bots fill in
    def honeypot_spam?
      params[:website].present? || params[:url_field].present?
    end

    # Timing: submissions too fast are likely bots
    def timing_spam?(min_seconds)
      timestamp = params[:antispam_ts].to_i
      token = params[:antispam_token].to_s

      return true if timestamp.zero? || token.empty?

      expected_token = OpenSSL::HMAC.hexdigest('SHA256', antispam_secret, timestamp.to_s)
      return true unless secure_compare(token, expected_token)

      elapsed = Time.now.to_i - timestamp
      elapsed < min_seconds
    end

    # Content: too many URLs or contains NG words
    def content_spam?(max_urls, ng_words_str)
      body = params.dig('comment', 'body').to_s

      url_count = body.scan(%r{https?://}i).size
      return true if url_count > max_urls

      ng_words = ng_words_str.split(',').map(&:strip).reject(&:empty?)
      ng_words.each do |word|
        return true if body.downcase.include?(word.downcase)
      end

      false
    end

    # Turnstile: Cloudflare CAPTCHA verification
    def turnstile_spam?(secret_key)
      return false if secret_key.to_s.empty?

      token = params['cf-turnstile-response'].to_s
      return true if token.empty?

      uri = URI('https://challenges.cloudflare.com/turnstile/v0/siteverify')
      response = Net::HTTP.post_form(uri, {
                                       secret: secret_key,
                                       response: token,
                                       remoteip: request.ip
                                     })

      result = JSON.parse(response.body)
      !result['success']
    rescue StandardError
      true
    end

    # Rate limit: too many submissions from same IP
    def rate_limited?(max_comments, window_seconds)
      ip = request.ip
      key = "antispam_rate_#{ip.gsub('.', '_')}"
      now = Time.now.to_i

      data = Option.send(key)
      timestamps = data.present? ? JSON.parse(data) : []
      timestamps = timestamps.select { |t| t > now - window_seconds }

      if timestamps.size >= max_comments
        true
      else
        timestamps << now
        Option.send("#{key}=", timestamps.to_json)
        false
      end
    rescue StandardError
      false
    end

    def antispam_secret
      secret = Option.send(ANTISPAM_SECRET_KEY)
      if secret.to_s.empty?
        secret = SecureRandom.hex(32)
        Option.send("#{ANTISPAM_SECRET_KEY}=", secret)
      end
      secret
    end

    # Generate hidden fields for comment form
    def antispam_fields
      settings = antispam_settings
      fields = []

      if settings[:honeypot_enabled]
        fields << %(<div style="position:absolute;left:-9999px;top:-9999px;" aria-hidden="true">)
        fields << %(<label for="website">Website</label>)
        fields << %(<input type="text" name="website" id="website" tabindex="-1" autocomplete="off">)
        fields << %(<input type="text" name="url_field" tabindex="-1" autocomplete="off">)
        fields << %(</div>)
      end

      if settings[:timing_enabled]
        timestamp = Time.now.to_i
        token = OpenSSL::HMAC.hexdigest('SHA256', antispam_secret, timestamp.to_s)
        fields << %(<input type="hidden" name="antispam_ts" value="#{timestamp}">)
        fields << %(<input type="hidden" name="antispam_token" value="#{token}">)
      end

      if settings[:turnstile_enabled] && settings[:turnstile_site_key].present?
        fields << %(<script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>)
        fields << %(<div class="cf-turnstile" data-sitekey="#{ERB::Util.html_escape(settings[:turnstile_site_key])}"></div>)
      end

      fields.join("\n")
    end

    private

    def secure_compare(str_a, str_b)
      return false unless str_a.bytesize == str_b.bytesize

      l = str_a.unpack('C*')
      res = 0
      str_b.each_byte { |byte| res |= byte ^ l.shift }
      res.zero?
    end
  end
end
