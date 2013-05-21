class ConsoleController < ApplicationController

	def index
		@book = Book.find_by_id(params[:book_id])
		
		#@friend = User.find_by_id(params[:friend_id])
		
		@friends = current_user.accepted_friends
    	@books = Book.where(btype: "case")
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
                            book).deliver

		# redirect_to user_path(@user)  
		flash[:notice] = 'Email has been sent!'  
	end  
end
