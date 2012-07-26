module Lokka
  class App
    get '/admin/' do
      haml :admin_index, :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    get '/admin/login' do
      haml :login, :views => Lokka.admin_theme_dir, :layout => false
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
          redirect to('/admin/')
        end
      else
        @login_failed = true
        haml :login, :layout => false, :views => Lokka.admin_theme_dir, :layout => :admin_layout
      end
    end

    get '/admin/logout' do
      session[:user] = nil
      redirect to('/admin/login')
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
      haml :'comments/index', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    get '/admin/comments/new' do
      @comment = Comment.new(:created_at => DateTime.now)
      haml :'comments/new', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    post '/admin/comments' do
      @comment = Comment.new(params['comment'])
      if @comment.save
        flash[:notice] = t('comment_was_successfully_created')
        redirect to('/admin/comments')
      else
        haml :'comments/new', :views => Lokka.admin_theme_dir, :layout => :admin_layout
      end
    end

    get '/admin/comments/:id/edit' do |id|
      @comment = Comment.get(id) or raise Sinatra::NotFound
      haml :'comments/edit', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    put '/admin/comments/:id' do |id|
      @comment = Comment.get(id) or raise Sinatra::NotFound
      if @comment.update(params['comment'])
        flash[:notice] = t('comment_was_successfully_updated')
        redirect to('/admin/comments')
      else
        haml :'comments/edit', :views => Lokka.admin_theme_dir, :layout => :admin_layout
      end
    end

    delete '/admin/comments/spam' do
      Comment.spam.destroy
      flash[:notice] = t('comment_was_successfully_deleted')
      redirect to('/admin/comments')
    end

    delete '/admin/comments/:id' do |id|
      comment = Comment.get(id) or raise Sinatra::NotFound
      comment.destroy
      flash[:notice] = t('comment_was_successfully_deleted')
      redirect to('/admin/comments')
    end

    # category
    get '/admin/categories' do
      @categories = Category.all.
                    page(params[:page], :per_page => settings.admin_per_page)
      haml :'categories/index', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    get '/admin/categories/new' do
      @category = Category.new
      haml :'categories/new', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    post '/admin/categories' do
      params['category'].delete('parent_id') if params['category']['parent_id'].blank?
      @category = Category.new(params['category'])
      #@category.user = current_user
      if @category.save
        flash[:notice] = t('category_was_successfully_created')
        redirect to('/admin/categories')
      else
        haml :'categories/new', :views => Lokka.admin_theme_dir, :layout => :admin_layout
      end
    end

    get '/admin/categories/:id/edit' do |id|
      @category = Category.get(id) or raise Sinatra::NotFound
      haml :'categories/edit', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    put '/admin/categories/:id' do |id|
      @category = Category.get(id) or raise Sinatra::NotFound
      params['category'].delete('parent_id') if params['category']['parent_id'].blank?
      if @category.update(params['category'])
        flash[:notice] = t('category_was_successfully_updated')
        redirect to('/admin/categories')
      else
        haml :'categories/edit', :views => Lokka.admin_theme_dir, :layout => :admin_layout
      end
    end

    delete '/admin/categories/:id' do |id|
      category = Category.get(id) or raise Sinatra::NotFound
      category.destroy
      flash[:notice] = t('category_was_successfully_deleted')
      redirect to('/admin/categories')
    end

    # tag
    get '/admin/tags' do
      @tags = Tag.all.
                    page(params[:page], :per_page => settings.admin_per_page)
      haml :'tags/index', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    get '/admin/tags/:id/edit' do |id|
      @tag = Tag.get(id) or raise Sinatra::NotFound
      haml :'tags/edit', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    put '/admin/tags/:id' do |id|
      @tag = Tag.get(id) or raise Sinatra::NotFound
      if @tag.update(params['tag'])
        flash[:notice] = t('tag_was_successfully_updated')
        redirect to('/admin/tags')
      else
        haml :'tags/edit', :views => Lokka.admin_theme_dir, :layout => :admin_layout
      end
    end

    delete '/admin/tags/:id' do |id|
      tag = Tag.get(id) or raise Sinatra::NotFound
      tag.destroy
      flash[:notice] = t('tag_was_successfully_deleted')
      redirect to('/admin/tags')
    end

    # users
    get '/admin/users' do
      @users = User.all(:order => :created_at.desc).
                    page(params[:page], :per_page => settings.admin_per_page)
      haml :'users/index', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    get '/admin/users/new' do
      @user = User.new
      haml :'users/new', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    post '/admin/users' do
      @user = User.new(params['user'])
      if @user.save
        flash[:notice] = t('user_was_successfully_created')
        redirect to('/admin/users')
      else
        haml :'users/new', :views => Lokka.admin_theme_dir, :layout => :admin_layout
      end
    end

    get '/admin/users/:id/edit' do |id|
      @user = User.get(id) or raise Sinatra::NotFound
      haml :'users/edit', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    put '/admin/users/:id' do |id|
      @user = User.get(id) or raise Sinatra::NotFound
      if @user.update(params['user'])
        flash[:notice] = t('user_was_successfully_updated')
        redirect to('/admin/users')
      else
        haml :'users/edit', :views => Lokka.admin_theme_dir, :layout => :admin_layout
      end
    end

    delete '/admin/users/:id' do |id|
      target_user = User.get(id) or raise Sinatra::NotFound
      if current_user == target_user
        flash[:alert] = 'Can not delete your self.'
      else
        target_user.destroy
      end
      flash[:notice] = t('user_was_successfully_deleted')
      redirect to('/admin/users')
    end

    # snippets
    get '/admin/snippets' do
      @snippets = Snippet.all(:order => :created_at.desc).
                        page(params[:page], :per_page => settings.admin_per_page)
      haml :'snippets/index', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    get '/admin/snippets/new' do
      @snippet = Snippet.new(
        :created_at => DateTime.now,
        :updated_at => DateTime.now)
      haml :'snippets/new', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    post '/admin/snippets' do
      @snippet = Snippet.new(params['snippet'])
      if @snippet.save
        flash[:notice] = t('snippet_was_successfully_created')
        redirect to('/admin/snippets')
      else
        haml :'snippets/new', :views => Lokka.admin_theme_dir, :layout => :admin_layout
      end
    end

    get '/admin/snippets/:id/edit' do |id|
      @snippet = Snippet.get(id) or raise Sinatra::NotFound
      haml :'snippets/edit', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    put '/admin/snippets/:id' do |id|
      @snippet = Snippet.get(id) or raise Sinatra::NotFound
      if @snippet.update(params['snippet'])
        flash[:notice] = t('snippet_was_successfully_updated')
        redirect to('/admin/snippets')
      else
        haml :'snippets/edit', :views => Lokka.admin_theme_dir, :layout => :admin_layout
      end
    end

    delete '/admin/snippets/:id' do |id|
      snippet = Snippet.get(id) or raise Sinatra::NotFound
      snippet.destroy
      flash[:notice] = t('snippet_was_successfully_deleted')
      redirect to('/admin/snippets')
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
      haml :'themes/index', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    put '/admin/themes' do
      site = Site.first
      site.update(:theme => params[:title])
      flash[:notice] = t('theme_was_successfully_updated')
      redirect to('/admin/themes')
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
      haml :'mobile_themes/index', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    put '/admin/mobile_themes' do
      site = Site.first
      site.update(:mobile_theme => params[:title])
      flash[:notice] = t('theme_was_successfully_updated')
      redirect to('/admin/mobile_themes')
    end

    # plugin
    get '/admin/plugins' do
      haml :'plugins/index', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    # site
    get '/admin/site/edit' do
      @site = Site.first
      haml :'site/edit', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    put '/admin/site' do
      if Site.first.update(params['site'])
        flash[:notice] = t('site_was_successfully_updated')
        redirect to('/admin/site/edit')
      else
        haml :'site/edit', :views => Lokka.admin_theme_dir, :layout => :admin_layout
      end
    end

    # import
    get '/admin/import' do
      haml :import, :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    post '/admin/import' do
      file = params['import']['file'][:tempfile]

      if file
        Lokka::Importer::WordPress.new(file).import
        flash[:notice] = t('data_was_successfully_imported')
        redirect to('/admin/import')
      else
        haml :import, :views => Lokka.admin_theme_dir, :layout => :admin_layout
      end
    end

    # permalink
    get '/admin/permalink' do
      @enabled = (Option.permalink_enabled == "true")
      @format = Option.permalink_format || ""
      haml :permalink, :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    put '/admin/permalink' do
      errors = []

      if params[:enable] == "1"
        format = params[:format]
        format = "/#{format}" unless /^\// =~ format

        errors << t('permalink.error.no_tags') unless /%.+%/ =~ format
        errors << t('permalink.error.tag_unclosed') unless format.chars.select{|c| c == '%' }.size.even?
      end

      if errors.empty?
        Option.permalink_enabled = (params[:enable] == "1")
        Option.permalink_format  = params[:format].sub(/\/$/,"")
        flash[:notice] = t('site_was_successfully_updated')
      else
        flash[:error] = (["<ul>"] + errors.map{|e| "<li>#{e}</li>" } + ["</ul>"]).join("\n")
        flash[:permalink_format] = format
      end

      redirect to('/admin/permalink')
    end

    # field names
    get '/admin/field_names' do
      @field_names = FieldName.all.
                        page(params[:page], :per_page => settings.admin_per_page, :order => :name.asc)
      haml :'field_names/index', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    get '/admin/field_names/new' do
      @field_name = FieldName.new(
        :created_at => DateTime.now,
        :updated_at => DateTime.now)
      haml :'field_names/new', :views => Lokka.admin_theme_dir, :layout => :admin_layout
    end

    post '/admin/field_names' do
      @field_name = FieldName.new(params['field_name'])
      if @field_name.save
        flash[:notice] = t('field_name_was_successfully_created')
        redirect to('/admin/field_names')
      else
        haml :'field_names/new', :views => Lokka.admin_theme_dir, :layout => :admin_layout
      end
    end

    delete '/admin/field_names/:id' do |id|
      field_name = FieldName.get(id) or raise Sinatra::NotFound
      field_name.destroy
      flash[:notice] = t('field_name_was_successfully_deleted')
      redirect to('/admin/field_names')
    end
  end
end
