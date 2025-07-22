class Admin::DashboardController < Admin::BaseController
  def index
    @posts_count = Post.count
    @pages_count = Page.count
    @comments_count = Comment.count
    @recent_posts = Post.order(created_at: :desc).limit(5)
    @recent_comments = Comment.order(created_at: :desc).limit(5)
  end
end
