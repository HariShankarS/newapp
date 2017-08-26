class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post
  
  def create 
    @comment = @post.comments.new(params[:comment].permit(:comment_text, :user_id, :post_id))
    @comment.user = current_user
    @comment.save
    @comments = @post.comments.reload
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render :layout => false }
    end  
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render :layout => false }
    end 
  end

end

  private
  def find_post
    @post = Post.find(params[:post_id])
  end
