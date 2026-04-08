# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../support/admin_helper'

class AntispamTest < LokkaTestCase
  include InSiteContext

  def setup
    super
    @post = create(:post)
    Comment.destroy_all
    # Reset all antispam settings to defaults
    Option.antispam_honeypot_enabled = 'true'
    Option.antispam_timing_enabled = 'true'
    Option.antispam_timing_min_seconds = '3'
    Option.antispam_content_enabled = 'true'
    Option.antispam_content_max_urls = '3'
    Option.antispam_content_ng_words = ''
    Option.antispam_turnstile_enabled = 'false'
    Option.antispam_rate_limit_enabled = 'false'
    # Disable Akismet so it doesn't interfere
    Option.akismet_key = nil
    # Generate a fresh antispam secret for this test
    @antispam_secret = SecureRandom.hex(32)
    Option.antispam_secret = @antispam_secret
  end

  def teardown
    Post.destroy_all
    Comment.destroy_all
    super
  end

  def test_honeypot_blocks_spam
    # Bot fills in hidden honeypot field
    params = {
      check: 'check',
      website: 'http://spam.com',
      antispam_ts: (Time.now.to_i - 10).to_s,
      antispam_token: generate_token(Time.now.to_i - 10),
      comment: {
        name: 'Spammer',
        body: 'Buy now!'
      }
    }

    post "/#{@post.id}", params
    comment = Comment.last

    assert_equal Comment::SPAM, comment.status
  end

  def test_honeypot_allows_normal_comment
    params = {
      check: 'check',
      website: '', # Empty honeypot
      antispam_ts: (Time.now.to_i - 10).to_s,
      antispam_token: generate_token(Time.now.to_i - 10),
      comment: {
        name: 'Real User',
        body: 'Great post!'
      }
    }

    post "/#{@post.id}", params
    comment = Comment.last

    assert_equal Comment::MODERATED, comment.status
  end

  def test_timing_blocks_fast_submission
    # Submission immediately (0 seconds elapsed)
    timestamp = Time.now.to_i
    params = {
      check: 'check',
      antispam_ts: timestamp.to_s,
      antispam_token: generate_token(timestamp),
      comment: {
        name: 'Fast Bot',
        body: 'Spam!'
      }
    }

    post "/#{@post.id}", params
    comment = Comment.last

    assert_equal Comment::SPAM, comment.status
  end

  def test_timing_allows_slow_submission
    # Submission after 10 seconds (> 3 second minimum)
    timestamp = Time.now.to_i - 10
    params = {
      check: 'check',
      antispam_ts: timestamp.to_s,
      antispam_token: generate_token(timestamp),
      comment: {
        name: 'Normal User',
        body: 'Nice article!'
      }
    }

    post "/#{@post.id}", params
    comment = Comment.last

    assert_equal Comment::MODERATED, comment.status
  end

  def test_timing_blocks_invalid_token
    timestamp = Time.now.to_i - 10
    params = {
      check: 'check',
      antispam_ts: timestamp.to_s,
      antispam_token: 'invalid_token',
      comment: {
        name: 'Hacker',
        body: 'Tampered request'
      }
    }

    post "/#{@post.id}", params
    comment = Comment.last

    assert_equal Comment::SPAM, comment.status
  end

  def test_content_filter_blocks_too_many_urls
    timestamp = Time.now.to_i - 10
    params = {
      check: 'check',
      antispam_ts: timestamp.to_s,
      antispam_token: generate_token(timestamp),
      comment: {
        name: 'URL Spammer',
        body: 'Check http://a.com http://b.com http://c.com http://d.com'
      }
    }

    post "/#{@post.id}", params
    comment = Comment.last

    assert_equal Comment::SPAM, comment.status
  end

  def test_content_filter_allows_few_urls
    timestamp = Time.now.to_i - 10
    params = {
      check: 'check',
      antispam_ts: timestamp.to_s,
      antispam_token: generate_token(timestamp),
      comment: {
        name: 'Normal User',
        body: 'See http://example.com for more info'
      }
    }

    post "/#{@post.id}", params
    comment = Comment.last

    assert_equal Comment::MODERATED, comment.status
  end

  def test_ng_words_block_spam
    Option.antispam_content_ng_words = 'viagra,casino'
    timestamp = Time.now.to_i - 10
    params = {
      check: 'check',
      antispam_ts: timestamp.to_s,
      antispam_token: generate_token(timestamp),
      comment: {
        name: 'Spammer',
        body: 'Buy VIAGRA now!'
      }
    }

    post "/#{@post.id}", params
    comment = Comment.last

    assert_equal Comment::SPAM, comment.status
  end

  private

  def generate_token(timestamp)
    OpenSSL::HMAC.hexdigest('SHA256', @antispam_secret, timestamp.to_s)
  end
end

class AntispamAdminTest < LokkaTestCase
  include AdminLoginContext

  def test_admin_settings_page_accessible
    get '/admin/plugins/antispam'
    assert last_response.ok?
    assert_match 'Antispam', last_response.body
  end

  def test_admin_can_save_settings
    put '/admin/plugins/antispam', {
      antispam: {
        honeypot_enabled: '1',
        timing_enabled: '1',
        timing_min_seconds: '5',
        content_enabled: '1',
        content_max_urls: '2',
        content_ng_words: 'spam,test'
      }
    }

    assert last_response.redirect?
    assert_equal 'true', Option.antispam_honeypot_enabled
    assert_equal '5', Option.antispam_timing_min_seconds
    assert_equal '2', Option.antispam_content_max_urls
    assert_equal 'spam,test', Option.antispam_content_ng_words
  end
end
