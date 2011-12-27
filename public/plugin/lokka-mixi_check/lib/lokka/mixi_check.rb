module Lokka
  module MixiCheck
    def self.registered(app)
      app.before do
        path = request.env['PATH_INFO']

        if /^\/([0-9a-zA-Z-]+)$/ =~ path
          content_for :header do
            haml :"plugin/lokka-mixi_check/views/header", :layout => false
          end
        end
      end

      app.get '/admin/plugins/mixi_check' do
        haml :"plugin/lokka-mixi_check/views/index", :layout => :"admin/layout"
      end 

      app.put '/admin/plugins/mixi_check' do
        params.each_pair do |key, value|
          eval("Option.#{key}='#{value}'") if key != '_method'
        end 
        flash[:notice] = t.mixi_check_updated
        redirect '/admin/plugins/mixi_check'
      end 
    end
  end

  module Helpers
    def html_properties 
      s = yield_content :html_properties
      s unless s.blank?
    end

    def mixi_check(url = nil)
      key = Option.mixi_check_key
      return if key.blank?

      url = "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}#{env['PATH_INFO']}" if url.blank?

      button = Option.mixi_check_button
      button_type = Option.mixi_check_button_type
      button += '.' + button_type if !button.blank? && !button_type.blank? 

      opts = {'data-key' => key, 'data-url' => url}
      opts['data-button'] = button unless button.blank?

      data = []
      opts.each {|opt| data << opt.join('="') + '"'}

      code = %Q(<a href="http://mixi.jp/share.pl" class="mixi-check-button")
      code += ' ' + data.join(' ')
      code += %Q(>Check</a><script type="text/javascript" src="http://static.mixi.jp/js/share.js"></script>)
    end
  end
end

class String
  def jleft(len)
    return "" if len <= 0

    str = self[0,len]
    return "" if str.length <= 0

    if /.\z/ !~ str
      str[-1,1] = ''
    end
    str
  end
end

