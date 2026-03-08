# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/admin_helper'
require_relative '../../support/custom_assertions'

class AdminPostsTest < LokkaTestCase
  include AdminLoginContext
  include CustomAssertions::NotFoundPage

  def setup
    super
    @post = create(:post)
    create(:draft_post)
  end

  def teardown
    Post.destroy_all
    super
  end

  def test_get_admin_posts_shows_all_posts
    get '/admin/posts'
    assert_match 'Test Post', last_response.body
    assert_match 'Draft Post', last_response.body
  end

  def test_get_admin_posts_with_draft_option_shows_only_drafts
    get '/admin/posts', draft: 'true'
    refute_match(/Test Post \d+/, last_response.body)
    assert_match 'Draft Post', last_response.body
  end

  def test_get_admin_posts_new_shows_form
    get '/admin/posts/new'
    assert_match '<form', last_response.body
  end

  def test_post_admin_posts_creates_new_post
    sample = attributes_for(:post, slug: 'created_now')
    post '/admin/posts', post: sample
    assert last_response.redirect?
    refute_nil Post('created_now')
  end

  def test_get_admin_posts_edit_shows_form
    get "/admin/posts/#{@post.id}/edit"
    assert_match '<form', last_response.body
    assert_match 'Test Post', last_response.body
  end

  def test_put_admin_posts_updates_body
    put "/admin/posts/#{@post.id}", post: { body: 'updated' }
    assert last_response.redirect?
    assert_equal 'updated', Post(@post.id).body
  end

  def test_delete_admin_posts_deletes_post
    delete "/admin/posts/#{@post.id}"
    assert last_response.redirect?
    assert_nil Post(@post.id)
  end

  def test_get_nonexistent_post_returns_404
    Post.destroy_all
    get '/admin/posts/9999/edit'
    assert_not_found_page
  end

  def test_put_nonexistent_post_returns_404
    Post.destroy_all
    put '/admin/posts/9999'
    assert_not_found_page
  end

  def test_delete_nonexistent_post_returns_404
    Post.destroy_all
    delete '/admin/posts/9999'
    assert_not_found_page
  end
end
