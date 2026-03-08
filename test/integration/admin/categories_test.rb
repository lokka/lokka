# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/admin_helper'
require_relative '../../support/custom_assertions'

class AdminCategoriesTest < LokkaTestCase
  include AdminLoginContext
  include CustomAssertions::NotFoundPage

  def setup
    super
    @category = create(:category)
  end

  def teardown
    Category.destroy_all
    super
  end

  def test_get_admin_categories_shows_index
    get '/admin/categories'
    assert last_response.ok?
  end

  def test_get_admin_categories_new_shows_form
    get '/admin/categories/new'
    assert last_response.ok?
    assert_match '<form', last_response.body
  end

  def test_post_admin_categories_creates_new_category
    sample = { title: 'Created Category',
               description: 'This is created in spec',
               slug: 'created-category' }
    post '/admin/categories', category: sample
    assert last_response.redirect?
    refute_nil Category('created-category')
  end

  def test_get_admin_categories_edit_shows_form
    get "/admin/categories/#{@category.id}/edit"
    assert last_response.ok?
    assert_match '<form', last_response.body
  end

  def test_put_admin_categories_updates_description
    put "/admin/categories/#{@category.id}", category: { description: 'updated' }
    assert last_response.redirect?
    assert_equal 'updated', Category(@category.id).description
  end

  def test_delete_admin_categories_deletes_category
    delete "/admin/categories/#{@category.id}"
    assert last_response.redirect?
    assert_nil Category(@category.id)
  end

  def test_post_admin_categories_creates_child_category
    sample = { title: 'Child Category',
               description: 'This is created in spec',
               slug: 'child-category',
               parent_id: @category.id }
    post '/admin/categories', category: sample
    assert last_response.redirect?
    child = Category('child-category')
    refute_nil child
    assert_equal @category, child.parent
  end

  def test_get_nonexistent_category_returns_not_found
    Category.destroy_all
    get '/admin/categories/9999/edit'
    assert_not_found_page
  end

  def test_put_nonexistent_category_returns_not_found
    Category.destroy_all
    put '/admin/categories/9999'
    assert_not_found_page
  end

  def test_delete_nonexistent_category_returns_not_found
    Category.destroy_all
    delete '/admin/categories/9999'
    assert_not_found_page
  end
end
