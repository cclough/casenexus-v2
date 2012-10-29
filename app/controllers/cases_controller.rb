class CasesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  helper_method :sort_column, :sort_direction

  def index
    @cases = current_user.cases.search_for(params[:search]).order(sort_column + " " + sort_direction).paginate(per_page: 10, page: params[:page])

    respond_to do |format|
      format.html
      format.js
    end

  end

  def show
    @case = current_user.cases.find(params[:id])

    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def new
    if params[:roulette_token]
      @user = User.find_by_roulette_token(params[:roulette_token])
    else
      @user = User.find(params[:user_id])
      if params[:subject] then
        @subject = params[:subject]
      end
    end

    @case = @user.cases.build
  end

  def create
    @case = Case.new(params[:case])
    @case.user_id = params[:case][:user_id]

    if @case.save
      flash[:success] = 'Feedback Sent'
      redirect_to users_path
    else
      @user = User.find(params[:user_id])
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

    # defines radar chart last 5 count
    (current_user.case_count < 6) ? (@radar_count = 1) : (@radar_count = 5)

    respond_to do |format|
      format.html
      format.json { render json: Case.cases_analysis_chart_progress_data(current_user) }
    end

  end

  private

  # For Index case sorting
  def sort_column
    current_user.cases.column_names.include?(params[:sort]) ? params[:sort] : "subject"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end