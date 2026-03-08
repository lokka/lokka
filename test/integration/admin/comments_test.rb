# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/admin_helper'
require_relative '../../support/shared_examples'

class AdminCommentsTest < LokkaTestCase
  include AdminLoginContext
  include SharedExamples::NotFoundPage

  def setup
    super
    @post = create(:post)
    @comment = create(:comment, entry: @post)
    create(:spam_comment, entry: @post)
  end

  def teardown
    Comment.destroy_all
    Post.destroy_all
    super
  end

  def test_get_admin_comments_shows_index
    get '/admin/comments'
    assert last_response.ok?
  end

  def test_get_admin_comments_new_shows_form
    get '/admin/comments/new'
    assert last_response.ok?
    assert_match '<form', last_response.body
  end

  def test_post_admin_comments_creates_new_comment
    Comment.destroy_all
    sample = attributes_for(:comment, entry_id: @post.id)
    post '/admin/comments', comment: sample
    assert last_response.redirect?
    assert_equal 1, Post(@post.id).comments.count
  end

  def test_get_admin_comments_edit_shows_form
    get "/admin/comments/#{@comment.id}/edit"
    assert_match '<form', last_response.body
    assert_match 'Test Comment', last_response.body
  end

  def test_put_admin_comments_updates_body
    put "/admin/comments/#{@comment.id}", comment: { body: 'updated' }
    assert last_response.redirect?
    assert_equal 'updated', Comment(@comment.id).body
  end

  def test_delete_admin_comments_deletes_comment
    delete "/admin/comments/#{@comment.id}"
    assert last_response.redirect?
    assert_nil Comment(@comment.id)
  end

  def test_delete_admin_comments_spam_deletes_spam_comments
    delete '/admin/comments/spam'
    assert last_response.redirect?
    assert_equal 0, Comment.spam.size
  end

  def test_get_nonexistent_comment_returns_404
    Comment.destroy_all
    get '/admin/comments/9999/edit'
    assert_not_found_page
  end

  def test_put_nonexistent_comment_returns_404
    Comment.destroy_all
    put '/admin/comments/9999'
    assert_not_found_page
  end

  def test_delete_nonexistent_comment_returns_404
    Comment.destroy_all
    delete '/admin/comments/9999'
    assert_not_found_page
  end

  def test_xmp_tag_in_comment_name_is_escaped
    @comment.update(name: '<xmp>')
    get '/admin/comments'
    assert_match(/&lt;xmp&gt;/, last_response.body)
  end
end
