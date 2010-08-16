module Pyha
  class App < Sinatra::Base
    set :root, File.expand_path('../../..', __FILE__)
    set :public => Proc.new { File.join(root, 'public') }
    set :views => Proc.new { File.join(public, 'theme', Site.first(:name => 'theme').value) }
    set :theme => Proc.new { File.join(public, 'theme') }
    set :per_page, 10

    configure do
      use Rack::Session::Cookie,
        :expire_after => 60 * 60 * 24 * 12,
        :secret => '_p_y_h_a_'
      use Rack::Flash
    end

    helpers Pyha::Helpers

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
    
    post '/admin/signup' do
      @user = User.new(params[:user])
      if @user.save
        session[:user] = @user.id
        redirect '/admin/'
      else
        render_any :signup
      end
    end
    
    get '/admin/users' do
      login_required
      @users = User.all
      render_any :'users/index'
    end
    
    get '/admin/documents' do
      login_required
      @documents = Document.all
      render_any :'documents/index'
    end

    
    # index
    get '/' do
      @theme_types << :index
      @theme_types << :documents
    
      @posts = Post.page(params[:page], :per_page => settings.per_page)
    
      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add('Home', '/')

      render_detect :index, :documents
    end
    
    # search
    get '/search/' do
      @theme_types << :search
      @theme_types << :documents
    
      @query = params[:query]
      @posts = Post.search(@query).
                    page(params[:page], :per_page => settings.per_page)
    
      @title = "Search by #{@query} - #{@site.title}"
    
      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add('Home', '/')
      @bread_crumbs.add('Search', '/search/')
    
      render_detect :search, :documents
    end
    
    # category
    get '/category/*/' do |path|
      @theme_types << :category
      @theme_types << :documents
    
      category_name = path.split('/').last
      @category = Category.get_by_name_or_slug(category_name)
      return 404 if @category.nil?
      @posts = Post.all(:category => @category).
                    page(params[:page], :per_page => settings.per_page)
    
      @title = "#{@category.name} - #{@site.title}"
    
      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add('Home', '/')
      @category.ancestors.each do |cat|
        @bread_crumbs.add(cat.name, cat.link)
      end
      @bread_crumbs.add(@category.name, @category.link)

      render_detect :category, :documents
    end
    
    # monthly
    get %r{/([\d]{4})/([\d]{2})/} do |year, month|
      @theme_types << :monthly
      @theme_types << :documents
    
      year, month = year.to_i, month.to_i
      @posts = Post.all(:created_at.gte => DateTime.new(year, month)).
                    all(:created_at.lt => DateTime.new(year, month) >> 1).
                    page(params[:page], :per_page => settings.per_page)
    
      @title = "#{year}/#{month} - #{@site.title}"
    
      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add('Home', '/')
      @bread_crumbs.add("#{year}", "/#{year}/")
      @bread_crumbs.add("#{year}/#{month}", "/#{year}/#{month}/")
    
      render_detect :monthly, :documents
    end
    
    # yearly
    get %r{/([\d]{4})/} do |year|
      @theme_types << :yearly
      @theme_types << :documents
    
      year = year.to_i
      @posts = Post.all(:created_at.gte => DateTime.new(year)).
                    all(:created_at.lt => DateTime.new(year + 1)).
                    page(params[:page], :per_page => settings.per_page)
    
      @title = "#{year} - #{@site.title}"
    
      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add('Home', '/')
      @bread_crumbs.add("#{year}", "/#{year}/")
    
      render_detect :yearly, :documents
    end
    
    # document
    get %r{/([0-9a-zA-Z-]+)} do |id_or_slug|
      @theme_types << :document
    
      @document = Document.get_by_fuzzy_slug(id_or_slug)
    
      @title = "#{@document.title} - #{@site.title}"
    
      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add('Home', '/')
      @document.category.ancestors.each do |cat|
        @bread_crumbs.add(cat.name, cat.link)
      end
      @bread_crumbs.add(@document.category.name, @document.category.link)
      @bread_crumbs.add(@document.title, @document.link)
    
      render_any :document
    end
    
    error 404 do
      'File not found'
    end
    
    before do
      if request.path_info =~ %r{/admin/.*}
        settings.views = File.join(settings.public, 'admin') 
      end

      @site = Site.to_ostruct
      @title = @site.title
      @theme = Theme.new(options.theme)
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
  end
end
