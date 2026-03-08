# frozen_string_literal: true

require_relative '../test_helper'

class PostTest < LokkaTestCase
  # with slug
  def test_post_with_slug_has_correct_link
    post = build(:post_with_slug)
    assert_equal '/welcome-lokka', post.link
  end

  def test_post_with_slug_and_permalink_enabled
    Option.permalink_format = '/%year%/%month%/%day%/%slug%'
    Option.permalink_enabled = true

    post = build(:post_with_slug)
    assert_equal '/2011/01/09/welcome-lokka', post.link
  ensure
    Option.permalink_enabled = false
  end

  def test_post_with_slug_permalink_format_set_but_disabled
    Option.permalink_format = '/%year%/%month%/%day%/%slug%'
    Option.permalink_enabled = false

    post = build(:post_with_slug)
    assert_equal '/welcome-lokka', post.link
  end

  def test_valid_slug_is_valid
    post = build(:post, slug: 'valid_Str-ing1')
    assert post.valid?
  end

  def test_invalid_slug_is_invalid_or_changed
    post = build(:post, slug: 'invalid string')
    assert !post.valid? || post.slug != 'invalid string'
  end

  # with id 1
  def test_edit_link_with_id_1
    post = build(:post, id: 1)
    assert_equal '/admin/posts/1/edit', post.edit_link
  end

  # markup
  def test_kramdown_body_differs_from_raw_body
    post = create(:kramdown)
    refute_equal post.raw_body, post.body
  end

  def test_kramdown_body_matches_expected_format
    post = create(:kramdown)
    regexp = %r{<h1.*>(<a name.+</a><span .+>)*hi!(</span>)*</h1>\s*<p>kramdown test</p>}
    assert_match regexp, post.body.tr("\n", '')
  end

  def test_redcloth_body_differs_from_raw_body
    post = create(:redcloth)
    refute_equal post.raw_body, post.body
  end

  def test_redcloth_body_matches_expected_format
    post = create(:redcloth)
    regexp = %r{<h1.*>(<a name.+</a><span .+>)*hi!(</span>)*</h1>\s*<p>redcloth test</p>}
    assert_match regexp, post.body.tr("\n", '')
  end

  def test_default_markup_body_equals_raw_body
    post = build(:post)
    assert_equal post.raw_body, post.body
  end

  # previous or next
  def test_prev_returns_previous_post
    before_post = create(:xmas_post)
    after_post = create(:newyear_post)

    assert_equal before_post, after_post.prev
    assert_operator after_post.prev.created_at, :<, after_post.created_at
  end

  def test_next_returns_next_post
    before_post = create(:xmas_post)
    after_post = create(:newyear_post)

    assert_equal after_post, before_post.next
    assert_operator before_post.next.created_at, :>, before_post.created_at
  end

  def test_latest_article_has_no_next
    create(:xmas_post)
    after_post = create(:newyear_post)

    assert_nil after_post.next
  end

  def test_first_article_has_no_prev
    before_post = create(:xmas_post)
    create(:newyear_post)

    assert_nil before_post.prev
  end

  # .first
  def test_first_does_not_raise_error
    build(:post)
    Post.first
  end

  # #tag_collection=
  def test_tag_collection_updates_tags
    entry = create(:entry)
    original_tags = entry.tags.to_a

    entry.tag_collection = 'foo,bar'
    entry.save
    entry.reload

    refute_equal original_tags, entry.tags.to_a
  end

  # #description
  def test_kramdown_description
    post = create(:kramdown)
    assert_equal 'kramdown test', post.description
  end

  def test_redcloth_description
    post = create(:redcloth)
    assert_equal 'redcloth test', post.description
  end

  def test_description_uses_first_paragraph
    post = build(:post)
    assert_equal 'Welcome to Lokka!', post.description
  end

  def test_description_without_p_tag
    post = build(:post, body: '<h1>Hi!</h1>')
    assert_equal 'Hi! ', post.description
  end
end
