# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../support/integration_helper'

class TurnstileTest < LokkaTestCase
  include InSiteContext

  def setup
    super
    Option.turnstile_site_key = 'test-site-key'
    Option.turnstile_secret_key = 'test-secret-key'
    Site.first.update!(theme: 'one-column-neue')
    @post = create(:post)
  end

  def test_comment_form_renders_turnstile_widget
    get "/#{@post.id}"

    assert_includes last_response.body, 'https://challenges.cloudflare.com/turnstile/v0/api.js'
    assert_includes last_response.body, 'data-sitekey="test-site-key"'
  end

  def test_rejects_comment_when_turnstile_verification_fails
    response = Struct.new(:body).new('{"success":false}')

    Net::HTTP.stub(:post_form, response) do
      post_comment('invalid-token')
    end

    assert_equal 422, last_response.status
    assert_equal 0, Comment.count
    assert_includes last_response.body, I18n.t('turnstile.verification_failed')
  end

  def test_accepts_comment_when_turnstile_verification_succeeds
    response = Struct.new(:body).new('{"success":true,"hostname":"example.org"}')

    Net::HTTP.stub(:post_form, response) do
      post_comment('valid-token')
    end

    assert_equal 302, last_response.status
    assert_equal 1, Comment.count
  end

  def test_rejects_comment_when_turnstile_is_unavailable
    Net::HTTP.stub(:post_form, ->(*) { raise OpenSSL::SSL::SSLError }) do
      post_comment('token')
    end

    assert_equal 422, last_response.status
    assert_equal 0, Comment.count
  end

  private

  def post_comment(token)
    post "/#{@post.id}",
         check: 'check',
         'cf-turnstile-response': token,
         comment: { name: 'Lokka user', body: 'Good entry!' }
  end
end
