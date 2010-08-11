module Pyha
  class App < Sinatra::Base
    ROOT_DIR = Pathname(__FILE__).dirname.dirname.dirname.realpath.to_s
    THEME_DIR = ROOT_DIR + '/theme'
    DB_DIR =  ROOT_DIR + '/db'

    configure do
      DataMapper::Logger.new(STDOUT, :debug)
      DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{DB_DIR}/db.sqlite3")
      set :views, Proc.new {
        File.join(THEME_DIR, Setting.theme)
      }
    end

    helpers do
    end
   
    get '/' do
      @posts = Post.all
      erb :index
    end
  end
end
