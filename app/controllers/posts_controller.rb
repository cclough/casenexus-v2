class PostsController < ApplicationController


  def index

    @posts = Post.all

    @post = current_user.posts.build

    render layout: "profile"

  end

  def create

    if current_user.posts.create(params[:post])
      flash[:success] = 'Post Posted'
      redirect_to posts_path
    else
      render posts_path
    end

  end


end
