# frozen_string_literal: true

require 'json'

module Lokka
  class App
    # ---------------------------------------------------------------------------
    # JSON API  –  /api/v1/*
    #
    # Authentication: Bearer token in Authorization header
    #   Authorization: Bearer <user.api_token>
    # ---------------------------------------------------------------------------

    before '/api/v1/*' do
      content_type :json

      # Skip CSRF protection for API requests
      env['rack.protection.csrf.token'] = true

      # /api/v1/token uses name/password auth, not Bearer token
      pass if request.path_info == '/api/v1/token' && request.post?

      token = extract_bearer_token
      @api_user = User.authenticate_by_token(token)
      unless @api_user
        halt 401, { error: 'Unauthorized', message: 'Invalid or missing API token' }.to_json
      end
    end

    helpers do
      def extract_bearer_token
        auth = request.env['HTTP_AUTHORIZATION'].to_s
        match = auth.match(/\ABearer\s+(.+)\z/i)
        match ? match[1].strip : nil
      end

      def json_body
        @json_body ||= begin
          body = request.body.read
          body.empty? ? {} : JSON.parse(body)
        rescue JSON::ParserError
          halt 400, { error: 'Bad Request', message: 'Invalid JSON' }.to_json
        end
      end

      def entry_json(entry)
        {
          id: entry.id,
          type: entry.type,
          title: entry.title,
          body: entry.raw_body,
          slug: entry.slug,
          markup: entry.markup,
          draft: entry.draft,
          category_id: entry.category_id,
          user_id: entry.user_id,
          tags: entry.tag_list,
          link: entry.link,
          created_at: entry.created_at&.iso8601,
          updated_at: entry.updated_at&.iso8601
        }
      end

      def category_json(category)
        {
          id: category.id,
          title: category.title,
          slug: category.slug,
          description: category.description,
          parent_id: category.parent_id,
          created_at: category.created_at&.iso8601,
          updated_at: category.updated_at&.iso8601
        }
      end

      def tag_json(tag)
        {
          id: tag.id,
          name: tag.name,
          created_at: tag.created_at&.iso8601,
          updated_at: tag.updated_at&.iso8601
        }
      end

      def comment_json(comment)
        {
          id: comment.id,
          entry_id: comment.entry_id,
          status: comment.status,
          name: comment.name,
          email: comment.email,
          homepage: comment.homepage,
          body: comment.body,
          created_at: comment.created_at&.iso8601,
          updated_at: comment.updated_at&.iso8601
        }
      end

      def user_json(user)
        {
          id: user.id,
          name: user.name,
          email: user.email,
          permission_level: user.permission_level,
          created_at: user.created_at&.iso8601,
          updated_at: user.updated_at&.iso8601
        }
      end

      def snippet_json(snippet)
        {
          id: snippet.id,
          name: snippet.name,
          body: snippet.body,
          created_at: snippet.created_at&.iso8601,
          updated_at: snippet.updated_at&.iso8601
        }
      end

      def paginate(scope)
        page = (params[:page] || 1).to_i
        per  = [(params[:per_page] || 20).to_i, 100].min
        scope.page(page).per(per)
      end

      def pagination_meta(collection)
        {
          current_page: collection.current_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count,
          per_page: collection.limit_value
        }
      end

      def require_admin!
        unless @api_user.admin?
          halt 403, { error: 'Forbidden', message: 'Admin access required' }.to_json
        end
      end
    end

    # ---- Posts ----------------------------------------------------------------

    get '/api/v1/posts' do
      posts = params[:draft] == 'true' ? Post.unpublished : Post.published
      posts = paginate(posts)
      { posts: posts.map { |p| entry_json(p) }, meta: pagination_meta(posts) }.to_json
    end

    get '/api/v1/posts/:id' do |id|
      post = Post.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)
      { post: entry_json(post) }.to_json
    end

    post '/api/v1/posts' do
      attrs = json_body['post'] || {}
      post = Post.new(attrs.slice('title', 'body', 'slug', 'markup', 'draft', 'category_id'))
      post.user = @api_user
      post.tag_collection = attrs['tags'].join(',') if attrs['tags'].is_a?(Array)
      post.tag_collection = attrs['tag_collection'] if attrs['tag_collection']

      if post.save
        status 201
        { post: entry_json(post.reload) }.to_json
      else
        status 422
        { error: 'Validation Failed', messages: post.errors.full_messages }.to_json
      end
    end

    put '/api/v1/posts/:id' do |id|
      post = Post.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)
      attrs = json_body['post'] || {}
      post.tag_collection = attrs.delete('tags').join(',') if attrs['tags'].is_a?(Array)
      post.tag_collection = attrs.delete('tag_collection') if attrs['tag_collection']

      if post.update(attrs.slice('title', 'body', 'slug', 'markup', 'draft', 'category_id'))
        { post: entry_json(post) }.to_json
      else
        status 422
        { error: 'Validation Failed', messages: post.errors.full_messages }.to_json
      end
    end

    delete '/api/v1/posts/:id' do |id|
      post = Post.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)
      post.destroy
      status 204
      ''
    end

    # ---- Pages ----------------------------------------------------------------

    get '/api/v1/pages' do
      pages = params[:draft] == 'true' ? Page.unpublished : Page.published
      pages = paginate(pages)
      { pages: pages.map { |p| entry_json(p) }, meta: pagination_meta(pages) }.to_json
    end

    get '/api/v1/pages/:id' do |id|
      page = Page.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)
      { page: entry_json(page) }.to_json
    end

    post '/api/v1/pages' do
      attrs = json_body['page'] || {}
      page = Page.new(attrs.slice('title', 'body', 'slug', 'markup', 'draft', 'category_id'))
      page.user = @api_user
      page.tag_collection = attrs['tags'].join(',') if attrs['tags'].is_a?(Array)
      page.tag_collection = attrs['tag_collection'] if attrs['tag_collection']

      if page.save
        status 201
        { page: entry_json(page.reload) }.to_json
      else
        status 422
        { error: 'Validation Failed', messages: page.errors.full_messages }.to_json
      end
    end

    put '/api/v1/pages/:id' do |id|
      page = Page.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)
      attrs = json_body['page'] || {}
      page.tag_collection = attrs.delete('tags').join(',') if attrs['tags'].is_a?(Array)
      page.tag_collection = attrs.delete('tag_collection') if attrs['tag_collection']

      if page.update(attrs.slice('title', 'body', 'slug', 'markup', 'draft', 'category_id'))
        { page: entry_json(page) }.to_json
      else
        status 422
        { error: 'Validation Failed', messages: page.errors.full_messages }.to_json
      end
    end

    delete '/api/v1/pages/:id' do |id|
      page = Page.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)
      page.destroy
      status 204
      ''
    end

    # ---- Categories -----------------------------------------------------------

    get '/api/v1/categories' do
      categories = paginate(Category.order(:title))
      { categories: categories.map { |c| category_json(c) }, meta: pagination_meta(categories) }.to_json
    end

    get '/api/v1/categories/:id' do |id|
      category = Category.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)
      { category: category_json(category) }.to_json
    end

    post '/api/v1/categories' do
      attrs = json_body['category'] || {}
      category = Category.new(attrs.slice('title', 'slug', 'description', 'parent_id'))

      if category.save
        status 201
        { category: category_json(category) }.to_json
      else
        status 422
        { error: 'Validation Failed', messages: category.errors.full_messages }.to_json
      end
    end

    put '/api/v1/categories/:id' do |id|
      category = Category.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)

      if category.update((json_body['category'] || {}).slice('title', 'slug', 'description', 'parent_id'))
        { category: category_json(category) }.to_json
      else
        status 422
        { error: 'Validation Failed', messages: category.errors.full_messages }.to_json
      end
    end

    delete '/api/v1/categories/:id' do |id|
      category = Category.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)
      category.destroy
      status 204
      ''
    end

    # ---- Tags -----------------------------------------------------------------

    get '/api/v1/tags' do
      tags = paginate(Tag.order(:name))
      { tags: tags.map { |t| tag_json(t) }, meta: pagination_meta(tags) }.to_json
    end

    get '/api/v1/tags/:id' do |id|
      tag = Tag.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)
      { tag: tag_json(tag) }.to_json
    end

    put '/api/v1/tags/:id' do |id|
      tag = Tag.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)

      if tag.update((json_body['tag'] || {}).slice('name'))
        { tag: tag_json(tag) }.to_json
      else
        status 422
        { error: 'Validation Failed', messages: tag.errors.full_messages }.to_json
      end
    end

    delete '/api/v1/tags/:id' do |id|
      tag = Tag.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)
      tag.destroy
      status 204
      ''
    end

    # ---- Comments -------------------------------------------------------------

    get '/api/v1/comments' do
      comments = Comment.order(created_at: :desc)
      comments = comments.where(entry_id: params[:entry_id]) if params[:entry_id]
      comments = paginate(comments)
      { comments: comments.map { |c| comment_json(c) }, meta: pagination_meta(comments) }.to_json
    end

    get '/api/v1/comments/:id' do |id|
      comment = Comment.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)
      { comment: comment_json(comment) }.to_json
    end

    post '/api/v1/comments' do
      attrs = json_body['comment'] || {}
      comment = Comment.new(attrs.slice('entry_id', 'name', 'email', 'homepage', 'body', 'status'))

      if comment.save
        status 201
        { comment: comment_json(comment) }.to_json
      else
        status 422
        { error: 'Validation Failed', messages: comment.errors.full_messages }.to_json
      end
    end

    put '/api/v1/comments/:id' do |id|
      comment = Comment.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)

      if comment.update((json_body['comment'] || {}).slice('name', 'email', 'homepage', 'body', 'status'))
        { comment: comment_json(comment) }.to_json
      else
        status 422
        { error: 'Validation Failed', messages: comment.errors.full_messages }.to_json
      end
    end

    delete '/api/v1/comments/:id' do |id|
      comment = Comment.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)
      comment.destroy
      status 204
      ''
    end

    # ---- Users (admin only) ---------------------------------------------------

    get '/api/v1/users' do
      require_admin!
      users = paginate(User.order(created_at: :desc))
      { users: users.map { |u| user_json(u) }, meta: pagination_meta(users) }.to_json
    end

    get '/api/v1/users/:id' do |id|
      require_admin!
      user = User.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)
      { user: user_json(user) }.to_json
    end

    # ---- Snippets -------------------------------------------------------------

    get '/api/v1/snippets' do
      snippets = paginate(Snippet.order(created_at: :desc))
      { snippets: snippets.map { |s| snippet_json(s) }, meta: pagination_meta(snippets) }.to_json
    end

    get '/api/v1/snippets/:id' do |id|
      snippet = Snippet.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)
      { snippet: snippet_json(snippet) }.to_json
    end

    post '/api/v1/snippets' do
      attrs = json_body['snippet'] || {}
      snippet = Snippet.new(attrs.slice('name', 'body'))

      if snippet.save
        status 201
        { snippet: snippet_json(snippet) }.to_json
      else
        status 422
        { error: 'Validation Failed', messages: snippet.errors.full_messages }.to_json
      end
    end

    put '/api/v1/snippets/:id' do |id|
      snippet = Snippet.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)

      if snippet.update((json_body['snippet'] || {}).slice('name', 'body'))
        { snippet: snippet_json(snippet) }.to_json
      else
        status 422
        { error: 'Validation Failed', messages: snippet.errors.full_messages }.to_json
      end
    end

    delete '/api/v1/snippets/:id' do |id|
      snippet = Snippet.find_by(id: id) || halt(404, { error: 'Not Found' }.to_json)
      snippet.destroy
      status 204
      ''
    end

    # ---- Current User / Token -------------------------------------------------

    get '/api/v1/me' do
      { user: user_json(@api_user), api_token: @api_user.api_token }.to_json
    end

    post '/api/v1/token' do
      # Authenticate with name/password, returns (or generates) an API token
      name = json_body['name'] || json_body['username']
      password = json_body['password']

      user = User.authenticate(name, password)
      unless user
        halt 401, { error: 'Unauthorized', message: 'Invalid credentials' }.to_json
      end

      user.generate_api_token! if user.api_token.blank?

      status 201
      { token: user.api_token, user: user_json(user) }.to_json
    end

    # ---- Site -----------------------------------------------------------------

    get '/api/v1/site' do
      site = Site.first
      {
        site: {
          title: site.title,
          description: site.description,
          theme: site.theme,
          per_page: site.per_page,
          default_markup: site.default_markup,
          meta_description: site.meta_description,
          meta_keywords: site.meta_keywords
        }
      }.to_json
    end

    put '/api/v1/site' do
      require_admin!
      site = Site.first
      attrs = json_body['site'] || {}

      if site.update(attrs.slice('title', 'description', 'theme', 'per_page',
                                 'default_markup', 'meta_description', 'meta_keywords'))
        { site: { title: site.title, description: site.description, theme: site.theme } }.to_json
      else
        status 422
        { error: 'Validation Failed', messages: site.errors.full_messages }.to_json
      end
    end
  end
end
