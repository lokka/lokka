require 'lokka'
require 'rbconfig'

module Lokka
  module Rbconfig
    include Lokka::Plugin

    have_page

    def self.registered(app)
      app.get '/admin/plugins/rbconfig' do
        haml :"plugin/lokka-rbconfig/views/index", :layout => :"admin/layout"
      end
    end
  end
end
