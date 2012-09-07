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
		# declare separately so can be used in the view
		@case_user = User.find_by_id(params[:user_id])
		@case = @case_user.cases.build
	end

	def create
    @case = User.find_by_id(params[:case][:user_id]).cases.build(params[:case])

	  	if @case.save
      	# flash success and re-direct
	  		flash[:success] = 'Feedback Sent'
	  		redirect_to users_path
	  	else
	  		@case_user = User.find_by_id(params[:user_id])
      	render 'new'
	  	end
	end

	def analysis
		
		respond_to do |format|
	      format.html
	      format.json { render json: Case.chart_analysis_progress(current_user) }
	  end

	end

	private

    def correct_user
      @case = current_user.cases.find_by_id(params[:id])
      redirect_to root_path if @case.nil?
    end
	
end