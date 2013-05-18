class BooksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user
  
	def index

    # Set scope of users list depending on params from filter menu
    case params[:books_list_type]
      when "cases"
        books_scope = Book.list_cases
      when "guides"
        books_scope = Book.list_guides
      else
        books_scope = Book.list_cases
    end

    # Using scoped_search gem
    if books_scope
      @books = books_scope.search_for(params[:search]).order(sort_column + " " + sort_direction).paginate(per_page: 10, page: params[:page])
    end

    respond_to do |format|
      format.html
      #format.js
    end

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
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
