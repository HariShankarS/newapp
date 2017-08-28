require 'CustomMentionProcessor'
class PostsController < ApplicationController
  before_action :set_post, only: [ :edit, :update, :destroy, :upvote, :downvote]
  before_action :authenticate_user!

  def index
    @posts = Post.all.order("created_at DESC").paginate(page: params[:page], per_page: 8)
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    respond_to do |format|
      if @post.save
        m = CustomMentionProcessor.new
        m.process_mentions(@post)
        format.html { redirect_to posts_url, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        user_ids = @post.mentionees_by(User).collect(&:mentionee_id)
        user_ids.each do |i|
          @post.unmention(User.find(i))
        end
        m = CustomMentionProcessor.new
        m.process_mentions(@post)
        format.html { redirect_to posts_url, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render :layout => false }
    end
  end

  def upvote
    @post.upvote_by(current_user)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render :layout => false }
    end  
  end

  def downvote
    @post.downvote_by(current_user)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render :layout => false }
    end      
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:message, :user_id)
    end
end
