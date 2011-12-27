module Lokka
  module TweetButton
    def self.registered(app)
      app.get '/admin/plugins/tweet_button' do
        haml :"plugin/lokka-tweet_button/views/index", :layout => :"admin/layout"
      end 

      app.put '/admin/plugins/tweet_button' do
        params.each_pair do |key, value|
          eval("Option.#{key}='#{value}'") if key != '_method'
        end
        flash[:notice] = t.tweet_button_updated
        redirect '/admin/plugins/tweet_button'
      end 
    end 
  end

  module Helpers
    def tweet_button(url = nil)
      url = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}#{request.env['SCRIPT_NAME']}#{request.env['PATH_INFO']}" if url.blank?

      count = Option.tweet_button_count
      count = 'vertical' if count.blank?

      via = Option.tweet_button_via

      related = Option.tweet_button_related_account
      unless related.blank?
        description = Option.tweet_button_related_description
        related += ':' + description unless description.blank?
      end

      lang = Option.tweet_button_lang
      lang = '' if lang == 'en'

      opts = {'data-count' => count}
      opts['data-via'] = via unless via.blank?
      opts['data-related'] = related unless related.blank?
      opts['data-lang'] = lang unless lang.blank?
      opts['data-url'] = url unless url.blank?

      data = []
      opts.each {|opt| data << opt.join('="') + '"'}

      code = %Q(<a href="http://twitter.com/share" class="twitter-share-button")
      code += ' ' + data.join(' ')
      code += %Q(>Tweet</a><script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script>)
    end
  end
end
