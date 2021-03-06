class BooksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  helper_method :sort_column, :sort_direction

	def index

    # TAGS
    params[:books_filter_tag] = nil if params[:books_filter_tag] == ""
    if params[:tag]
      relation = Book.approved.tagged_with(params[:tag])
    elsif params[:books_filter_tag]
      relation = Book.approved.tagged_on_type(params[:books_filter_tag])
    else
      relation = Book.approved
    end

    # DIFFICULTY
    params[:books_filter_difficulty] = nil if params[:books_filter_difficulty] == "" || params[:books_filter_difficulty] == "all"
    if params[:books_filter_difficulty]
      relation = relation.where(difficulty: params[:books_filter_difficulty])
    end

    # BTYPE
    params[:books_filter_btype] = nil if params[:books_filter_btype] == "" || params[:books_filter_btype] == "all"
    if params[:books_filter_btype]
      relation = relation.where(btype: params[:books_filter_btype])
    end

    # Bottom Line (SORT IS IN HERE)
    @books = relation.includes(:tags).search_for(params[:search]).order(sort_column + " " + sort_direction).paginate(per_page: 10, page: params[:page])
	
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    @book = Book.find(params[:id])
    @commentable = @book
    @comments = @commentable.comments.includes(:user).order("created_at desc").paginate(per_page: 20, page: params[:page])
    @comment = Comment.new
  end

  def show_small
    @book = Book.find(params[:id])
    render partial: "show_small", layout:false
  end

private

  # For index book sorting
  def sort_column
    Book.column_names.include?(params[:books_filter_sort]) ? params[:books_filter_sort] : "average_rating"
  end

  def sort_direction
    %w[asc desc].include?(params[:books_filter_sort_direction]) ? params[:books_filter_sort_direction] : "desc"
  end
end
