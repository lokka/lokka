module Lokka
  class App
    get '/admin/tags' do
      @tags = Tag.
        page(params[:page]).
        per(settings.admin_per_page)
      haml :'admin/tags/index', layout: :'admin/layout'
    end

    get '/admin/tags/:id/edit' do |id|
      @tag = Tag.find(id) or raise Sinatra::NotFound
      haml :'admin/tags/edit', layout: :'admin/layout'
    end

    put '/admin/tags/:id' do |id|
      @tag = Tag.find(id) or raise Sinatra::NotFound
      if @tag.update_attributes(params[:tag])
        flash[:notice] = t('tag_was_successfully_updated')
        redirect to("/admin/tags/#{@tag.id}/edit")
      else
        haml :'admin/tags/edit', layout: :'admin/layout'
      end
    end

    delete '/admin/tags/:id' do |id|
      tag = Tag.find(id) or raise Sinatra::NotFound
      tag.destroy
      flash[:notice] = t('tag_was_successfully_deleted')
      redirect to('/admin/tags')
    end
  end
end
