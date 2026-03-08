# frozen_string_literal: true

require_relative '../test_helper'

class CategoryTest < LokkaTestCase
  def test_creating_new_category_with_blank_slug
    create(:category)
    assert_equal 1, Category.count
  end

  def test_creating_two_new_categories_with_blank_slug
    create_list(:category, 2)
    assert_equal 2, Category.count
  end
end
