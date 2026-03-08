# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/admin_helper'

class AdminOthersTest < LokkaTestCase
  include AdminLoginContext

  def test_get_admin_index_shows_dashboard
    get '/admin/'
    assert last_response.ok?
  end

  def test_get_admin_plugins_shows_index
    get '/admin/plugins'
    assert last_response.ok?
  end

  def test_get_admin_site_edit_shows_form
    get '/admin/site/edit'
    assert last_response.ok?
    assert_match '<form', last_response.body
  end

  def test_put_admin_site_updates_site_information
    put '/admin/site', site: { description: 'new' }
    assert last_response.redirect?
    assert_equal 'new', Site.first.description
  end

  def test_get_admin_import_shows_form
    get '/admin/import'
    assert last_response.ok?
    assert_match '<form', last_response.body
  end
end
