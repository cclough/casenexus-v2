class CasesController < ApplicationController

  before_filter :signed_in_user, only: [:index, :show, :new, :create, :analysis]
  before_filter :correct_user, only: [:show]
  before_filter :completed_user

  # before_filter :notself_user, only: [:create]

	def index
		@cases = current_user.cases.paginate(per_page: 10, page: params[:page])
	end

	def show
		@case = Case.find(params[:id])
	end

	def new
		if params[:roulette_token]
			@case_user = User.find_by_roulette_token(params[:roulette_token])
		else
			@case_user = User.find(params[:user_id])
		end

		@case = @case_user.cases.build
	end

	def create
		# declare separately so can be used for notification create below - EDIT: really!?
		case_user = User.find_by_id(params[:case][:user_id])

    @case = case_user.cases.build(params[:case])

  	if @case.save
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
      format.json { render json: Case.cases_analysis_chart_progress_data(current_user) }
	  end

	end


	private

    def correct_user
      @case = current_user.cases.find_by_id(params[:id])
      redirect_to root_path if @case.nil?
    end
	
    def notself_user

     # for some reason can't detect user_id param! bugger!
     # if (params[:user_id] == current_user.id)
     #  	flash[:error] = 'You cannot send a case to yourself'
     #  	redirect_to users_path
     #  end

    end
end