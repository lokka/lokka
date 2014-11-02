module Lokka
  class App < Base
    enable :sessions,
           :method_override,
           :raise_errors,
           :static

    set :theme, 'vicuna'


    configure :development do
      binding.pry
      theme = settings.theme.capitalize
      register Lokka::Theme.const_get(theme)
      register Sinatra::Reloader
    end

    configure do
      binding.pry
    end

    get '/' do
      slim :index
    end
  end
end
