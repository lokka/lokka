module Lokka
  class App
    namespace '/admin' do
      namespace '/tags' do
        get do
          @tags = Tag.
            page(params[:page]).
            per(settings.admin_per_page)
          haml :'admin/tags/index', layout: :'admin/layout'
        end

        get '/:id/edit' do |id|
          @tag = Tag.where(id: id).first or raise Sinatra::NotFound
          haml :'admin/tags/edit', layout: :'admin/layout'
        end

        put '/:id' do |id|
          @tag = Tag.where(id: id).first or raise Sinatra::NotFound
          if @tag.update_attributes(params[:tag])
            flash[:notice] = t('tag_was_successfully_updated')
            redirect to("/admin/tags/#{@tag.id}/edit")
          else
            haml :'admin/tags/edit', layout: :'admin/layout'
          end
        end

        delete '/:id' do |id|
          tag = Tag.where(id: id).first or raise Sinatra::NotFound
          tag.destroy
          flash[:notice] = t('tag_was_successfully_deleted')
          redirect to('/admin/tags')
        end
      end
    end
  end
end
