# encoding: utf-8
module Lokka
  class App < Sinatra::Base
    def self.load_plugin
      names = []
      Dir["public/plugin/lokka-*/lib/lokka/*.rb"].each do |path|
        paths = path.split(File::SEPARATOR)
        $:.push File.join(paths[0], paths[1], paths[2], paths[3])

        i18n = File.join(paths[0], paths[1], paths[2], 'i18n')
        R18n.extension_places << R18n::Loader::YAML.new(i18n) if File.exist? i18n

        name, ext = paths[5].split('.')
        require "lokka/#{name}"
        begin
          plugee = ::Lokka.const_get(name.camelize)
          register plugee
          names << name
        rescue => e
          puts "plugin #{paths[2]} is identified as a suspect."
          puts e
        end
      end

      plugins = []
      unless @routes['GET'].blank?
        matchers = @routes['GET'].map(&:first)
        names.map do |name|
          plugins << OpenStruct.new(
            :name => name,
            :have_admin_page => matchers.any? {|m| m =~ "/admin/plugins/#{name}" })
        end
      end
      set :plugins, plugins
    end

    configure do
      enable :method_override, :raise_errors, :static, :sessions
      disable :logging
      register Sinatra::R18n
      register Lokka::Before
      set :root, File.expand_path('../../..', __FILE__)
      set :public => Proc.new { File.join(root, 'public') }
      set :views => Proc.new { public }
      set :theme => Proc.new { File.join(public, 'theme') }
      set :supported_templates => %w(erb haml slim erubis)
      set :supported_stylesheet_templates => %w(scss sass)
      set :per_page, 10
      set :admin_per_page, 200
      set :default_locale, 'en'
      set :haml, :ugly => false, :attr_wrapper => '"'
      supported_stylesheet_templates.each do |style|
        set style, :style => :expanded
      end
      helpers Sinatra::ContentFor
      helpers Lokka::Helpers
      use Rack::Session::Cookie,
        :expire_after => 60 * 60 * 24 * 12
      use Rack::Flash
      load_plugin
      Lokka::Database.new.connect
    end

    get '/admin/' do
      render_any :index
    end

    get '/admin/login' do
      render_any :login, :layout => false
    end

    post '/admin/login' do
      @user = User.authenticate(params[:name], params[:password])
      if @user
        session[:user] = @user.id
        flash[:notice] = t.logged_in_successfully
        if session[:return_to]
          redirect_url = session[:return_to]
          session[:return_to] = false
          redirect redirect_url
        else
          redirect '/admin/'
        end
      else
        @login_failed = true
        render_any :login, :layout => false
      end
    end

    get '/admin/logout' do
      session[:user] = nil
      redirect '/admin/login'
    end

    # posts
    get '/admin/posts' do
      model = Post
      model = model.all(:draft => true) if params[:draft] == 'true'
      @posts = model.all(:order => :created_at.desc).
                     page(params[:page], :per_page => settings.admin_per_page)
      render_any :'posts/index'
    end

    get '/admin/posts/new' do
      @post = Post.new(:created_at => DateTime.now)
      @categories = Category.all.map {|c| [c.id, c.title] }.unshift([nil, t.not_select])
      render_any :'posts/new'
    end

    post '/admin/posts' do
      @post = Post.new(params['post'])
      @post.user = current_user
      if @post.save
        flash[:notice] = t.post_was_successfully_created
        if @post.draft
          redirect '/admin/posts?draft=true'
        else
          redirect '/admin/posts'
        end
      else
        @categories = Category.all.map {|c| [c.id, c.title] }.unshift([nil, t.not_select])
        render_any :'posts/new'
      end
    end

    get '/admin/posts/:id/edit' do |id|
      @post = Post.get(id)
      @categories = Category.all.map {|c| [c.id, c.title] }.unshift([nil, t.not_select])
      render_any :'posts/edit'
    end

    put '/admin/posts/:id' do |id|
      @post = Post.get(id)
      if @post.update(params['post'])
        flash[:notice] = t.post_was_successfully_updated
        if @post.draft
          redirect '/admin/posts?draft=true'
        else
          redirect '/admin/posts'
        end
      else
        @categories = Category.all.map {|c| [c.id, c.title] }.unshift([nil, t.not_select])
        render_any :'posts/edit'
      end
    end

    delete '/admin/posts/:id' do |id|
      post = Post.get(id)
      post.destroy
      flash[:notice] = t.post_was_successfully_deleted
      if post.draft
        redirect '/admin/posts?draft=true'
      else
        redirect '/admin/posts'
      end
    end

    # pages
    get '/admin/pages' do
      model = Page
      model = model.all(:draft => true) if params[:draft] == 'true'
      @pages = model.all(:order => :created_at.desc).
                     page(params[:page], :per_page => settings.admin_per_page)
      render_any :'pages/index'
    end

    get '/admin/pages/new' do
      @page = Page.new(:created_at => DateTime.now)
      @categories = Category.all.map {|c| [c.id, c.title] }.unshift([nil, t.not_select])
      render_any :'pages/new'
    end

    post '/admin/pages' do
      @page = Page.new(params['page'])
      @page.user = current_user
      if @page.save
        flash[:notice] = t.page_was_successfully_created
        if @page.draft
          redirect '/admin/pages?draft=true'
        else
          redirect '/admin/pages'
        end
      else
        @categories = Category.all.map {|c| [c.id, c.title] }.unshift([nil, t.not_select])
        render_any :'pages/new'
      end
    end
    
    get '/admin/pages/:id/edit' do |id|
      @page = Page.get(id)
      @categories = Category.all.map {|c| [c.id, c.title] }.unshift([nil, t.not_select])
      render_any :'pages/edit'
    end
    
    put '/admin/pages/:id' do |id|
      @page = Page.get(id)
      if @page.update(params['page'])
        flash[:notice] = t.page_was_successfully_updated
        if @page.draft
          redirect '/admin/pages?draft=true'
        else
          redirect '/admin/pages'
        end
      else
        @categories = Category.all.map {|c| [c.id, c.title] }.unshift([nil, t.not_select])
        render_any :'pages/edit'
      end
    end

    delete '/admin/pages/:id' do |id|
      page = Page.get(id)
      page.destroy
      flash[:notice] = t.page_was_successfully_deleted
      if page.draft
        redirect '/admin/pages?draft=true'
      else
        redirect '/admin/pages'
      end
    end

    # comment
    get '/admin/comments' do
      @comments = Comment.all(:order => :created_at.desc).
                    page(params[:page], :per_page => settings.admin_per_page)
      render_any :'comments/index'
    end

    get '/admin/comments/new' do
      @comment = Comment.new(:created_at => DateTime.now)
      @entries = Entry.all.map {|e| [e.id, e.title] }.unshift([nil, t.not_select])
      render_any :'comments/new'
    end

    post '/admin/comments' do
      @comment = Comment.new(params['comment'])
      if @comment.save
        flash[:notice] = t.comment_was_successfully_created
        redirect '/admin/comments'
      else
        @entries = Entry.all.map {|e| [e.id, e.title] }.unshift([nil, t.not_select])
        render_any :'comments/new'
      end
    end
    
    get '/admin/comments/:id/edit' do |id|
      @comment = Comment.get(id)
      @entries = Entry.all.map {|e| [e.id, e.title] }.unshift([nil, t.not_select])
      render_any :'comments/edit'
    end
    
    put '/admin/comments/:id' do |id|
      @comment = Comment.get(id)
      if @comment.update(params['comment'])
        flash[:notice] = t.comment_was_successfully_updated
        redirect '/admin/comments'
      else
        @entries = Entry.all.map {|e| [e.id, e.title] }.unshift([nil, t.not_select])
        render_any :'comments/edit'
      end
    end

    delete '/admin/comments/:id' do |id|
      Comment.get(id).destroy
      flash[:notice] = t.comment_was_successfully_deleted
      redirect '/admin/comments'
    end

    # category
    get '/admin/categories' do
      @categories = Category.all.
                    page(params[:page], :per_page => settings.admin_per_page)
      render_any :'categories/index'
    end
    
    get '/admin/categories/new' do
      @category = Category.new
      @categories = [nil, t.not_select] + Category.all.map {|c| [c.id, c.title] }
      render_any :'categories/new'
    end
    
    post '/admin/categories' do
      @category = Category.new(params['category'])
      #@category.user = current_user
      if @category.save
        flash[:notice] = t.category_was_successfully_created
        redirect '/admin/categories'
      else
        render_any :'categories/new'
      end
    end
    
    get '/admin/categories/:id/edit' do |id|
      @category = Category.get(id)
      render_any :'categories/edit'
    end
    
    put '/admin/categories/:id' do |id|
      @category = Category.get(id)
      if @category.update(params['category'])
        flash[:notice] = t.category_was_successfully_updated
        redirect '/admin/categories'
      else
        render_any :'categories/edit'
      end
    end

    delete '/admin/categories/:id' do |id|
      Category.get(id).destroy
      flash[:notice] = t.category_was_successfully_deleted
      redirect '/admin/categories'
    end

    # tag
    get '/admin/tags' do
      @tags = Tag.all.
                    page(params[:page], :per_page => settings.admin_per_page)
      render_any :'tags/index'
    end

    get '/admin/tags/:id/edit' do |id|
      @tag = Tag.get(id)
      render_any :'tags/edit'
    end

    put '/admin/tags/:id' do |id|
      @tag = Tag.get(id)
      if @tag.update(params['tag'])
        flash[:notice] = t.tag_was_successfully_updated
        redirect '/admin/tags'
      else
        render_any :'tags/edit'
      end
    end

    delete '/admin/tags/:id' do |id|
      Tag.get(id).destroy
      flash[:notice] = t.tag_was_successfully_deleted
      redirect '/admin/tags'
    end

    # users
    get '/admin/users' do
      @users = User.all(:order => :created_at.desc).
                    page(params[:page], :per_page => settings.admin_per_page)
      render_any :'users/index'
    end
    
    get '/admin/users/new' do
      @user = User.new
      render_any :'users/new'
    end
    
    post '/admin/users' do
      @user = User.new(params['user'])
      if @user.save
        flash[:notice] = t.user_was_successfully_created
        redirect '/admin/users'
      else
        render_any :'users/new'
      end
    end
    
    get '/admin/users/:id/edit' do |id|
      @user = User.get(id)
      render_any :'users/edit'
    end
    
    put '/admin/users/:id' do |id|
      @user = User.get(id)
      if @user.update(params['user'])
        flash[:notice] = t.user_was_successfully_updated
        redirect '/admin/users'
      else
        render_any :'users/edit'
      end
    end

    delete '/admin/users/:id' do |id|
      target_user = User.get(id)
      if current_user == target_user
        flash[:alert] = 'Can not delete your self.'
      else
        target_user.destroy
      end
      flash[:notice] = t.user_was_successfully_deleted
      redirect '/admin/users'
    end

    # snippets
    get '/admin/snippets' do
      @snippets = Snippet.all(:order => :created_at.desc).
                        page(params[:page], :per_page => settings.admin_per_page)
      render_any :'snippets/index'
    end

    get '/admin/snippets/new' do
      @snippet = Snippet.new(
        :created_at => DateTime.now,
        :updated_at => DateTime.now)
      render_any :'snippets/new'
    end

    post '/admin/snippets' do
      @snippet = Snippet.new(params['snippet'])
      if @snippet.save
        flash[:notice] = t.snippet_was_successfully_created
        redirect '/admin/snippets'
      else
        render_any :'snippets/new'
      end
    end

    get '/admin/snippets/:id/edit' do |id|
      @snippet = Snippet.get(id)
      render_any :'snippets/edit'
    end

    put '/admin/snippets/:id' do |id|
      @snippet = Snippet.get(id)
      if @snippet.update(params['snippet'])
        flash[:notice] = t.snippet_was_successfully_updated
        redirect '/admin/snippets'
      else
        render_any :'snippets/edit'
      end
    end

    delete '/admin/snippets/:id' do |id|
      Snippet.get(id).destroy
      flash[:notice] = t.snippet_was_successfully_deleted
      redirect '/admin/snippets'
    end
 
    # theme
    get '/admin/themes' do
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
      flash[:notice] = t.theme_was_successfully_updated
      redirect '/admin/themes'
    end

    # plugin
    get '/admin/plugins' do
      render_any :'plugins/index'
    end

    # site
    get '/admin/site/edit' do
      @site = Site.first
      render_any :'site/edit'
    end

    put '/admin/site' do
      if Site.first.update(params['site'])
        flash[:notice] = t.site_was_successfully_updated
        redirect '/admin/site/edit'
      else
        render_any :'site/edit'
      end
    end

    # import
    get '/admin/import' do
      render_any :import
    end

    post '/admin/import' do
      file = params['import']['file'][:tempfile]

      if file
        Lokka::Importer::WordPress.new(file).import
        flash[:notice] = t.data_was_successfully_imported
        redirect '/admin/import'
      else
        render_any :import
      end
    end

    # index
    get '/' do
      @theme_types << :index
      @theme_types << :entries

      @posts = Post.published.
                    page(params[:page], :per_page => settings.per_page)

      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add(t.home, '/')

      render_detect :index, :entries
    end

    get '/index.atom' do
      @posts = Post.published.
                    page(params[:page], :per_page => settings.per_page)
      content_type 'application/atom+xml', :charset => 'utf-8'
      builder :'system/index'
    end

    # search
    get '/search/' do
      @theme_types << :search
      @theme_types << :entries

      @query = params[:query]
      @posts = Post.published.search(@query).
                    page(params[:page], :per_page => settings.per_page)

      @title = "Search by #{@query} - #{@site.title}"

      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add(t.home, '/')
      @bread_crumbs.add(@query)

      render_detect :search, :entries
    end

    # category
    get '/category/*/' do |path|
      @theme_types << :category
      @theme_types << :entries

      category_title = path.split('/').last
      @category = Category.get_by_fuzzy_slug(category_title)
      return 404 if @category.nil?
      @posts = Post.all(:category => @category).published.
                    page(params[:page], :per_page => settings.per_page)

      @title = "#{@category.title} - #{@site.title}"

      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add(t.home, '/')
      @category.ancestors.each do |cat|
        @bread_crumbs.add(cat.name, cat.link)
      end
      @bread_crumbs.add(@category.title, @category.link)

      render_detect :category, :entries
    end

    # tag
    get '/tags/:tag/' do |tag|
      @theme_types << :tag
      @theme_types << :entries

      @tag = Tag.first(:name => tag)
      return 404 if @tag.nil?
      @posts = Post.all(:id => @tag.taggings.map {|o| o.taggable_id }).
                    published.
                    page(params[:page], :per_page => settings.per_page)
      @title = "#{@tag.name} - #{@site.title}"

      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add(t.home, '/')
      @bread_crumbs.add(@tag.name, @tag.link)

      render_detect :tag, :entries
    end

    # monthly
    get %r{^/([\d]{4})/([\d]{2})/$} do |year, month|
      @theme_types << :monthly
      @theme_types << :entries

      year, month = year.to_i, month.to_i
      @posts = Post.all(:created_at.gte => DateTime.new(year, month)).
                    all(:created_at.lt => DateTime.new(year, month) >> 1).
                    published.
                    page(params[:page], :per_page => settings.per_page)

      @title = "#{year}/#{month} - #{@site.title}"

      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add(t.home, '/')
      @bread_crumbs.add("#{year}", "/#{year}/")
      @bread_crumbs.add("#{year}/#{month}", "/#{year}/#{month}/")

      render_detect :monthly, :entries
    end

    # yearly
    get %r{^/([\d]{4})/$} do |year|
      @theme_types << :yearly
      @theme_types << :entries

      year = year.to_i
      @posts = Post.all(:created_at.gte => DateTime.new(year)).
                    all(:created_at.lt => DateTime.new(year + 1)).
                    published.
                    page(params[:page], :per_page => settings.per_page)

      @title = "#{year} - #{@site.title}"

      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add(t.home, '/')
      @bread_crumbs.add("#{year}", "/#{year}/")

      render_detect :yearly, :entries
    end

    # entry
    get %r{^/([0-9a-zA-Z-]+)$} do |id_or_slug|
      @theme_types << :entry

      @entry = Entry.get_by_fuzzy_slug(id_or_slug)
      return 404 if @entry.blank?

      type = @entry.class.name.downcase.to_sym
      @theme_types << type
      eval "@#{type} = @entry"

      @title = "#{@entry.title} - #{@site.title}"

      @bread_crumbs = BreadCrumb.new
      @bread_crumbs.add(t.home, '/')
      if @entry.category
        @entry.category.ancestors.each do |cat|
          @bread_crumbs.add(cat.name, cat.link)
        end
        @bread_crumbs.add(@entry.category.title, @entry.category.link)
      end
      @bread_crumbs.add(@entry.title, @entry.link)

      render_detect type, :entry
    end

    # comment
    post %r{^/([0-9a-zA-Z-]+)$} do |id_or_slug|
      @theme_types << :entry

      @entry = Entry.get_by_fuzzy_slug(id_or_slug)
      return 404 if @entry.blank?
      return 404 if params[:check] != 'check'

      @comment = @entry.comments.new(params['comment'])

      unless params['comment']['status'] # unless status value is overridden by plugins
        @comment[:status] = logged_in? ? Comment::APPROVED : Comment::MODERATED
      else
       @comment[:status] = params['comment']['status']
      end

      if @comment.save
        redirect @entry.link
      else
        render_any :entry
      end
    end

    not_found do
      if output = render_any(:'404', :layout => false)
        output
      else
        haml :'404', :views => 'public/system', :layout => false
      end
    end

    error do
      'Error: ' + env['sinatra.error'].name
    end

    get '/*.css' do |path|
      content_type 'text/css', :charset => 'utf-8'
      render_any path.to_sym
    end
  end
end
