class Admin::PostsController < Admin::BaseController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  def index
    @pagy, @posts = pagy(Post.includes(:user, :category).order(created_at: :desc))
  end

  def show
  end

  def new
    @post = Post.new
    @categories = Category.all
  end

  def create
    @post = current_user.entries.build(post_params.merge(type: 'Post'))
    
    if @post.save
      flash[:notice] = 'Post was successfully created.'
      redirect_to admin_posts_path
    else
      @categories = Category.all
      render :new
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    if @post.update(post_params)
      flash[:notice] = 'Post was successfully updated.'
      redirect_to admin_posts_path
    else
      @categories = Category.all
      render :edit
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = 'Post was successfully deleted.'
    redirect_to admin_posts_path
  end
  
  private
  
  def set_post
    @post = Post.friendly.find(params[:id])
  end
  
  def post_params
    params.require(:post).permit(:title, :body, :category_id, :markup, :draft, tag_names: [])
  end
end
