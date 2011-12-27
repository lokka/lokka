# coding: utf-8

module Lokka
  module HatenaBookmarkButton
    def self.registered(app)
      app.get '/admin/plugins/hatena_bookmark_button' do
        haml :"plugin/lokka-hatena_bookmark_button/views/index", :layout => :"admin/layout"
      end 

      app.put '/admin/plugins/hatena_bookmark_button' do
        params.each_pair do |key, value|
          eval("Option.#{key}='#{value}'") if key != '_method'
        end 
        flash[:notice] = t.hatena_bookmark_button_updated
        redirect '/admin/plugins/hatena_bookmark_button'
      end 
    end 
  end

  module Helpers
    def hatena_bookmark_button(title, url = nil)
      url = "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}#{env['PATH_INFO']}" if url.blank?

      layout = Option.hatena_bookmark_button_layout
      layout = 'standard' if layout.blank?

      opts = {'data-hatena-bookmark-layout' => layout, 'data-hatena-bookmark-title' => title}

      data = []
      opts.each {|opt| data << opt.join('="') + '"'}

      code = %Q(<a href="http://b.hatena.ne.jp/entry/)
      code += url
      code += %Q(" class="hatena-bookmark-button" )
      code += ' ' + data.join(' ')
      code += %Q( title="このエントリーをはてなブックマークに追加"><img src="http://b.st-hatena.com/images/entry-button/button-only.gif" alt="このエントリーをはてなブックマークに追加" width="20" height="20" style="border: none;" /></a><script type="text/javascript" src="http://b.st-hatena.com/js/bookmark_button.js" charset="utf-8" async="async"></script>)
    end
  end
end
