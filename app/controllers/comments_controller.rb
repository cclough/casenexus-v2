class CommentsController < ApplicationController

  
  def create
    @comment = @commentable.comments.new(params[:comment])
    if @comment.save
      @commentable.update_average_rating if @comment.commentable_type == "Book" #manually done, as opposed to triggering the call back
      redirect_to @commentable, notice: "Comment posted."
    else
      flash[:error] = @comment.errors.full_messages.map {|error| "#{error}<br>"}.join
      redirect_to @commentable
    end
  end

  def new
    @commentable_model = params[:commentable_type]
    @commentable = @commentable_model.classify.constantize.find(params[:commentable_id])
    @comment = @commentable.comments.new
    render partial: "new", layout: false
  end

private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

end
