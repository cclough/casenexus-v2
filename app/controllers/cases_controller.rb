class CasesController < ApplicationController

  before_filter :signed_in_user, only: [:index, :show, :new, :create, :analysis]
  before_filter :correct_user, only: [:show]

	def index
		@cases = current_user.cases.paginate(per_page: 10, page: params[:page])
	end

	def show
		@case = Case.find(params[:id])
	end

	def new
	end

	def create
	end

	def analysis
	end

	private

    def correct_user
      @case = current_user.cases.find_by_id(params[:id])
      redirect_to root_path if @case.nil?
    end
	
end