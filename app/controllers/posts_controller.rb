class PostsController < ApplicationController
  def index
    @pagy, @posts = pagy(Post.published)
    @site = Site.first_or_create(title: "Lokka", description: "A Ruby CMS")
  end

  def show
    @post = Post.published.friendly.find(params[:id])
    @site = Site.first_or_create(title: "Lokka", description: "A Ruby CMS")
  end

  def feed
    @posts = Post.published.limit(20)
    @site = Site.first_or_create(title: "Lokka", description: "A Ruby CMS")
    
    respond_to do |format|
      format.rss { render layout: false }
      format.atom { render layout: false }
    end
  end
end
