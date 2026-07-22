# frozen_string_literal: true

require 'json'
require 'net/http'
require 'openssl'

module Lokka
  module Turnstile
    VERIFY_URI = URI('https://challenges.cloudflare.com/turnstile/v0/siteverify')

    def self.registered(app)
      app.before do
        next unless turnstile_required?
        next if turnstile_valid?

        halt 422, t('turnstile.verification_failed')
      end

      app.get '/admin/plugins/turnstile' do
        login_required
        haml :'plugin/lokka-turnstile/views/index', layout: :'admin/layout'
      end

      app.put '/admin/plugins/turnstile' do
        login_required
        Option.turnstile_site_key = params[:turnstile_site_key]
        Option.turnstile_secret_key = params[:turnstile_secret_key]
        flash[:notice] = t('turnstile.updated')
        redirect to('/admin/plugins/turnstile')
      end
    end
  end

  module Helpers
    def turnstile_enabled?
      turnstile_site_key.present? && turnstile_secret_key.present?
    end

    def turnstile_required?
      params['comment'].present? &&
        !request.path.start_with?('/admin/comments') &&
        !logged_in? &&
        turnstile_enabled?
    end

    def turnstile_valid?
      response = Net::HTTP.post_form(
        Turnstile::VERIFY_URI,
        secret: turnstile_secret_key,
        response: params['cf-turnstile-response'].to_s,
        remoteip: request.ip
      )
      result = JSON.parse(response.body)
      result['success'] == true && result['hostname'] == request.host
    rescue JSON::ParserError, OpenSSL::SSL::SSLError, SocketError, SystemCallError, Timeout::Error
      false
    end

    def turnstile_site_key
      ENV['TURNSTILE_SITE_KEY'].presence || Option.turnstile_site_key
    end

    def turnstile_secret_key
      ENV['TURNSTILE_SECRET_KEY'].presence || Option.turnstile_secret_key
    end
  end
end
