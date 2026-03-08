# frozen_string_literal: true

require_relative '../test_helper'

class HelpersTest < LokkaTestCase
  def test_gravatar_image_url_with_email
    assert_equal 'http://www.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0',
                 gravatar_image_url('test@example.com')
  end

  def test_gravatar_image_url_without_email
    assert_equal 'http://www.gravatar.com/avatar/00000000000000000000000000000000',
                 gravatar_image_url
  end

  def test_custom_permalink_parse
    Option.permalink_enabled = true
    Option.permalink_format = '/%year%/%monthnum%/%day%/%slug%'

    expected = { year: '2011', monthnum: '01', day: '09', slug: 'welcome' }
    assert_equal expected, custom_permalink_parse('/2011/01/09/welcome')
  ensure
    Option.permalink_enabled = false
  end

  def test_custom_permalink_fix_returns_corrected_url_by_padding_zero
    Option.permalink_enabled = true
    Option.permalink_format = '/%year%/%monthnum%/%day%/%slug%'

    assert_equal '/2011/01/09/welcome', custom_permalink_fix('/2011/1/9/welcome')
  ensure
    Option.permalink_enabled = false
  end

  def test_custom_permalink_fix_returns_nil_for_correct_url
    Option.permalink_enabled = true
    Option.permalink_format = '/%year%/%monthnum%/%day%/%slug%'

    assert_nil custom_permalink_fix('/2011/01/09/welcome')
  ensure
    Option.permalink_enabled = false
  end

  def test_custom_permalink_fix_returns_nil_when_error_raised
    Option.permalink_enabled = true
    Option.permalink_format = '/%year'

    assert_nil custom_permalink_fix('/2011')
  ensure
    Option.permalink_enabled = false
  end

  def test_custom_permalink_entry_parses_date_condition
    Option.permalink_enabled = true
    Option.permalink_format = '/%year%/%monthnum%/%day%/%slug%'

    # Use local time to match the Time.local used in custom_permalink_entry
    entry = create(:entry, created_at: Time.local(2011, 1, 9, 12, 0, 0), slug: 'slug')
    result = custom_permalink_entry('/2011/01/09/slug')
    # Entry factory creates a Post (STI), so compare by id
    assert_equal entry.id, result.id
  ensure
    Option.permalink_enabled = false
  end

  def test_custom_permalink_entry_returns_nil_when_error_raised
    Option.permalink_enabled = true
    Option.permalink_format = '/%year%/%monthnum%/%day%/%slug%'

    assert_nil custom_permalink_entry('/no/such/path')
  ensure
    Option.permalink_enabled = false
  end

  def test_months_excludes_draft_posts
    create(:post, draft: true)
    assert_equal 0, months.count
  end
end
