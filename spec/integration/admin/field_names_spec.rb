# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '/admin/field_names' do
  include_context 'admin login'
  before { @field_name = create(:field_name) }
  after { FieldName.destroy }

  context 'GET /admin/field_names' do
    it 'should show index' do
      get '/admin/field_names'
      expect(last_response).to be_ok
      expect(last_response).to match(@field_name.name)
    end
  end

  context '/admin/field_names/new' do
    it 'should show form for new field_name' do
      get '/admin/field_names/new'
      expect(last_response).to be_ok
      expect(last_response.body).to match('<form')
    end
  end

  context 'POST /admin/field_names' do
    it 'should create a new field_name' do
      post '/admin/field_names', field_name: { name: 'new field' }
      expect(last_response).to be_redirect
      FieldName.first(name: 'new expect(field')).not_to be_nil
    end
  end

  context 'DELETE /admin/field_names/:id' do
    it 'should delete the field_name' do
      expect(FieldName.get(@field_name.id)).not_to be_nil # gauntret
      delete "/admin/field_names/#{@field_name.id}"
      expect(last_response).to be_redirect
      expect(FieldName.get(@field_name.id)).to be_nil
    end
  end

  context 'when the field name does not exist' do
    before { FieldName.destroy }

    context 'DELETE' do
      before { delete '/admin/field_names/9999' }
      it_behaves_like 'a not found page'
    end
  end
end
