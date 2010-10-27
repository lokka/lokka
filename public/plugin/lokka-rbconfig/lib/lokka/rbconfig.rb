require 'rbconfig'

module Lokka
  module Rbconfig
    def self.registered(app)
      app.get '/admin/plugins/rbconfig' do
        haml :"plugin/lokka-rbconfig/views/index", :layout => :"admin/layout"
      end
    end
  end
end
