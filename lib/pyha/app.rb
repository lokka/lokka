module Pyha
  class App < Sinatra::Base
    ROOT_DIR = Pathname(__FILE__).dirname.dirname.dirname.realpath.to_s
    DB_DIR =  ROOT_DIR + '/db'
    PUBLIC_DIR = ROOT_DIR + '/public'
    THEME_DIR = PUBLIC_DIR + '/theme'

    configure do
      DataMapper::Logger.new(STDOUT, :debug)
      DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{DB_DIR}/db.sqlite3")
      set :views, PUBLIC_DIR
    end

    helpers do
    end

    before do
      @setting = Setting.to_ostruct
    end

    get '/admin/' do
      erb "admin/index".to_sym, :layout => "admin/layout".to_sym
    end

    get '/' do
      @posts = Post.all
      erb "theme/#{@setting.theme}/posts".to_sym, :layout => "theme/#{@setting.theme}/layout".to_sym
    end

    get %r{/([\d]+)} do |id|
      @post = Post.get(id)
      erb "theme/#{@setting.theme}/post".to_sym, :layout => "theme/#{@setting.theme}/layout".to_sym
    end
  end
end
