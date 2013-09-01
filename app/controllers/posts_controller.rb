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
    @post = Post.find(params[:id])
    render partial: "show"
  end

  
end
