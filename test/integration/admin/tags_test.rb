# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/admin_helper'
require_relative '../../support/shared_examples'

class AdminTagsTest < LokkaTestCase
  include AdminLoginContext
  include SharedExamples::NotFoundPage

  def setup
    super
    @tag = create(:tag)
  end

  def teardown
    Tag.destroy_all
    super
  end

  def test_get_admin_tags_shows_index
    get '/admin/tags'
    assert last_response.ok?
  end

  def test_get_admin_tags_edit_shows_form
    get "/admin/tags/#{@tag.id}/edit"
    assert last_response.ok?
    assert_match '<form', last_response.body
  end

  def test_put_admin_tags_changes_name
    put "/admin/tags/#{@tag.id}", tag: { name: 'changed' }
    assert last_response.redirect?
    assert_equal 'changed', Tag.find(@tag.id).name
  end

  def test_delete_admin_tags_deletes_tag
    delete "/admin/tags/#{@tag.id}"
    assert last_response.redirect?
    assert_nil Tag.find_by(id: @tag.id)
  end

  def test_get_nonexistent_tag_returns_404
    Tag.destroy_all
    get '/admin/tags/9999/edit'
    assert_not_found_page
  end

  def test_put_nonexistent_tag_returns_404
    Tag.destroy_all
    put '/admin/tags/9999'
    assert_not_found_page
  end

  def test_delete_nonexistent_tag_returns_404
    Tag.destroy_all
    delete '/admin/tags/9999'
    assert_not_found_page
  end
end
