class CasesController < ApplicationController

  before_filter :signed_in_user, only: [:index, :show, :new, :create, :analysis, :update]
  before_filter :correct_user, only: [:show]
  before_filter :completed_user

  helper_method :sort_column, :sort_direction

  # before_filter :notself_user, only: [:create]

	def index
		@cases = current_user.cases
						 .search_for(params[:search])
		         .order(sort_column + " " + sort_direction)
						 .paginate(per_page: 10, page: params[:page])

    respond_to do |format|
      format.html 
      format.js # links index.js.erb!
    end

	end

	def show
		@case = Case.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false } 
    end
	end

	def new
		if params[:roulette_token]
			@case_user = User.find_by_roulette_token(params[:roulette_token])
		else
			@case_user = User.find(params[:user_id])
      if params[:subject] then @subject = params[:subject] end
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


  def update

    @case = Case.find(params[:case][:id])

    respond_to do |format|

      if @case.update_attributes(params[:case])
        format.js
        flash.now[:success] = 'Notes Saved'
      else
        format.js
        flash.now[:notice] = 'Error - notes not saved'
      end

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

    # For Index case sorting
    def sort_column
    	current_user.cases.column_names.include?(params[:sort]) ? params[:sort] : "subject"
  	end
  
  	def sort_direction
    	%w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  	end
end