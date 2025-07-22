require "test_helper"

class Admin::PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_posts_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_posts_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_posts_create_url
    assert_response :success
  end

  test "should get edit" do
    get admin_posts_edit_url
    assert_response :success
  end

  test "should get update" do
    get admin_posts_update_url
    assert_response :success
  end

  test "should get destroy" do
    get admin_posts_destroy_url
    assert_response :success
  end
end
