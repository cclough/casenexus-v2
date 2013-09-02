class PostsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :completed_user, except: [:show_help, :help_checkbox]


  def create

    @post = current_user.posts.build(params[:post])

    respond_to do |format|
      if @post.save
        flash[:success] = 'Your post has been submitted for review, and will be online shortly.'
        format.js
      else
        format.js
      end
    end

  end

  def show
    unless params[:current_post_id].blank?
      @current_post = Post.find(params[:current_post_id])
      if params[:direction] == "down"
        @post = Post.where("approved",true).where("created_at < ?", @current_post).first
      elsif params[:direction] == "up"
        @post = Post.where("approved",true).where("created_at > ?", @current_post).first
      end
    else
      @post = Post.find(params[:id])
    end

    render partial: "show"
  end

  
end
