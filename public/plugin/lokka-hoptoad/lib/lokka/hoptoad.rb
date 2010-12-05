require 'hoptoad_notifier'

module Lokka
  module Hoptoad
    def self.registered(app)
      app.use HoptoadNotifier::Rack

      app.before do
        if key = Option.hoptoad_api_key
          HoptoadNotifier.configure do |config|
            config.api_key = key
          end
        end
      end

      app.get '/admin/plugins/hoptoad' do
        haml :'plugin/lokka-hoptoad/views/index', :layout => :'admin/layout'
      end

      app.put '/admin/plugins/hoptoad' do
        Option.hoptoad_api_key = params['api_key']
        flash[:notice] = 'Updated.'
        redirect '/admin/plugins/hoptoad'
      end
    end
  end
end
