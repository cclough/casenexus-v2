class CommentsController < ApplicationController
  before_filter :load_commentable
  
  def create
    @comment = @commentable.comments.new(params[:comment])
    if @comment.save
      @commentable.update_average_rating #manually done, as opposed to triggering the call back
      redirect_to @commentable, notice: "Review posted."
    else
      flash[:error] = @comment.errors.full_messages.map {|error| "<p>#{error}</p>"}.join
      redirect_to @commentable
    end
  end

private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

end
