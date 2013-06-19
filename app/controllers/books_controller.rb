class BooksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  helper_method :sort_column, :sort_direction

	def index

    if !params[:btype].blank? && params[:btype] != "all"
      books_scope = Book.where(btype: params[:btype])
    else
      books_scope = Book   
    end

    @books = books_scope.search_for(params[:search]).order(sort_column + " " + sort_direction).paginate(per_page: params[:per_page], page: params[:page])

	end

  def show
    @book = Book.find(params[:id])
    @commentable = @book
    @comments = @commentable.comments.order("created_at desc").paginate(per_page: 3, page: params[:page])
    @comment = Comment.new
  end

  private

  # For index book sorting
  def sort_column
    Book.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
