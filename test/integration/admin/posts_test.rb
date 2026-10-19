# frozen_string_literal: true

require 'nokogiri'

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

  def test_created_post_tags_are_persisted_and_shown_on_edit
    sample = attributes_for(:post, tag_collection: ' ruby!, lokka, ruby!,, 日本語 ')
    post '/admin/posts', post: sample

    assert last_response.redirect?
    entry = Post.find_by!(title: sample[:title])
    assert_equal %w[lokka ruby 日本語], entry.reload.tag_list.sort
    assert_equal ['tags'], entry.taggings.pluck(:tag_context).uniq

    get "/admin/posts/#{entry.id}/edit"
    assert_equal 'lokka,ruby,日本語', post_tag_input['value']
  end

  def test_unchanged_edit_form_submission_retains_post_tags
    @post.update!(tag_collection: 'lokka,ruby')

    get "/admin/posts/#{@post.id}/edit"
    input = post_tag_input
    put "/admin/posts/#{@post.id}", post: { tag_collection: input['value'].to_s }

    assert last_response.redirect?
    assert_equal %w[lokka ruby], @post.reload.tag_list.sort
  end

  def test_edit_replaces_post_tags
    @post.update!(tag_collection: 'old,retained')

    put "/admin/posts/#{@post.id}", post: { tag_collection: 'new,retained,new' }

    assert last_response.redirect?
    assert_equal %w[new retained], @post.reload.tag_list.sort
    get "/admin/posts/#{@post.id}/edit"
    assert_equal 'new,retained', post_tag_input['value']
  end

  def test_blank_tag_input_clears_post_tags
    @post.update!(tag_collection: 'lokka,ruby')

    put "/admin/posts/#{@post.id}", post: { tag_collection: '' }

    assert last_response.redirect?
    assert_empty @post.reload.tag_list
    get "/admin/posts/#{@post.id}/edit"
    assert_equal '', post_tag_input['value'].to_s
  end

  def test_invalid_post_creation_preserves_normalized_tag_input
    post '/admin/posts', post: { title: '', tag_collection: ' ruby!, lokka,ruby! ' }

    assert last_response.ok?
    assert_equal 'lokka,ruby', post_tag_input['value']
    assert_empty Tag.all
  end

  def test_invalid_post_update_preserves_attempted_tags_without_changing_saved_tags
    @post.update!(tag_collection: 'original')

    put "/admin/posts/#{@post.id}", post: { title: '', tag_collection: ' ruby!, lokka,ruby! ' }

    assert last_response.ok?
    assert_equal 'lokka,ruby', post_tag_input['value']
    assert_equal ['original'], @post.reload.tag_list
  end

  def test_invalid_post_update_preserves_explicitly_cleared_tag_input
    @post.update!(tag_collection: 'original')

    put "/admin/posts/#{@post.id}", post: { title: '', tag_collection: '' }

    assert last_response.ok?
    assert_equal '', post_tag_input['value'].to_s
    assert_equal ['original'], @post.reload.tag_list
  end

  def test_delete_admin_posts_deletes_post
    delete "/admin/posts/#{@post.id}"
    assert last_response.redirect?
    assert_nil Post(@post.id)
  end

  def test_get_nonexistent_post_returns_not_found
    Post.destroy_all
    get '/admin/posts/9999/edit'
    assert_not_found_page
  end

  def test_put_nonexistent_post_returns_not_found
    Post.destroy_all
    put '/admin/posts/9999'
    assert_not_found_page
  end

  def test_delete_nonexistent_post_returns_not_found
    Post.destroy_all
    delete '/admin/posts/9999'
    assert_not_found_page
  end

  private

  def post_tag_input
    input = Nokogiri::HTML(last_response.body).at_css('input[name="post[tag_collection]"]')
    refute_nil input
    input
  end
end
