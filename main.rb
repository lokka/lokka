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
require 'dm-types'
require 'dm-is-tree'
require 'haml'

require 'user'
require 'guest_user'
require 'site'
require 'post'
require 'category'

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

# index
get '/' do
  @posts = Post.all
  erb "theme/#{@site.theme}/posts".to_sym, :layout => "theme/#{@site.theme}/layout".to_sym
end

# category archive
get '/category/*/' do |path|
  category_name = path.split('/').last
  @category = Category.get_by_name_or_slug(category_name)
  return 404 if @category.nil?
  @posts = @category.posts
  erb "theme/#{@site.theme}/posts".to_sym, :layout => "theme/#{@site.theme}/layout".to_sym
end

# monthly archive
get %r{/([\d]{4})/([\d]{2})/} do |year, month|
  year, month = year.to_i, month.to_i
  @posts = Post.all(:created_at.gte => DateTime.new(year, month)).
                all(:created_at.lt => DateTime.new(year, month) >> 1 )
  erb "theme/#{@site.theme}/posts".to_sym, :layout => "theme/#{@site.theme}/layout".to_sym
end

# yearly archive
get %r{/([\d]{4})/} do |year|
  year = year.to_i
  @posts = Post.all(:created_at.gte => DateTime.new(year)).
                all(:created_at.lt => DateTime.new(year + 1))
  erb "theme/#{@site.theme}/posts".to_sym, :layout => "theme/#{@site.theme}/layout".to_sym
end

# id
get %r{/([\d]+)} do |id|
  @post = Post.get(id)
  erb "theme/#{@site.theme}/post".to_sym, :layout => "theme/#{@site.theme}/layout".to_sym
end

# slug
get %r{/([0-9a-zA-Z-]+)} do |slug|
  @post = Post.first(:slug => slug)
  erb "theme/#{@site.theme}/post".to_sym, :layout => "theme/#{@site.theme}/layout".to_sym
end

error 404 do
  'File not found'
end

before do
  @site = Site.to_ostruct

  years = {}
  year_months = {}
  year_month_days = {}
  Post.all.each do |post|
    year = post.created_at.strftime('%Y')
    if years[year].nil?
      years[year] = 1 
    else
      years[year] += 1 
    end
      
    year_month = post.created_at.strftime('%Y-%m')
    if year_months[year_month].nil?
      year_months[year_month] = 1 
    else
      year_months[year_month] += 1 
    end

    year_month_day = post.created_at.strftime('%Y-%m-%d')
    if year_month_days[year_month_day].nil?
      year_month_days[year_month_day] = 1 
    else
      year_month_days[year_month_day] += 1 
    end
  end
  @years = []
  years.each do |year, count|
    @years << OpenStruct.new({:year => year, :count => count})
  end
  @year_months = []
  year_months.each do |year_month, count|
    year, month = year_month.split('-')
    @year_months << OpenStruct.new({:year => year, :month => month, :count => count})
  end
  @year_month_days = []
  year_month_days.each do |year_month_day, count|
    year, month, day = year_month_day.split('-')
    @year_month_days << OpenStruct.new({:year => year, :month => month, :day => day, :count => count})
  end
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

  def category_tree(categories = Category.roots)
    html = '<ul>'
    categories.each do |category|
      html += '<li>'
      html += "<a href=\"#{category.link}\">#{category.name}</a>"
      if category.children.count > 0
        html += category_tree(category.children)
      end
      html += '</li>'
    end
    html += '</ul>'
    html
  end
end
