# frozen_string_literal: true

module SharedExamples
  module NotFoundPage
    def assert_not_found_page
      assert_equal 404, last_response.status
    end
  end

  module LoginFailed
    def assert_login_failed
      refute last_response.redirect?, 'Expected no redirect'
      assert_match '<body class="admin_login">', last_response.body
      refute_match '<div id="aside">', last_response.body
    end
  end

  module UserWithValidation
    def assert_user_validation(user)
      assert user.save, 'User should save successfully'

      user.name = ''
      refute user.save, 'User with blank name should not save'
      user.reload

      user.email = ''
      refute user.save, 'User with blank email should not save'
      user.reload

      user.name = ' Johnny Depp '
      user.save
      assert_equal 'Johnny Depp', user.name
    end
  end
end
