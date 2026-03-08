# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/admin_helper'

class AdminThemesTest < LokkaTestCase
  include AdminLoginContext

  def test_get_admin_themes_shows_index
    get '/admin/themes'
    assert last_response.ok?
    assert_match 'curvy', last_response.body
  end

  def test_put_admin_themes_changes_theme
    put '/admin/themes', title: 'curvy'
    assert last_response.redirect?
    assert_equal 'curvy', Site.first.theme
  end
end
