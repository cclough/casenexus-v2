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



    # Period
    if params[:resultstable_period] then @period = params[:resultstable_period].to_i else @period = 1 end

    # For table
    hash = Hash[@case.cases_show_table]
    if (params[:resultstable_order_by] == "order")
      @table_hash = hash.sort_by{|k, v| v}.reverse
    elsif (params[:resultstable_order_by] == "group")
      @table_hash = hash.sort_by{|k, v| k}
    else
      @table_hash = hash.sort_by{|k, v| v}.reverse      
    end


    respond_to do |format|
      format.html { render layout: false }
      format.js #for table form
    end


  end

  def new
    @user = User.find(params[:user_id])

    unless Friendship.friendship(current_user, @user)
      flash[:error] = "You are not friend with #{@user.username}"
      redirect_to map_path and return
    end

    if params[:subject] then
      @subject = params[:subject]
    end

    @case = @user.cases.build


    render partial: "new", layout: false
  end

  def create
    user_id = params[:case].delete(:user_id)
    @case = Case.new(params[:case])
    @case.user_id = user_id
    @case.interviewer = current_user


    respond_to do |format|

      if @case.save
        flash[:success] = 'Feedback sent successfully to ' + @case.user.username
        #redirect_to map_path
        format.js #for table form
      else
        @user = @case.user
        format.js #for table form
        #render 'new', layout: "cases_clipped"
      end

    end

  end


  def analysis

    # CHAGNE? Same as period
    @case_count_bracket = current_user.case_count_bracket

    # Period
    if params[:resultstable_period] then @period = params[:resultstable_period].to_i else @period = 1 end

    # For table
    hash = Hash[Case.cases_analysis_table(current_user, @period)]
    if (params[:resultstable_order_by] == "order")
      @table_hash = hash.sort_by{|k, v| v}.reverse
    elsif (params[:resultstable_order_by] == "group")
      @table_hash = hash.sort_by{|k, v| k}
    else
      @table_hash = hash.sort_by{|k, v| v}.reverse      
    end

    # which view to show?
    if params[:view] then @view = params[:view] else @view = "table" end

    respond_to do |format|
      format.html { render layout:false }
      format.json { render json: Case.cases_analysis_chart_progress_data(current_user) }
      format.js #for table form
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
