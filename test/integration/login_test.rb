# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../support/shared_examples'

class LoginTest < LokkaTestCase
  include SharedExamples::LoginFailed

  def setup
    super
    create(:site)
    create(:user, name: 'test')
  end

  def test_valid_login_redirects_to_admin
    post '/admin/login', name: 'test', password: 'test'
    assert last_response.redirect?
    follow_redirect!
    assert_equal '/admin/', last_request.env['PATH_INFO']
  end

  def test_invalid_username_fails_login
    post '/admin/login', name: 'wrong', password: 'test'
    assert_login_failed
  end

  def test_invalid_password_fails_login
    post '/admin/login', name: 'test', password: 'wrong'
    assert_login_failed
  end

  def test_invalid_username_and_password_fails_login
    post '/admin/login', name: 'wrong', password: 'wrong'
    assert_login_failed
  end
end
