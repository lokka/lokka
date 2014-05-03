module Lokka
  module Config
    def self.registered(app)
      app.enable :sessions,
                 :method_override,
                 :raise_errors,
                 :static

      # lokka variables
      app.set :theme, 'vicuna'

      app.configure :development do
        app.register Sinatra::Reloader
      end
    end
  end
end
