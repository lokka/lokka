module Pyha
  class App < Sinatra::Base
    enable :method_override
    set :root, File.expand_path('../../..', __FILE__)
    set :public => Proc.new { File.join(root, 'public') }
    set :views => Proc.new { public }
    set :theme => Proc.new { File.join(public, 'theme') }
    set :supported_templates => %w(erb haml)
    set :per_page, 10
    set :admin_per_page, 50
    set :default_locale, 'en'
    set :haml, :ugly => false, :attr_wrapper => '"'

    configure do
      use Rack::Session::Cookie,
        :expire_after => 60 * 60 * 24 * 12,
        :secret => '_p_y_h_a_'
      use Rack::Flash
    end

    register Sinatra::R18n
    register Sinatra::Logger
    helpers Pyha::Helpers

    set :logger_level, :debug

    get '/admin/' do
      login_required
      render_any :index
    end
    
    get '/admin/login' do
      render_any :login
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
        render_any :login
      end
    end
    
    get '/admin/logout' do
      login_required
      session[:user] = nil
      flash[:notice] = 'Logout successful'
      redirect '/admin/login'
    end
    
    get '/admin/signup' do
      render_any :signup
    end
    
#    post '/admin/signup' do
#      @user = User.new(params[:user])
#      if @user.save
#        session[:user] = @user.id
#        redirect '/admin/'
#      else
#        render_any :signup
#      end
#    end
    
    # posts
    get '/admin/posts' do
      login_required
      @posts = Post.all(:order => :created_at.desc).
                    page(params[:page], :per_page => settings.admin_per_page)
      render_any :'posts/index'
    end
    
    get '/admin/posts/new' do
      login_required
      @post = Post.new
      @categories = Category.all.map {|c| [c.id, c.title] }.unshift([nil, t.not_select])
      render_any :'posts/new'
    end
    
    post '/admin/posts' do
      login_required
      @post = Post.new(params['post'])
      @post.user = current_user
      if @post.save
        redirect '/admin/posts'
      else
        render_any :'posts/new'
      end
    end
    
    get '/admin/posts/:id/edit' do |id|
      login_required
      @post = Post.get(id)
      @categories = Category.all.map {|c| [c.id, c.title] }.unshift([nil, t.not_select])
      render_any :'posts/edit'
    end
    
    put '/admin/posts/:id' do |id|
      login_required
      @post = Post.get(id)
      if @post.update(params['post'])
        redirect "/admin/posts/#{id}/edit"
      else
        render_any :'posts/edit'
      end
    end

    delete '/admin/posts/:id' do |id|
      Post.get(id).destroy
      redirect "/admin/posts"
    end
    
    # pages
    get '/admin/pages' do
      login_required
      @pages = Page.all(:order => :created_at.desc).
                    page(params[:page], :per_page => settings.admin_per_page)
      render_any :'pages/index'
    end
    
    get '/admin/pages/new' do
      login_required
      @page = Page.new
      @categories = Category.all.map {|c| [c.id, c.title] }.unshift([nil, t.not_select])
      render_any :'pages/new'
    end
    
    post '/admin/pages' do
      login_required
      @page = Page.new(params['page'])
      @page.user = current_user
      if @page.save
        redirect '/admin/pages'
      else
        @categories = Category.all.map {|c| [c.id, c.title] }.unshift([nil, t.not_select])
        render_any :'pages/new'
      end
    end
    
    get '/admin/pages/:id/edit' do |id|
      login_required
      @page = Page.get(id)
      @categories = Category.all.map {|c| [c.id, c.title] }.unshift([nil, t.not_select])
      render_any :'pages/edit'
    end
    
    put '/admin/pages/:id' do |id|
      login_required
      @page = Page.get(id)
      if @page.update(params['page'])
        redirect "/admin/pages/#{id}/edit"
      else
        @categories = Category.all.map {|c| [c.id, c.title] }.unshift([nil, t.not_select])
        render_any :'pages/edit'
      end
    end

    delete '/admin/pages/:id' do |id|
      Page.get(id).destroy
      redirect "/admin/pages"
    end

    # category
    get '/admin/categories' do
      login_required
      @categories = Category.all.
                    page(params[:page], :per_page => settings.admin_per_page)
      render_any :'categories/index'
    end
    
    get '/admin/categories/new' do
      login_required
      @category = Category.new
      @categories = [nil, t.not_select] + Category.all.map {|c| [c.id, c.title] }
      render_any :'categories/new'
    end
    
    post '/admin/categories' do
      login_required
      @category = Category.new(params['category'])
      @category.user = current_user
      if @category.save
        redirect '/admin/categories'
      else
        render_any :'categories/new'
      end
    end
    
    get '/admin/categories/:id/edit' do |id|
      login_required
      @category = Category.get(id)
      render_any :'categories/edit'
    end
    
    put '/admin/categories/:id' do |id|
      login_required
      @category = Category.get(id)
      if @category.update(params['category'])
        redirect "/admin/categories/#{id}/edit"
      else
        render_any :'categories/edit'
      end
    end

    delete '/admin/categories/:id' do |id|
      Category.get(id).destroy
      redirect "/admin/categories"
    end

    # users
    get '/admin/users' do
      login_required
      @users = User.all(:order => :created_at.desc).
                    page(params[:page], :per_page => settings.admin_per_page)
      render_any :'users/index'
    end
    
    get '/admin/users/new' do
      login_required
      @user = User.new
      render_any :'users/new'
    end
    
    post '/admin/users' do
      login_required
      @user = User.new(params['user'])
      if @user.save
        redirect '/admin/users'
      else
        render_any :'users/new'
      end
    end
    
    get '/admin/users/:id/edit' do |id|
      login_required
      @user = User.get(id)
      render_any :'users/edit'
    end
    
    put '/admin/users/:id' do |id|
      login_required
      @user = User.get(id)
      if @user.update(params['user'])
        redirect "/admin/users/#{id}/edit"
      else
        render_any :'users/edit'
      end
    end

    delete '/admin/users/:id' do |id|
      User.get(id).destroy
      redirect "/admin/users"
    end

    # theme
    get '/admin/themes' do
      login_required
      @themes =
        Dir.glob("#{settings.theme}/*").map do |f|
          title = f.split('/').last
          s = Dir.glob("#{f}/screenshot.*")
          screenshot = s.empty? ? nil : "/#{s.first.split('/')[-3, 3].join('/')}"
          OpenStruct.new(:title => title, :screenshot => screenshot)
        end
      render_any :'themes/index'
    end

    put '/admin/themes' do
      site = Site.first
      site.update(:theme => params[:title])
      redirect '/admin/themes'
    end

    # site
    get '/admin/site/edit' do
      login_required
      @site = Site.first
      render_any :'site/edit'
    end

    put '/admin/site' do
      login_required
      if Site.first.update(params['site'])
        redirect '/admin/site/edit'
      else
        render_any :'site/edit'
      end
    end

    # index
    get '/' do
      @theme_types << :index
      @theme_types << :entries

      @posts = Post.page(params[:page], :per_page => settings.per_page)

      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add('Home', '/')

#      render_detect :index, :entries
      render_any :entries, :layout => :layout
    end

    get '/index.atom' do
      settings.views = File.join(settings.public, 'system') 
      @posts = Post.page(params[:page], :per_page => settings.per_page)
      content_type 'application/atom+xml', :charset => 'utf-8'
      builder :index
    end

    # search
    get '/search/' do
      @theme_types << :search
      @theme_types << :entries

      @query = params[:query]
      @posts = Post.search(@query).
                    page(params[:page], :per_page => settings.per_page)

      @title = "Search by #{@query} - #{@site.title}"

      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add('Home', '/')
      @bread_crumbs.add('Search', '/search/')

      render_detect :search, :entries
    end

    # category
    get '/category/*/' do |path|
      @theme_types << :category
      @theme_types << :entries

      category_title = path.split('/').last
      @category = Category.get_by_fuzzy_slug(category_title)
      return 404 if @category.nil?
      @posts = Post.all(:category => @category).
                    page(params[:page], :per_page => settings.per_page)

      @title = "#{@category.title} - #{@site.title}"

      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add('Home', '/')
      @category.ancestors.each do |cat|
        @bread_crumbs.add(cat.name, cat.link)
      end
      @bread_crumbs.add(@category.title, @category.link)

      render_detect :category, :entries
    end

    # monthly
    get %r{/([\d]{4})/([\d]{2})/} do |year, month|
      @theme_types << :monthly
      @theme_types << :entries

      year, month = year.to_i, month.to_i
      @posts = Post.all(:created_at.gte => DateTime.new(year, month)).
                    all(:created_at.lt => DateTime.new(year, month) >> 1).
                    page(params[:page], :per_page => settings.per_page)

      @title = "#{year}/#{month} - #{@site.title}"

      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add('Home', '/')
      @bread_crumbs.add("#{year}", "/#{year}/")
      @bread_crumbs.add("#{year}/#{month}", "/#{year}/#{month}/")

      render_detect :monthly, :entries
    end

    # yearly
    get %r{/([\d]{4})/} do |year|
      @theme_types << :yearly
      @theme_types << :entries

      year = year.to_i
      @posts = Post.all(:created_at.gte => DateTime.new(year)).
                    all(:created_at.lt => DateTime.new(year + 1)).
                    page(params[:page], :per_page => settings.per_page)

      @title = "#{year} - #{@site.title}"

      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add('Home', '/')
      @bread_crumbs.add("#{year}", "/#{year}/")

      render_detect :yearly, :entries
    end

    # entry
    get %r{/([0-9a-zA-Z-]+)} do |id_or_slug|
      @theme_types << :entry

logger.info "id_or_slug: #{id_or_slug}"
      @entry = Entry.get_by_fuzzy_slug(id_or_slug)
logger.info "@entry.title: #{@entry.title}"

      @title = "#{@entry.title} - #{@site.title}"

      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add('Home', '/')
      if @entry.category
        @entry.category.ancestors.each do |cat|
          @bread_crumbs.add(cat.name, cat.link)
        end
        @bread_crumbs.add(@entry.category.title, @entry.category.link)
      end
      @bread_crumbs.add(@entry.title, @entry.link)

      render_any :entry
    end

    error 404 do
      'File not found'
    end

    before do
      @site = Site.first
      @title = @site.title
      @theme = Theme.new(settings.theme)
      @theme_types = []

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
      @years.sort! {|x, y| y.year <=> x.year }
      @year_months = []
      year_months.each do |year_month, count|
        year, month = year_month.split('-')
        @year_months << OpenStruct.new({:year => year, :month => month, :count => count})
      end
      @year_months.sort! {|x, y| y.year + y.month <=> x.year + x.month }
      @year_month_days = []
      year_month_days.each do |year_month_day, count|
        year, month, day = year_month_day.split('-')
        @year_month_days << OpenStruct.new({:year => year, :month => month, :day => day, :count => count})
      end
      @year_month_days.sort! {|x, y| y.year + y.month + y.day <=> x.year + x.month + x.day }
    end
  end
end
