class CasesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  helper_method :sort_column, :sort_direction

  layout "profile"

  def index
    @cases = current_user.cases.search_for(params[:search]).order("cases."+sort_column + " " + sort_direction).paginate(per_page: 10, page: params[:page])

    respond_to do |format|
      format.html
      format.js
    end

  end

  def show

    @case = current_user.cases.find(params[:id])
    @cases = current_user.cases.order("created_at desc")

  end

  def new
    @user = User.find(params[:user_id])
    unless Friendship.friendship(current_user, @user)
      flash[:error] = "You are not friend with #{@user.name}"
      redirect_to map_path and return
    end
    if params[:subject] then
      @subject = params[:subject]
    end

    @case = @user.cases.build

    render layout: "cases_clipped"

  end

  def create
    user_id = params[:case].delete(:user_id)
    @case = Case.new(params[:case])
    @case.user_id = user_id
    @case.interviewer = current_user

    if @case.save
      flash[:success] = 'Feedback Sent'
      redirect_to map_path
    else
      @user = @case.user
      render 'new'
    end
  end

  def analysis

    # defines radar chart last 5 count
    case current_user.case_count
    when 0
      #signals to show 'you must do at least one case'
      @case_count = 0
    when 1..5
      @case_count = 1
    when 6..1000
      @case_count = 5
    end

    respond_to do |format|
      format.html { render layout: 'profile' }
      format.json { render json: Case.cases_analysis_chart_progress_data(current_user) }
    end


  end

  private

  # For Index case sorting
  def sort_column
    current_user.cases.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
