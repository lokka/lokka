# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '/admin/categories' do
  include_context 'admin login'
  before { @category = create(:category) }
  after { Category.destroy }

  context 'GET /admin/categories' do
    it 'should show index' do
      get '/admin/categories'
      expect(last_response).to be_ok
    end
  end

  context '/admin/categories/new' do
    it 'should show form for new categories' do
      get '/admin/categories/new'
      expect(last_response).to be_ok
      expect(last_response.body).to match('<form')
    end
  end

  context 'POST /admin/categories' do
    it 'should create a new category' do
      sample = { title: 'Created Category',
                 description: 'This is created in spec',
                 slug: 'created-category' }
      post '/admin/categories', category: sample
      expect(last_response).to be_redirect
      expect(Category('created-category')).not_to be_nil
    end
  end

  context '/admin/categories/:id/edit' do
    it 'should show form for edit categories' do
      get "/admin/categories/#{@category.id}/edit"
      expect(last_response).to be_ok
      expect(last_response.body).to match('<form')
    end
  end

  context 'PUT /admin/categories/:id' do
    it 'should update the category"s description' do
      put "/admin/categories/#{@category.id}", category: { description: 'updated' }
      expect(last_response).to be_redirect
      expect(Category(@category.id).description).to eq('updated')
    end
  end

  context 'DELETE /admin/categories/:id' do
    it 'should delete the category' do
      delete "/admin/categories/#{@category.id}"
      expect(last_response).to be_redirect
      expect(Category(@category.id)).to be_nil
    end
  end

  context 'when a child category exists' do
    context 'POST /admin/categories' do
      it 'should create a new child category' do
        sample = { title: 'Child Category',
                   description: 'This is created in spec',
                   slug: 'child-category',
                   parent_id: @category.id }
        post '/admin/categories', category: sample
        expect(last_response).to be_redirect
        child = Category('child-category')
        expect(child).not_to be_nil
        expect(child.parent).to eq(@category)
      end
    end
  end

  context 'when the category does not exist' do
    before { Category.destroy }

    context 'GET' do
      before { get '/admin/categories/9999/edit' }
      it_behaves_like 'a not found page'
    end

    context 'PUT' do
      before { put '/admin/categories/9999' }
      it_behaves_like 'a not found page'
    end

    context 'DELETE' do
      before { delete '/admin/categories/9999' }
      it_behaves_like 'a not found page'
    end
  end
end
