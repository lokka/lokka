# frozen_string_literal: true

module Lokka
  class App
    namespace '/admin' do
      namespace '/categories' do
        get do
          @categories = Category.
                          page(params[:page]).
                          per(settings.admin_per_page)
          haml :'admin/categories/index', layout: :'admin/layout'
        end

        get '/new' do
          @category = Category.new
          haml :'admin/categories/new', layout: :'admin/layout'
        end

        post do
          params['category'].delete('parent_id') if params['category']['parent_id'].blank?
          @category = Category.new(params[:category])

          if @category.save
            flash[:notice] = t('category_was_successfully_created')
            redirect to("/admin/categories/#{@category.id}/edit")
          else
            haml :'admin/categories/new', layout: :'admin/layout'
          end
        end

        get '/:id/edit' do |id|
          (@category = Category.where(id: id).first) || raise(Sinatra::NotFound)
          haml :'admin/categories/edit', layout: :'admin/layout'
        end

        put '/:id' do |id|
          (@category = Category.where(id: id).first) || raise(Sinatra::NotFound)
          params['category'].delete('parent_id') if params['category']['parent_id'].blank?
          if @category.update_attributes(params[:category])
            flash[:notice] = t('category_was_successfully_updated')
            redirect to("/admin/categories/#{@category.id}/edit")
          else
            haml :'admin/categories/edit', layout: :'admin/layout'
          end
        end

        delete '/:id' do |id|
          (category = Category.where(id: id).first) || raise(Sinatra::NotFound)
          category.destroy
          flash[:notice] = t('category_was_successfully_deleted')
          redirect to('/admin/categories')
        end
      end
    end
  end
end
