# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/admin_helper'

class AdminPreviewTest < LokkaTestCase
  include AdminLoginContext

  def test_post_admin_previews_with_valid_params_succeeds
    params = {
      raw_body: "## Dinner\n\n1. Ramen\n2. Udon\n3. Tempura\n",
      markup: 'redcarpet'
    }

    post '/admin/previews', params

    assert last_response.successful?

    expected_html = <<~HTML
      <h2>Dinner</h2>

      <ol>
      <li>Ramen</li>
      <li>Udon</li>
      <li>Tempura</li>
      </ol>
    HTML

    assert_equal expected_html, JSON.parse(last_response.body)['body']
  end
end
