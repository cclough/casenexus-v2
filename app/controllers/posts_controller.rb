class PostsController < ApplicationController


  layout "profile"

  def index

    @posts = Post.all

    @post = current_user.posts.build

  end

  def create

    if current_user.posts.create(params[:post])
      flash[:success] = 'Post Posted'
      redirect_to posts_path
    else
      render posts_path
    end

  end

  def show
    @post = Post.find(params[:id])
    # @commentable = @post
    # @comments = @commentable.comments.order("created_at desc").paginate(per_page: 20, page: params[:page])
    # @comment = Comment.new
  end

end
