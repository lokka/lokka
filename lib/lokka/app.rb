module Lokka
  class App < Base
    register Config

    puts "settings.themes: #{settings.themes}"

    get '/' do
      puts "get '/' settings.themes: #{settings.themes}"
      slim :index
    end
  end
end
