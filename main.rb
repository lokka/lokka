require 'rubygems'
require 'pathname'
require 'erb'
require 'ostruct'
require 'digest/sha1'

require 'rack-flash'
require 'sinatra'
require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'
require 'dm-validations'
require 'haml'

require 'site'
require 'post'
require 'user'
require 'guest_user'

configure do
  use Rack::Session::Cookie,
    #:key => 'rack.session',
    #:domain => 'example.com',
    #:path => '/',
    :expire_after => 60 * 60 * 24 * 12,
    :secret => '_p_y_h_a_'
  use Rack::Flash
  DataMapper::Logger.new(STDOUT, :debug)
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Pathname(__FILE__).dirname.realpath}/db.sqlite3")
  set :views => File.join(File.dirname(__FILE__), 'public')
end

get '/admin/' do
  login_required
  haml 'admin/index'.to_sym, :layout => 'admin/layout'.to_sym
end

get '/admin/login' do
  haml 'admin/login'.to_sym, :layout => 'admin/layout'.to_sym
end

post '/admin/login' do
  @user = User.authenticate(params[:name], params[:password])
  if @user
    session[:user] = @user.id
    if session[:return_to]
      redirect_url = session[:return_to]
      session[:return_to] = false
      redirect redirect_url
    else
      redirect '/admin/'
    end
  else
    haml 'admin/login'.to_sym, :layout => 'admin/layout'.to_sym
  end
end

get '/admin/logout' do
  login_required
  session[:user] = nil
  flash[:notice] = 'Logout successful'
  redirect '/admin/login'
end

get '/admin/signup' do
  haml 'admin/signup'.to_sym, :layout => 'admin/layout'.to_sym
end

post '/admin/signup' do
  @user = User.new(params[:user])
  if @user.save
    session[:user] = @user.id
    redirect '/admin/'
  else
    haml 'admin/signup'.to_sym, :layout => 'admin/layout'.to_sym
  end
end

get '/admin/users' do
  login_required
  @users = User.all
  haml 'admin/users/index'.to_sym, :layout => 'admin/layout'.to_sym
end

get '/admin/posts' do
  login_required
  @posts = Post.all
  haml 'admin/posts/index'.to_sym, :layout => 'admin/layout'.to_sym
end

get '/' do
  @posts = Post.all
  erb "theme/#{@site.theme}/posts".to_sym, :layout => "theme/#{@site.theme}/layout".to_sym
end

get %r{/([\d]+)} do |id|
  @post = Post.get(id)
  erb "theme/#{@site.theme}/post".to_sym, :layout => "theme/#{@site.theme}/layout".to_sym
end

get %r{/([0-9a-zA-Z-]+)} do |slug|
  puts 'slug: ' + slug
  @post = Post.first(:slug => slug)
  erb "theme/#{@site.theme}/post".to_sym, :layout => "theme/#{@site.theme}/layout".to_sym
end

before do
  @site = Site.to_ostruct
end

helpers do
  def hash_to_query_string(hash)
    hash.collect {|k,v| "#{k}=#{v}"}.join('&')
  end

  def login_required
    if current_user.class != GuestUser
      return true
    else
      session[:return_to] = request.fullpath
      redirect '/admin/login'
      return false
    end
  end

  def current_user
    if session[:user]
      User.get(:id => session[:user])
    else
      GuestUser.new
    end
  end

  def logged_in?
    !!session[:user]
  end

  def use_layout?
    !request.xhr?
  end
end
