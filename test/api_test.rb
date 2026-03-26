# frozen_string_literal: true

require_relative 'test_helper'

class ApiTest < LokkaTestCase
  def setup
    super
    @site = create(:site)
    @user = create(:user, name: 'apiuser', email: 'api@example.com')
    @user.generate_api_token!
    @token = @user.api_token
  end

  def auth_header
    { 'HTTP_AUTHORIZATION' => "Bearer #{@token}" }
  end

  def json_header
    auth_header.merge('CONTENT_TYPE' => 'application/json')
  end

  def json_response
    JSON.parse(last_response.body)
  end

  # --- Authentication ---

  def test_returns_401_without_token
    get '/api/v1/posts'
    assert_equal 401, last_response.status
  end

  def test_returns_401_with_invalid_token
    get '/api/v1/posts', {}, { 'HTTP_AUTHORIZATION' => 'Bearer invalid' }
    assert_equal 401, last_response.status
  end

  # --- Token ---

  def test_token_endpoint_returns_token_with_valid_credentials
    post '/api/v1/token',
         { name: 'apiuser', password: 'test' }.to_json,
         { 'CONTENT_TYPE' => 'application/json' }
    assert_equal 201, last_response.status
    body = json_response
    refute_nil body['token']
    assert_equal 'apiuser', body['user']['name']
  end

  def test_token_endpoint_returns_401_with_invalid_credentials
    post '/api/v1/token',
         { name: 'apiuser', password: 'wrong' }.to_json,
         { 'CONTENT_TYPE' => 'application/json' }
    assert_equal 401, last_response.status
  end

  # --- Posts ---

  def test_list_posts
    create(:post, user: @user)
    get '/api/v1/posts', {}, auth_header
    assert_equal 200, last_response.status
    assert_equal 1, json_response['posts'].length
    assert json_response['meta']['total_count']
  end

  def test_create_post
    post '/api/v1/posts',
         { post: { title: 'API Post', body: 'Hello', markup: 'html' } }.to_json,
         json_header
    assert_equal 201, last_response.status
    assert_equal 'API Post', json_response['post']['title']
    assert_equal @user.id, json_response['post']['user_id']
  end

  def test_create_post_with_tags
    post '/api/v1/posts',
         { post: { title: 'Tagged', body: 'body', tags: %w[ruby sinatra] } }.to_json,
         json_header
    assert_equal 201, last_response.status
    assert_includes json_response['post']['tags'], 'ruby'
    assert_includes json_response['post']['tags'], 'sinatra'
  end

  def test_create_post_returns_422_for_invalid
    post '/api/v1/posts',
         { post: { body: 'no title' } }.to_json,
         json_header
    assert_equal 422, last_response.status
    assert json_response['messages'].any? { |m| m =~ /title/i }
  end

  def test_show_post
    entry = create(:post, user: @user)
    get "/api/v1/posts/#{entry.id}", {}, auth_header
    assert_equal 200, last_response.status
    assert_equal entry.id, json_response['post']['id']
  end

  def test_update_post
    entry = create(:post, user: @user)
    put "/api/v1/posts/#{entry.id}",
        { post: { title: 'New Title' } }.to_json,
        json_header
    assert_equal 200, last_response.status
    assert_equal 'New Title', json_response['post']['title']
  end

  def test_delete_post
    entry = create(:post, user: @user)
    delete "/api/v1/posts/#{entry.id}", {}, auth_header
    assert_equal 204, last_response.status
    assert_nil Post.find_by(id: entry.id)
  end

  def test_post_not_found
    get '/api/v1/posts/999999', {}, auth_header
    assert_equal 404, last_response.status
  end

  # --- Pages ---

  def test_create_page
    post '/api/v1/pages',
         { page: { title: 'API Page', body: 'Page body' } }.to_json,
         json_header
    assert_equal 201, last_response.status
    assert_equal 'Page', json_response['page']['type']
  end

  def test_list_pages
    create(:page, user: @user)
    get '/api/v1/pages', {}, auth_header
    assert_equal 200, last_response.status
    assert_equal 1, json_response['pages'].length
  end

  # --- Categories ---

  def test_category_crud
    post '/api/v1/categories',
         { category: { title: 'Tech', slug: 'tech' } }.to_json,
         json_header
    assert_equal 201, last_response.status
    cat_id = json_response['category']['id']

    get "/api/v1/categories/#{cat_id}", {}, auth_header
    assert_equal 200, last_response.status
    assert_equal 'Tech', json_response['category']['title']

    put "/api/v1/categories/#{cat_id}",
        { category: { title: 'Technology' } }.to_json,
        json_header
    assert_equal 200, last_response.status
    assert_equal 'Technology', json_response['category']['title']

    delete "/api/v1/categories/#{cat_id}", {}, auth_header
    assert_equal 204, last_response.status
  end

  # --- Tags ---

  def test_list_and_update_tags
    tag = create(:tag)
    get '/api/v1/tags', {}, auth_header
    assert_equal 200, last_response.status

    put "/api/v1/tags/#{tag.id}",
        { tag: { name: 'renamed' } }.to_json,
        json_header
    assert_equal 200, last_response.status
    assert_equal 'renamed', json_response['tag']['name']
  end

  # --- Comments ---

  def test_create_and_list_comments
    entry = create(:post, user: @user)
    post '/api/v1/comments',
         { comment: { entry_id: entry.id, name: 'Tester', body: 'Nice!' } }.to_json,
         json_header
    assert_equal 201, last_response.status

    get '/api/v1/comments', { entry_id: entry.id }, auth_header
    assert_equal 200, last_response.status
    assert_equal 1, json_response['comments'].length
  end

  # --- Snippets ---

  def test_snippet_crud
    post '/api/v1/snippets',
         { snippet: { name: 'header', body: '<h1>Hi</h1>' } }.to_json,
         json_header
    assert_equal 201, last_response.status
    snippet_id = json_response['snippet']['id']

    put "/api/v1/snippets/#{snippet_id}",
        { snippet: { body: '<h1>Hello</h1>' } }.to_json,
        json_header
    assert_equal 200, last_response.status

    delete "/api/v1/snippets/#{snippet_id}", {}, auth_header
    assert_equal 204, last_response.status
  end

  # --- Users ---

  def test_list_users_for_admin
    get '/api/v1/users', {}, auth_header
    assert_equal 200, last_response.status
  end

  # --- Site ---

  def test_get_site_info
    get '/api/v1/site', {}, auth_header
    assert_equal 200, last_response.status
    assert_equal 'Test Site', json_response['site']['title']
  end

  def test_update_site_info
    put '/api/v1/site',
        { site: { title: 'New Title' } }.to_json,
        json_header
    assert_equal 200, last_response.status
  end

  # --- Me ---

  def test_me_endpoint
    get '/api/v1/me', {}, auth_header
    assert_equal 200, last_response.status
    assert_equal 'apiuser', json_response['user']['name']
    assert_equal @token, json_response['api_token']
  end
end
