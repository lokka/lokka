# frozen_string_literal: true

require_relative 'integration_helper'

module AdminLoginContext
  include InSiteContext

  def setup
    super
    create(:user, name: 'test')
    post '/admin/login', name: 'test', password: 'test'
    follow_redirect!
  end
end
