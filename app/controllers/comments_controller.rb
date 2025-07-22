class CommentsController < ApplicationController
  def create
    @entry = Entry.friendly.find(params[:entry_id])
    @comment = @entry.comments.build(comment_params)
    
    if @comment.save
      flash[:notice] = 'Your comment has been submitted and is awaiting moderation.'
      redirect_to @entry.is_a?(Post) ? post_path(@entry) : page_path(@entry)
    else
      flash[:alert] = 'There was an error submitting your comment.'
      redirect_back(fallback_location: root_path)
    end
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:name, :email, :url, :body)
  end
end
