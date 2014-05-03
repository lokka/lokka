module Lokka
  class App < Base
    register Config

    set :views, './public/themes/vicuna'

    get '/' do
      slim :index
    end
  end
end
