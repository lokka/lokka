# encoding: utf-8
require 'lokka'

module Lokka
  class App < Sinatra::Base
    include Padrino::Helpers::TranslationHelpers

    configure :development do
      register Sinatra::Reloader
    end

    configure do
      enable :method_override, :raise_errors, :static, :sessions
      disable :logging
      YAML::ENGINE.yamler = 'syck' if YAML.const_defined?(:ENGINE)
      register Padrino::Helpers
      register Lokka::Before
      set :app_file, __FILE__
      set :root, File.expand_path('../../..', __FILE__)
      set :public_folder => Proc.new { File.join(root, 'public') }
      set :views => Proc.new { public_folder }
      set :theme => Proc.new { File.join(public_folder, 'theme') }
      set :supported_templates => %w(erb haml slim erubis)
      set :supported_stylesheet_templates => %w(scss sass)
      set :per_page, 10
      set :admin_per_page, 200
      set :default_locale, 'en'
      set :haml, :ugly => false, :attr_wrapper => '"'
      supported_stylesheet_templates.each do |style|
        set style, :style => :expanded
      end
      ::I18n.load_path += Dir["#{root}/i18n/*.yml"]
      helpers Lokka::Helpers
      use Rack::Session::Cookie,
        :expire_after => 60 * 60 * 24 * 12
      set:session_secret, 'development' if development?
      use Rack::Flash
      register Lokka::Plugin::Loader
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
        flash[:notice] = t('logged_in_successfully')
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
    get   ('/admin/posts')          { get_admin_entries(Post) }
    get   ('/admin/posts/new')      { get_admin_entry_new(Post) }
    post  ('/admin/posts')          { post_admin_entry(Post) }
    get   ('/admin/posts/:id/edit') { |id| get_admin_entry_edit(Post, id) }
    put   ('/admin/posts/:id')      { |id| put_admin_entry(Post, id) }
    delete('/admin/posts/:id')      { |id| delete_admin_entry(Post, id) }

    # pages
    get   ('/admin/pages')          { get_admin_entries(Page) }
    get   ('/admin/pages/new')      { get_admin_entry_new(Page) }
    post  ('/admin/pages')          { post_admin_entry(Page) }
    get   ('/admin/pages/:id/edit') { |id| get_admin_entry_edit(Page, id) }
    put   ('/admin/pages/:id')      { |id| put_admin_entry(Page, id) }
    delete('/admin/pages/:id')      { |id| delete_admin_entry(Page, id) }

    # comment
    get '/admin/comments' do
      @comments = Comment.all(:order => :created_at.desc).
                    page(params[:page], :per_page => settings.admin_per_page)
      render_any :'comments/index'
    end

    get '/admin/comments/new' do
      @comment = Comment.new(:created_at => DateTime.now)
      render_any :'comments/new'
    end

    post '/admin/comments' do
      @comment = Comment.new(params['comment'])
      if @comment.save
        flash[:notice] = t('comment_was_successfully_created')
        redirect '/admin/comments'
      else
        render_any :'comments/new'
      end
    end

    get '/admin/comments/:id/edit' do |id|
      @comment = Comment.get(id)
      render_any :'comments/edit'
    end

    put '/admin/comments/:id' do |id|
      @comment = Comment.get(id)
      if @comment.update(params['comment'])
        flash[:notice] = t('comment_was_successfully_updated')
        redirect '/admin/comments'
      else
        render_any :'comments/edit'
      end
    end

    delete '/admin/comments/:id' do |id|
      Comment.get(id).destroy
      flash[:notice] = t('comment_was_successfully_deleted')
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
      render_any :'categories/new'
    end

    post '/admin/categories' do
      @category = Category.new(params['category'])
      #@category.user = current_user
      if @category.save
        flash[:notice] = t('category_was_successfully_created')
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
        flash[:notice] = t('category_was_successfully_updated')
        redirect '/admin/categories'
      else
        render_any :'categories/edit'
      end
    end

    delete '/admin/categories/:id' do |id|
      Category.get(id).destroy
      flash[:notice] = t('category_was_successfully_deleted')
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
        flash[:notice] = t('tag_was_successfully_updated')
        redirect '/admin/tags'
      else
        render_any :'tags/edit'
      end
    end

    delete '/admin/tags/:id' do |id|
      Tag.get(id).destroy
      flash[:notice] = t('tag_was_successfully_deleted')
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
        flash[:notice] = t('user_was_successfully_created')
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
        flash[:notice] = t('user_was_successfully_updated')
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
      flash[:notice] = t('user_was_successfully_deleted')
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
        flash[:notice] = t('snippet_was_successfully_created')
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
        flash[:notice] = t('snippet_was_successfully_updated')
        redirect '/admin/snippets'
      else
        render_any :'snippets/edit'
      end
    end

    delete '/admin/snippets/:id' do |id|
      Snippet.get(id).destroy
      flash[:notice] = t('snippet_was_successfully_deleted')
      redirect '/admin/snippets'
    end

    # theme
    get '/admin/themes' do
      @themes =
        (Dir.glob("#{settings.theme}/*") - Dir.glob("#{settings.theme}/*[-_]mobile")).map do |f|
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
      flash[:notice] = t('theme_was_successfully_updated')
      redirect '/admin/themes'
    end

    # mobile_theme
    get '/admin/mobile_themes' do
      @themes =
        Dir.glob("#{settings.theme}/*[-_]mobile").map do |f|
          title = f.split('/').last
          s = Dir.glob("#{f}/screenshot.*")
          screenshot = s.empty? ? nil : "/#{s.first.split('/')[-3, 3].join('/')}"
          OpenStruct.new(:title => title, :screenshot => screenshot)
        end
      render_any :'mobile_themes/index'
    end

    put '/admin/mobile_themes' do
      site = Site.first
      site.update(:mobile_theme => params[:title])
      flash[:notice] = t('theme_was_successfully_updated')
      redirect '/admin/mobile_themes'
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
        flash[:notice] = t('site_was_successfully_updated')
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
        flash[:notice] = t('data_was_successfully_imported')
        redirect '/admin/import'
      else
        render_any :import
      end
    end

    # permalink
    get '/admin/permalink' do
      @enabled = (Option.permalink_enabled == "true")
      @format = Option.permalink_format || ""
      render_any :permalink
    end

    put '/admin/permalink' do
      errors = []

      format = params[:format]
      format = "/#{format}" unless /^\// =~ format

      errors << t('permalink.error.no_tags') unless /%.+%/ =~ format
      errors << t('permalink.error.tag_unclosed') unless format.chars.select{|c| c == '%' }.size.even?

      if errors.empty?
        Option.permalink_enabled = (params[:enable] == "1")
        Option.permalink_format  = params[:format].sub(/\/$/,"")
        flash[:notice] = t('site_was_successfully_updated')
      else
        flash[:error] = (["<ul>"] + errors.map{|e| "<li>#{e}</li>" } + ["</ul>"]).join("\n")
        flash[:permalink_format] = format
      end

      redirect '/admin/permalink'
    end

    # index
    get '/' do
      @theme_types << :index
      @theme_types << :entries

      @posts = Post.published.
                    page(params[:page], :per_page => settings.per_page, :order => :created_at.desc)
      @posts = apply_continue_reading(@posts)

      @title = @site.title

      @bread_crumbs = [{:name => t('home'), :link => '/'}]

      render_detect :index, :entries
    end

    get '/index.atom' do
      @posts = Post.published.
                    page(params[:page], :per_page => settings.per_page, :order => :created_at.desc)
      @posts = apply_continue_reading(@posts)
      content_type 'application/atom+xml', :charset => 'utf-8'
      builder :'system/index'
    end

    # search
    get '/search/' do
      @theme_types << :search
      @theme_types << :entries

      @query = params[:query]
      @posts = Post.published.search(@query).
                    page(params[:page], :per_page => settings.per_page, :order => :created_at.desc)
      @posts = apply_continue_reading(@posts)

      @title = "Search by #{@query}"

      @bread_crumbs = [{:name => t('home'), :link => '/'},
                       {:name => @query }]

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
                    page(params[:page], :per_page => settings.per_page, :order => :created_at.desc)
      @posts = apply_continue_reading(@posts)

      @title = @category.title

      @bread_crumbs = [{:name => t('home'), :link => '/'}]
      @category.ancestors.each do |cat|
        @bread_crumbs << {:name => cat.name, :link => cat.link}
      end
      @bread_crumbs << {:name => @category.title, :link => @category.link}

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
                    page(params[:page], :per_page => settings.per_page, :order => :created_at.desc)
      @posts = apply_continue_reading(@posts)

      @title = @tag.name

      @bread_crumbs = [{:name => t('home'), :link => '/'},
                       {:name => @tag.name, :link => @tag.link}]

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
                    page(params[:page], :per_page => settings.per_page, :order => :created_at.desc)
      @posts = apply_continue_reading(@posts)

      @title = "#{year}/#{month}"

      @bread_crumbs = [{:name => t('home'), :link => '/'},
                       {:name => "#{year}", :link => "/#{year}/"},
                       {:name => "#{year}/#{month}", :link => "/#{year}/#{month}/"}]

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
                    page(params[:page], :per_page => settings.per_page, :order => :created_at.desc)
      @posts = apply_continue_reading(@posts)

      @title = year

      @bread_crumbs = [{:name => t('home'), :link => '/'},
                       {:name => "#{year}", :link => "/#{year}/"}]

      render_detect :yearly, :entries
    end

    # entry
    get %r{^/([_/0-9a-zA-Z-]+)$} do |id_or_slug|
      @entry = Entry.get_by_fuzzy_slug(id_or_slug)

      return 404 if @entry.blank?
      redirect @entry.link if @entry.type == Post && custom_permalink?

      setup_and_render_entry
    end

    # comment
    post %r{^/([_/0-9a-zA-Z-]+)$} do |id_or_slug|
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
      if custom_permalink?
        r = custom_permalink_parse(request.path)

        return redirect(request.path.sub(/\/$/,"")) if /\/$/ =~ request.path

        url_changed = false
        [:year, :month, :monthnum, :day, :hour, :minute, :second].each do |k|
          i = (k == :year ? 4 : 2)
          (r[k] = r[k].rjust(i,'0'); url_changed = true) if r[k] && r[k].size < i
        end

        return redirect(custom_permalink_path(r)) if url_changed

        conditions, flags = r.inject([{},{}]) {|(conds, flags), (tag, value)|
          case tag
          when :year
            flags[:year] = value.to_i
            flags[:time] = true
          when :monthnum, :month
            flags[:month] = value.to_i
            flags[:time] = true
          when :day
            flags[:day] = value.to_i
            flags[:time] = true
          when :hour
            flags[:hour] = value.to_i
            flags[:time] = true
          when :minute
            flags[:minute] = value.to_i
            flags[:time] = true
          when :second
            flags[:second] = value.to_i
            flags[:time] = true
          when :post_id, :id
            conds[:id] = value.to_i
          when :postname, :slug
            conds[:slug] = value
          when :category
            conds[:category_id] = Category(value).id
          end
          [conds, flags]
        }

        if flags[:time]
          time_order = [:year, :month, :day, :hour, :minute, :second]
          args, last = time_order.inject([[],nil]) do |(result,last), key|
            break [result, key] unless flags[key]
            [result << flags[key], nil]
          end
          args = [0,1,1,0,0,0].each_with_index.map{|default,i| args[i] || default }
          conditions[:created_at.gte] = Time.local(*args)
          args[time_order.index(last)-1] += 1
          conditions[:created_at.lt] = Time.local(*args)
        end

        @entry = Entry.first(conditions)
        return setup_and_render_entry if @entry
      end

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

    run! if app_file == $0
  end
end
