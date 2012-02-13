require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '/admin/categories' do
  include_context 'admin login'
  before { @category = Factory(:category) }
  after { Category.destroy }

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
      sample = { :title => 'Created Category',
        :description => 'This is created in spec',
        :slug => 'created-category' }
      post '/admin/categories', { :category => sample }
      last_response.should be_redirect
      Category('created-category').should_not be_nil
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
    it 'should update the category\'s description' do
      put "/admin/categories/#{@category.id}", { :category => { :description => 'updated' } }
      last_response.should be_redirect
      Category(@category.id).description.should == 'updated'
    end
  end

  context 'DELETE /admin/categories/:id' do
    it 'should delete the category' do
      delete "/admin/categories/#{@category.id}"
      last_response.should be_redirect
      Category(@category.id).should be_nil
    end
  end
end
