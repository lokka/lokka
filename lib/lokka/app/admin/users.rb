module Lokka
  class App
    namespace '/admin' do
      namespace '/users' do
        get do
          @users = User.order('created_at DESC').
            page(params[:page]).
            per(settings.admin_per_page)
          haml :'admin/users/index', layout: :'admin/layout'
        end

        get '/new' do
          @user = User.new
          haml :'admin/users/new', layout: :'admin/layout'
        end

        post do
          @user = User.new(params[:user])
          if @user.save
            flash[:notice] = t('user_was_successfully_created')
            redirect to("/admin/users/#{@user.id}/edit")
          else
            haml :'admin/users/new', layout: :'admin/layout'
          end
        end

        get '/:id/edit' do |id|
          @user = User.where(id: id).first or raise Sinatra::NotFound
          haml :'admin/users/edit', layout: :'admin/layout'
        end

        put '/:id' do |id|
          @user = User.where(id: id).first or raise Sinatra::NotFound
          if @user.update_attributes(params['user'])
            flash[:notice] = t('user_was_successfully_updated')
            redirect to("/admin/users/#{@user.id}/edit")
          else
            haml :'admin/users/edit', layout: :'admin/layout'
          end
        end

        delete '/:id' do |id|
          target_user = User.where(id: id).first or raise Sinatra::NotFound
          if current_user == target_user
            flash[:alert] = 'Can not delete your self.'
          else
            target_user.destroy
          end
          flash[:notice] = t('user_was_successfully_deleted')
          redirect to('/admin/users')
        end
      end
    end
  end
end
