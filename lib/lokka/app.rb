module Lokka
  class App < Base
    enable :sessions,
           :method_override,
           :raise_errors,
           :static

    # lokka variables
    set :themes, {}
    set :theme, 'vicuna'

    require 'lokka/theme/vicuna'
    register ::Lokka::Theme::Vicuna

    configure :development do
      register Sinatra::Reloader
    end

    puts "settings.themes: #{settings.themes}"

    get '/' do
      puts "get '/' settings.themes: #{settings.themes}"
      slim :index
    end
  end
end
