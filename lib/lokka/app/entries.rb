module Lokka
  class App
    # index
    get '/' do
      @theme_types << :index
      @theme_types << :entries

      @posts = Post.
        page(params[:page] || 1).
        per(@site.per_page).
        order(@site.default_order)

      @title = @site.title

      @bread_crumbs = [{ name: t('home'), link: '/' }]

      render_detect :index, :entries
    end

    get '/index.atom' do
      @posts = Post.
        page(params[:page] || 1).
        per(@site.per_page).
        order(@site.default_order)

      content_type 'application/atom+xml', :charset => 'utf-8'
      builder :'lokka/index'
    end

    # search
    get '/search/:query' do
      @theme_types << :search
      @theme_types << :entries

      @query = params[:query]
      @posts = Post.
        search(@query).
        order(@site.default_order).
        page(params[:page]).
        per(@site.per_page)

      @title = "Search by #{@query}"

      @bread_crumbs = [{:name => t('home'), :link => '/'},
                       {:name => @query }]

      render_detect :search, :entries
    end

    # category
    get '/category/:slug' do
      @theme_types << :category
      @theme_types << :entries

      @category = Category.get_by_fuzzy_slug(params[:slug]) || halt(404)
      @posts = @category.entries.
        page(params[:page] || 1).
        per(@site.per_page).
        order(@site.default_order)

      @title = @category.title

      @bread_crumbs = [{ name: t('home'), link: '/' }]

      @bread_crumbs << { name: @category.title, link: @category.link }

      render_detect :category, :entries
    end

    get '/tags/:name' do
      @theme_types << :tag
      @theme_types << :entries

      @tag = Tag.where(name: params[:name]).first || halt(404)
      @posts = @tag.entries.
        page(params[:page]).
        per(@site.per_page).
        order(@site.default_order)

      @title = @tag.name

      @bread_crumbs = [{ name: t('home'), link: '/' },
                       { name: @tag.name, link: @tag.link }]

      render_detect :tag, :entries
    end

    # monthly
    get %r{^/([\d]{4})/([\d]{2})/$} do |year, month|
      @theme_types << :monthly
      @theme_types << :entries

      year, month = year.to_i, month.to_i
      @posts = Post.
        between_a_month(DateTime.new(year, month)).
        page(params[:page]).
        per(@site.per_page).
        order(@site.default_order)

      @title = "#{year}/#{month}"

      @bread_crumbs = [{ name: t('home'), link: '/' },
                       { name: "#{year}", link: "/#{year}/" },
                       { name: "#{year}/#{month}", link: "/#{year}/#{month}/" }]

      render_detect :monthly, :entries
    end

    # yearly
    get %r{^/([\d]{4})/$} do |year|
      @theme_types << :yearly
      @theme_types << :entries

      year = year.to_i
      @posts = Post.
        between_a_year(DateTime.new(year)).
        page(params[:page]).
        per(@site.per_page).
        order(@site.default_order)

      @title = year

      @bread_crumbs = [{ name: t('home'), link: '/' },
                       { name: "#{year}", link: "/#{year}/" }]

      render_detect :yearly, :entries
    end

    # entry
    get %r{^/([_/0-9a-zA-Z-]+)$} do |id_or_slug|
      @entry = Post.get_by_fuzzy_slug(id_or_slug) || halt(404)

      redirect to(@entry.link) if @entry.type == Post && custom_permalink?

      @comment = @entry.comments.build

      setup_and_render_entry
    end

    # comment
    post %r{^/([_/0-9a-zA-Z-]+)$} do |id_or_slug|
      @theme_types << :entry

      @entry = Entry.get_by_fuzzy_slug(id_or_slug)
      return 404 if !@entry || @entry.blank?
      return 404 if params[:check] != 'check'

      @comment = @entry.comments.build(params['comment'])

      unless params['comment']['status'] # unless status value is overridden by plugins
        @comment[:status] = logged_in? ? Comment::APPROVED : Comment::MODERATED
      else
        @comment[:status] = params['comment']['status']
      end

      if @comment.save
        redirect to(@entry.link)
      else
        render_any :entry
      end
    end
  end
end
