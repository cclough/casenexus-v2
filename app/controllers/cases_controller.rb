class CasesController < ApplicationController

  before_filter :signed_in_user, only: [:index, :show, :new, :create, :analysis]
  before_filter :correct_user, only: [:show]

  # before_filter :notself_user, only: [:create]

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

    respond_to do |format|

	    if params[:size] == 'roulette'

	    	# For Roulette!
	    	@case_user = RouletteRegistration.current_partner(current_user)
	    	if !@case_user
	    		format.html { render text: "You are not connected to anyone" }
	    	else
	      	format.html { render 'new_roulette', :layout => false }
	      end

	    else
	      format.html { render 'new' }
	    end

    end

	end

	def create
		# declare separately so can be used for notification create below
		case_user = User.find_by_id(params[:case][:user_id])

    @case = case_user.cases.build(params[:case])

    respond_to do |format|

    params[:size] ||= 'roulette'

	  	if @case.save

	  		flash[:success] = 'Feedback Sent'
	  		
	  		if params[:size] == 'roulette'
		  		format.js
		  	else
		  		redirect_to users_path
		  	end

	  	else

	  		@case_user = User.find_by_id(params[:user_id])

	  		if params[:size] == 'roulette'
		  		format.js
		  	else
		  		render 'new'
		  	end
	  		
	  	end
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
	
    def notself_user

     # for some reason can't detect user_id param! bugger!
     # if (params[:user_id] == current_user.id)
     #  	flash[:error] = 'You cannot send a case to yourself'
     #  	redirect_to users_path
     #  end

    end
end