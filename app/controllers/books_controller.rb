class BooksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  helper_method :sort_column, :sort_direction

	def index

    if !params[:per_page].blank?
      books_per_page = params[:per_page]
    else
      books_per_page = 10
    end

    params[:tag_type_id] = nil if params[:tag_type_id] == [""]
    params[:tag_industry_id] = nil if params[:tag_industry_id] == [""]

    if params[:tag]
      relation = Book.tagged_with(params[:tag])  
    elsif params[:tag_type_id] || params[:tag_industry_id]
      relation = Book.tagged_on_type(params[:tag_type_id] || params[:tag_industry_id])
      # relation = Book.tagged_on(params[:tag_type_id] || Tag.where(category_id: 4).pluck(:id), params[:tag_industry_id] || Tag.where(category_id: 5).pluck(:id)).group('books.id')
    else
      relation = Book
    end

    if !params[:books_filter_btype].blank? && params[:books_filter_btype] != "all"
      relation = relation.where(btype: params[:books_filter_btype])
    end

    @books = relation.search_for(params[:search]).order(sort_column + " " + sort_direction).paginate(per_page: books_per_page, page: params[:page])
	
    respond_to do |format|
      format.js # links index.js.erb!
      format.html
    end
  end

  def show
    @book = Book.find(params[:id])
    @commentable = @book
    @comments = @commentable.comments.order("created_at desc").paginate(per_page: 20, page: params[:page])
    @comment = Comment.new
  end

  def show_small
    @book = Book.find(params[:id])

    render partial: "show_small", layout:false
  end

private

  # For index book sorting
  def sort_column
    Book.column_names.include?(params[:books_filter_sort]) ? params[:books_filter_sort] : "title"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
