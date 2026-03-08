# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/admin_helper'
require_relative '../../support/shared_examples'

class AdminUsersTest < LokkaTestCase
  include AdminLoginContext
  include SharedExamples::NotFoundPage

  def setup
    super
    @user = User.first
  end

  def test_get_admin_users_shows_index
    get '/admin/users'
    assert last_response.ok?
  end

  def test_get_admin_users_new_shows_form
    get '/admin/users/new'
    assert last_response.ok?
    assert_match '<form', last_response.body
  end

  def test_post_admin_users_creates_new_user
    user_params = {
      name: 'lokka tarou',
      email: 'tarou@example.com',
      password: 'test',
      password_confirmation: 'test'
    }
    post '/admin/users', user: user_params
    assert last_response.redirect?
    refute_nil User.find_by(name: 'lokka tarou')
  end

  def test_post_admin_users_fails_when_passwords_do_not_match
    user_params = {
      name: 'lokka tarou',
      email: 'tarou@example.com',
      password: 'test',
      password_confirmation: 'wrong'
    }
    post '/admin/users', user: user_params
    assert last_response.ok?
    assert_nil User.find_by(name: 'lokka tarou')
    assert_match '<form', last_response.body
  end

  def test_get_admin_users_edit_shows_form
    get "/admin/users/#{@user.id}/edit"
    assert last_response.ok?
    assert_match '<form', last_response.body
  end

  def test_put_admin_users_updates_name
    put "/admin/users/#{@user.id}", user: { name: 'newbie' }
    assert last_response.redirect?
    assert_equal 'newbie', User.find(@user.id).name
  end

  def test_delete_admin_users_deletes_another_user
    another_user = create(:user)
    delete "/admin/users/#{another_user.id}"
    assert last_response.redirect?
    assert_nil User.find_by(id: another_user.id)
  end

  def test_delete_admin_users_does_not_delete_current_user
    delete "/admin/users/#{@user.id}"
    assert last_response.redirect?
    refute_nil User.find_by(id: @user.id)
  end

  def test_get_nonexistent_user_returns_404
    User.destroy_all
    get '/admin/users/9999/edit'
    assert_not_found_page
  end

  def test_put_nonexistent_user_returns_404
    User.destroy_all
    put '/admin/users/9999'
    assert_not_found_page
  end

  def test_delete_nonexistent_user_returns_404
    User.destroy_all
    delete '/admin/users/9999'
    assert_not_found_page
  end
end
