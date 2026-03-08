# frozen_string_literal: true

require_relative '../test_helper'

class TagTest < LokkaTestCase
  def setup
    super
    @tag = create(:tag, name: 'lokka')
  end

  def test_link_returns_correct_path
    assert_equal '/tags/lokka/', @tag.link
  end

  def test_tag_name_returns_instance
    assert_equal @tag, Tag('lokka')
  end
end
