module Lokka
  class App < Base
    enable :sessions,
           :method_override,
           :raise_errors,
           :static

    set :theme, 'vicuna'


    configure :development do
      puts ::Lokka::Theme::Vicuna
      register Sinatra::Reloader
    end

    configure do
      binding.pry
    end

    get '/' do
      binding.pry
      slim :index
    end
  end
end
