# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe '/admin/users' do
  include_context 'admin login'
  before { @user = User.first }

  context 'GET /admin/users' do
    it 'should show index' do
      get '/admin/users'
      expect(last_response).to be_ok
    end
  end

  context '/admin/users/new' do
    it 'should show form for new users' do
      get '/admin/users/new'
      expect(last_response).to be_ok
      expect(last_response.body).to match('<form')
    end
  end

  context 'POST /admin/users' do
    it 'should create a new user' do
      user = {
        name: 'lokka tarou',
        email: 'tarou@example.com',
        password: 'test',
        password_confirmation: 'test'
      }
      post '/admin/users', user: user
      expect(last_response).to be_redirect
      User.first(name: 'lokka expect(tarou')).not_to be_nil
    end

    it 'should not create a user when two password does not match' do
      user = {
        name: 'lokka tarou',
        email: 'tarou@example.com',
        password: 'test',
        password_confirmation: 'wrong'
      }
      post '/admin/users', user: user
      expect(last_response).to be_ok
      User.first(name: 'lokka expect(tarou')).to be_nil
      expect(last_response.body).to match('<form')
    end
  end

  context '/admin/users/:id/edit' do
    it 'should show form for edit users' do
      get "/admin/users/#{@user.id}/edit"
      expect(last_response).to be_ok
      expect(last_response.body).to match('<form')
    end
  end

  context 'PUT /admin/users/:id' do
    it 'should update the name' do
      put "/admin/users/#{@user.id}", user: { name: 'newbie' }
      expect(last_response).to be_redirect
      expect(User.get(@user.id).name).to eq('newbie')
    end
  end

  context 'DELETE /admin/users/:id' do
    before { @another_user = create(:user) }

    it 'should delete the another user' do
      delete "/admin/users/#{@another_user.id}"
      expect(last_response).to be_redirect
      expect(User.get(@another_user.id)).to be_nil
    end

    it 'should not delete the current user' do
      delete "/admin/users/#{@user.id}"
      expect(last_response).to be_redirect
      expect(User.get(@user.id)).not_to be_nil
    end
  end

  context 'when the user does not exist' do
    before { User.destroy }

    context 'GET' do
      before { get '/admin/users/9999/edit' }
      it_behaves_like 'a not found page'
    end

    context 'PUT' do
      before { put '/admin/users/9999' }
      it_behaves_like 'a not found page'
    end

    context 'DELETE' do
      before { delete '/admin/users/9999' }
      it_behaves_like 'a not found page'
    end
  end
end
