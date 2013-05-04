class ConsoleController < ApplicationController

	def index
		@book = Book.find_by_id(params[:id])
	end

	# PDF JS
	def pdfjs
		@book = Book.find_by_id(params[:id])
		render layout: "pdfjs"
	end

	def select
		@friends = current_user.accepted_friends
		render layout: "console_clipped"
	end
end
