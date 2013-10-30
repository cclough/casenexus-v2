class PostsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :completed_user


  def create
    @post = current_user.posts.build(params[:post])

    respond_to do |format|
      if @post.save
        flash[:success] = 'Your broadcast has been submitted for review, and will be online shortly.'
        format.js
      else
        format.js
      end
    end
  end
  
  def show
    unless params[:direction].blank?
      @current_post = Post.find(params[:id])
      if params[:direction] == "down"
        @post = @current_post.prev
      elsif params[:direction] == "up"
        @post = @current_post.next
      end
    else
      @post = Post.find(params[:id])
    end

    render partial: "show", locals: { post: @post }
  end

  def show_username
    @post = Post.find(params[:id])
    render partial: "show_username", locals: { post: @post }
  end

  
  
end
