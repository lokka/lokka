# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/admin_helper'

class AdminPermalinkTest < LokkaTestCase
  include AdminLoginContext

  def setup
    super
    Option.permalink_enabled = false
    Option.permalink_format = '/%year%/%id%'
  end

  def teardown
    Option.permalink_enabled = false
    super
  end

  def test_get_admin_permalink_shows_form
    get '/admin/permalink'
    assert last_response.ok?
    assert_match '<form', last_response.body
  end

  def test_put_admin_permalink_changes_option
    put '/admin/permalink', enable: '1', format: '/%year%/%slug%'
    assert_equal '/%year%/%slug%', Option.permalink_format
    assert_equal 'true', Option.permalink_enabled
  end

  def test_put_admin_permalink_with_incomplete_tag_shows_error
    put '/admin/permalink', enable: '1', format: '/%year%/%slug'
    follow_redirect!
    assert_match 'not closed', last_response.body
    assert_equal '/%year%/%id%', Option.permalink_format
    assert_equal 'false', Option.permalink_enabled
  end

  def test_put_admin_permalink_without_tags_shows_error
    put '/admin/permalink', enable: '1', format: '/'
    follow_redirect!
    assert_match 'should include', last_response.body
    assert_equal '/%year%/%id%', Option.permalink_format
    assert_equal 'false', Option.permalink_enabled
  end
end
