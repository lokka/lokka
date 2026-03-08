# frozen_string_literal: true

require_relative '../test_helper'

class UserTest < LokkaTestCase
  def test_new_user_saves_successfully
    user = User.new(
      name: 'Johnny',
      email: 'johnny@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
    assert user.save
  end

  def test_new_user_with_blank_name_fails_to_save
    user = User.new(
      name: '',
      email: 'johnny@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
    refute user.save
  end

  def test_new_user_with_blank_email_fails_to_save
    user = User.new(
      name: 'Johnny',
      email: '',
      password: 'password',
      password_confirmation: 'password'
    )
    refute user.save
  end

  def test_new_user_trims_whitespace_after_save
    user = User.new(
      name: ' Johnny Depp ',
      email: 'johnny@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
    user.save
    assert_equal 'Johnny Depp', user.name
  end

  def test_existing_user_updates_successfully
    user = create(:user, name: 'Johnny')
    assert user.save
  end

  def test_existing_user_with_blank_name_fails_to_save
    user = create(:user, name: 'Johnny')
    user.name = ''
    refute user.save
  end

  def test_existing_user_with_blank_email_fails_to_save
    user = create(:user, name: 'Johnny')
    user.email = ''
    refute user.save
  end

  def test_existing_user_trims_whitespace_after_save
    user = create(:user, name: 'Johnny')
    user.name = ' Johnny Depp '
    user.save
    assert_equal 'Johnny Depp', user.name
  end
end

class GuestUserTest < LokkaTestCase
  def test_guest_user_is_not_admin
    refute GuestUser.new.admin?
  end

  def test_guest_user_permission_level_is_zero
    assert_equal 0, GuestUser.new.permission_level
  end
end
