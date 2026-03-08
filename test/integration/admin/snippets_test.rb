# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/admin_helper'
require_relative '../../support/shared_examples'

class AdminSnippetsTest < LokkaTestCase
  include AdminLoginContext
  include SharedExamples::NotFoundPage

  def setup
    super
    @snippet = create(:snippet)
  end

  def teardown
    Snippet.destroy_all
    super
  end

  def test_get_admin_snippets_shows_index
    get '/admin/snippets'
    assert last_response.ok?
  end

  def test_get_admin_snippets_new_shows_form
    get '/admin/snippets/new'
    assert last_response.ok?
    assert_match '<form', last_response.body
  end

  def test_post_admin_snippets_creates_new_snippet
    sample = attributes_for(:snippet, name: 'Created Snippet')
    post '/admin/snippets', snippet: sample
    assert last_response.redirect?
    refute_nil Snippet('Created Snippet')
  end

  def test_get_admin_snippets_edit_shows_form
    get "/admin/snippets/#{@snippet.id}/edit"
    assert last_response.ok?
    assert_match '<form', last_response.body
  end

  def test_put_admin_snippets_updates_body
    put "/admin/snippets/#{@snippet.id}", snippet: { body: 'updated' }
    assert last_response.redirect?
    assert_equal 'updated', Snippet.find(@snippet.id).body
  end

  def test_delete_admin_snippets_deletes_snippet
    delete "/admin/snippets/#{@snippet.id}"
    assert last_response.redirect?
    assert_nil Snippet.find_by(id: @snippet.id)
  end

  def test_get_nonexistent_snippet_returns_404
    Snippet.destroy_all
    get '/admin/snippets/9999/edit'
    assert_not_found_page
  end

  def test_put_nonexistent_snippet_returns_404
    Snippet.destroy_all
    put '/admin/snippets/9999'
    assert_not_found_page
  end

  def test_delete_nonexistent_snippet_returns_404
    Snippet.destroy_all
    delete '/admin/snippets/9999'
    assert_not_found_page
  end
end
