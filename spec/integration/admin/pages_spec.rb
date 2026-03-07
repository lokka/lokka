# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '/admin/pages' do
  include_context 'admin login'

  before do
    @page = create(:page)
    create(:draft_page)
  end

  after { Page.destroy }

  context 'with no option' do
    it 'should show all pages' do
      get '/admin/pages'
      expect(last_response.body).to match('Test Page')
      expect(last_response.body).to match('Draft Page')
    end
  end

  context 'with draft option' do
    it 'should show only draft pages' do
      get '/admin/pages', draft: 'true'
      expect(last_response.body).not_to match('Test Page')
      expect(last_response.body).to match('Draft Page')
    end
  end

  context '/admin/pages/new' do
    it 'should show edit page' do
      get '/admin/pages/new'
      expect(last_response.body).to match('<form')
    end
  end

  context 'POST /admin/pages' do
    it 'should create a new page' do
      sample = attributes_for(:page, slug: 'dekitate')
      post '/admin/pages', page: sample
      expect(last_response).to be_redirect
      expect(Page('dekitate')).not_to be_nil
    end
  end

  context '/admin/pages/:id/edit' do
    it 'should show edit page' do
      get "/admin/pages/#{@page.id}/edit"
      expect(last_response.body).to match('<form')
      expect(last_response.body).to match('Test Page')
    end
  end

  context 'PUT /admin/pages/:id' do
    it 'should update the page"s body ' do
      put "/admin/pages/#{@page.id}", page: { body: 'updated' }
      expect(last_response).to be_redirect
      expect(Page(@page.id).body).to eq('updated')
    end
  end

  context 'DELETE /admin/pages/:id' do
    it 'should delete the page' do
      delete "/admin/pages/#{@page.id}"
      expect(last_response).to be_redirect
      expect(Page(@page.id)).to be_nil
    end
  end

  context 'when the page does not exist' do
    before { Page.destroy }

    context 'GET' do
      before { get '/admin/pages/9999/edit' }
      it_behaves_like 'a not found page'
    end

    context 'PUT' do
      before { put '/admin/pages/9999' }
      it_behaves_like 'a not found page'
    end

    context 'DELETE' do
      before { delete '/admin/pages/9999' }
      it_behaves_like 'a not found page'
    end
  end
end
