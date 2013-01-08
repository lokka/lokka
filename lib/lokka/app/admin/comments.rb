module Lokka
  class App
    get '/admin/comments' do
      @comments = Comment.order('created_at DESC').
        page(params[:page]).
        per(settings.admin_per_page)
      haml :'admin/comments/index', layout: :'admin/layout'
    end

    get '/admin/comments/new' do
      @comment = Comment.new
      haml :'admin/comments/new', layout: :'admin/layout'
    end

    post '/admin/comments' do
      @comment = Comment.new(params[:comment])
      if @comment.save
        flash[:notice] = t('comment_was_successfully_created')
        redirect to("/admin/comments/#{@comment.id}/edit")
      else
        haml :'admin/comments/new', layout: :'admin/layout'
      end
    end

    get '/admin/comments/:id/edit' do |id|
      @comment = Comment.find(id) or raise Sinatra::NotFound
      haml :'admin/comments/edit', layout: :'admin/layout'
    end

    put '/admin/comments/:id' do |id|
      @comment = Comment.find(id) or raise Sinatra::NotFound
      if @comment.update_attributes(params[:comment])
        flash[:notice] = t('comment_was_successfully_updated')
        redirect to("/admin/comments/#{@comment.id}/edit")
      else
        haml :'admin/comments/edit', layout: :'admin/layout'
      end
    end

    delete '/admin/comments/spam' do
      Comment.spam.delete_all
      flash[:notice] = t('comment_was_successfully_deleted')
      redirect to('/admin/comments')
    end

    delete '/admin/comments/:id' do |id|
      comment = Comment.find(id) or raise Sinatra::NotFound
      comment.destroy
      flash[:notice] = t('comment_was_successfully_deleted')
      redirect to('/admin/comments')
    end
  end
end
