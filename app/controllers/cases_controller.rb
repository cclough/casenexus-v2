class CasesController < ApplicationController

  before_filter :signed_in_user,
                only: [:index, :show, :new, :create]

  before_filter :correct_user, only: [:show]

	def index

		@cases = current_user.cases.paginate(per_page: 10, page: 
			     	 params[:page], order: "created_at DESC")
		
	end

	def show
	end

	def new
	end

	def create
	end


	private

    def correct_user
      @case = current_user.cases.find_by_id(params[:id])
      redirect_to root_path if @case.nil?
    end
	
end