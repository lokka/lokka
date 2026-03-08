# frozen_string_literal: true

require_relative '../../test_helper'
require_relative '../../support/admin_helper'
require_relative '../../support/custom_assertions'

class AdminFieldNamesTest < LokkaTestCase
  include AdminLoginContext
  include CustomAssertions::NotFoundPage

  def setup
    super
    @field_name = create(:field_name)
  end

  def teardown
    FieldName.destroy_all
    super
  end

  def test_get_admin_field_names_shows_index
    get '/admin/field_names'
    assert last_response.ok?
    assert_match @field_name.name, last_response.body
  end

  def test_get_admin_field_names_new_shows_form
    get '/admin/field_names/new'
    assert last_response.ok?
    assert_match '<form', last_response.body
  end

  def test_post_admin_field_names_creates_new_field_name
    post '/admin/field_names', field_name: { name: 'new field' }
    assert last_response.redirect?
    refute_nil FieldName.find_by(name: 'new field')
  end

  def test_delete_admin_field_names_deletes_field_name
    refute_nil FieldName.find_by(id: @field_name.id)
    delete "/admin/field_names/#{@field_name.id}"
    assert last_response.redirect?
    assert_nil FieldName.find_by(id: @field_name.id)
  end

  def test_delete_nonexistent_field_name_returns_not_found
    FieldName.destroy_all
    delete '/admin/field_names/9999'
    assert_not_found_page
  end
end
