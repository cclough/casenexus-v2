class ConsoleController < ApplicationController

  before_filter :authenticate_user!
  before_filter :completed_user

	def index
		@book = Book.find_by_id(params[:book_id]) unless params[:book_id].blank?
		@friend = User.find(params[:friend_id]) unless params[:friend_id].blank?
		
		@friends = current_user.accepted_friends
    @books = Book.where(btype: "case")

    @view = params[:view]
	end

	# PDF JS
	def pdfjs
		@book = Book.find_by_id(params[:id])
		render layout: "pdfjs"
	end

	def sendpdf
		@user_target = User.find(params[:target_id])
		book = Book.find(params[:book_id])

    UserMailer.case_pdf(current_user,
                        @user_target,
                        book).deliver # not delayed intentionally to give accurate loading time on callback
	end

	def sendpdfbutton
		@friend = User.find(params[:friend_id])
		@book = Book.find(params[:book_id])

		render partial: "sendpdfbutton", layout: false
	end

	def skypebutton
		@friend = User.find(params[:friend_id]) unless params[:friend_id].blank?
		
		render partial: "skypebutton", layout: false
	end
end
