class BooksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  helper_method :sort_column, :sort_direction

	def index
    books_scope = Book
    if !params[:btype].blank? && params[:btype] != "all"
      books_scope = Book.where(btype: params[:btype])
    end

    @books = books_scope.search_for(params[:search]).order(sort_column + " " + sort_direction).paginate(per_page: 10, page: params[:page])
    @books.all
	end

  def show
    @book = Book.find(params[:id])
    @commentable = @book
    @comments = @commentable.comments
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
