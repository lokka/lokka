# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '/admin/field_names' do
  include_context 'admin login'
  before { @field_name = Factory(:field_name) }
  after { FieldName.delete_all }

  context 'GET /admin/field_names' do
    it 'should show index' do
      get '/admin/field_names'
      last_response.should be_ok
      last_response.should match(@field_name.name)
    end
  end

  context '/admin/field_names/new' do
    it 'should show form for new field_name' do
      get '/admin/field_names/new'
      last_response.should be_ok
      last_response.body.should match('<form')
    end
  end

  context 'POST /admin/field_names' do
    it 'should create a new field_name' do
      post '/admin/field_names', field_name: { name: 'new field' }
      last_response.should be_redirect
      FieldName.where(name: 'new field').first.should_not be_nil
    end
  end

  context 'DELETE /admin/field_names/:id' do
    it 'should delete the field_name' do
      FieldName.find(@field_name.id).should_not be_nil # gauntret
      delete "/admin/field_names/#{@field_name.id}"
      last_response.should be_redirect
      FieldName.where(id: @field_name.id).first.should be_nil
    end
  end

  context 'when the field name does not exist' do
    before { FieldName.delete_all }

    context 'DELETE' do
      before { delete '/admin/field_names/9999' }
      it_behaves_like 'a not found page'
    end
  end
end
