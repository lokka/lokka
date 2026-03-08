# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/admin_helper'
require_relative '../../support/shared_examples'

class AdminPagesTest < LokkaTestCase
  include AdminLoginContext
  include SharedExamples::NotFoundPage

  def setup
    super
    @page = create(:page)
    create(:draft_page)
  end

  def teardown
    Page.destroy_all
    super
  end

  def test_get_admin_pages_shows_all_pages
    get '/admin/pages'
    assert_match 'Test Page', last_response.body
    assert_match 'Draft Page', last_response.body
  end

  def test_get_admin_pages_with_draft_option_shows_only_drafts
    get '/admin/pages', draft: 'true'
    refute_match(/Test Page \d+/, last_response.body)
    assert_match 'Draft Page', last_response.body
  end

  def test_get_admin_pages_new_shows_form
    get '/admin/pages/new'
    assert_match '<form', last_response.body
  end

  def test_post_admin_pages_creates_new_page
    sample = attributes_for(:page, slug: 'dekitate')
    post '/admin/pages', page: sample
    assert last_response.redirect?
    refute_nil Page('dekitate')
  end

  def test_get_admin_pages_edit_shows_form
    get "/admin/pages/#{@page.id}/edit"
    assert_match '<form', last_response.body
    assert_match 'Test Page', last_response.body
  end

  def test_put_admin_pages_updates_body
    put "/admin/pages/#{@page.id}", page: { body: 'updated' }
    assert last_response.redirect?
    assert_equal 'updated', Page(@page.id).body
  end

  def test_delete_admin_pages_deletes_page
    delete "/admin/pages/#{@page.id}"
    assert last_response.redirect?
    assert_nil Page(@page.id)
  end

  def test_get_nonexistent_page_returns_404
    Page.destroy_all
    get '/admin/pages/9999/edit'
    assert_not_found_page
  end

  def test_put_nonexistent_page_returns_404
    Page.destroy_all
    put '/admin/pages/9999'
    assert_not_found_page
  end

  def test_delete_nonexistent_page_returns_404
    Page.destroy_all
    delete '/admin/pages/9999'
    assert_not_found_page
  end
end
