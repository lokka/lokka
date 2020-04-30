# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '/admin/categories' do
  include_context 'admin login'
  before { @category = Factory(:category) }
  after { Category.delete_all }

  context 'GET /admin/categories' do
    it 'should show index' do
      get '/admin/categories'
      last_response.should be_ok
    end
  end

  context '/admin/categories/new' do
    it 'should show form for new categories' do
      get '/admin/categories/new'
      last_response.should be_ok
      last_response.body.should match('<form')
    end
  end

  context 'POST /admin/categories' do
    it 'should create a new category' do
      sample = {
        title: 'Created Category',
        description: 'This is created in spec',
        slug: 'created-category'
      }
      post '/admin/categories', { category: sample }
      last_response.should be_redirect
      Category.where(slug: 'created-category').should_not be_nil
    end
  end

  context '/admin/categories/:id/edit' do
    it 'should show form for edit categories' do
      get "/admin/categories/#{@category.id}/edit"
      last_response.should be_ok
      last_response.body.should match('<form')
    end
  end

  context 'PUT /admin/categories/:id' do
    it 'should update the category"s description' do
      put "/admin/categories/#{@category.id}", category: { description: 'updated' }
      last_response.should be_redirect
      Category.where(id: @category.id).first.description.should == 'updated'
    end
  end

  context 'DELETE /admin/categories/:id' do
    it 'should delete the category' do
      delete "/admin/categories/#{@category.id}"
      last_response.should be_redirect
      Category.where(id: @category.id).first.should be_nil
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
        last_response.should be_redirect
        child = Category('child-category')
        child.should_not be_nil
        child.parent.should eq(@category)
      end
    end
  end

  context 'when the category does not exist' do
    before { Category.delete_all }

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
