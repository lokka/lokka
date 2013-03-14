module Lokka
  class App
    get '/admin/categories' do
      @categories = Category.
        page(params[:page]).
        per(settings.admin_per_page)
      haml :'admin/categories/index', layout: :'admin/layout'
    end

    get '/admin/categories/new' do
      @category = Category.new
      haml :'admin/categories/new', layout: :'admin/layout'
    end

    post '/admin/categories' do
      #FIXME
      #params['category'].delete('parent_id') if params['category']['parent_id'].blank?
      @category = Category.new(params[:category]) do |c|
        c.user_id = current_user.id
      end

      if @category.save
        flash[:notice] = t('category_was_successfully_created')
        redirect to("/admin/categories/#{@category.id}/edit")
      else
        haml :'admin/categories/new', layout: :'admin/layout'
      end
    end

    get '/admin/categories/:id/edit' do |id|
      @category = Category.where(id: id).first or raise Sinatra::NotFound
      haml :'admin/categories/edit', layout: :'admin/layout'
    end

    put '/admin/categories/:id' do |id|
      @category = Category.where(id: id).first or raise Sinatra::NotFound
      #FIXME
      #params['category'].delete('parent_id') if params['category']['parent_id'].blank?
      if @category.update_attributes(params[:category])
        flash[:notice] = t('category_was_successfully_updated')
        redirect to("/admin/categories/#{@category.id}/edit")
      else
        haml :'admin/categories/edit', layout: :'admin/layout'
      end
    end

    delete '/admin/categories/:id' do |id|
      category = Category.where(id: id).first or raise Sinatra::NotFound
      category.destroy
      flash[:notice] = t('category_was_successfully_deleted')
      redirect to('/admin/categories')
    end
  end
end
