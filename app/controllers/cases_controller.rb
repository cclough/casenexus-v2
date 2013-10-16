class CasesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user


  def show

    @case = current_user.cases.find(params[:id])
    @cases = current_user.cases.order("created_at asc")

    @case.read!

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

    # In case they enter something in the blank form before selecting a book
    if !@case.book_id.blank?
      @case.subject = ''
      @case.source = ''
    end

    respond_to do |format|

      if @case.save
        flash[:success] = 'Feedback sent successfully to ' + @case.user.username
        format.js #for table form
      else
        @user = @case.user
        format.js #for table form
      end

    end

  end


  def results

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

    @view = params[:view]
    
    respond_to do |format|
      format.html { render layout:false }
      format.json { render json: Case.cases_analysis_chart_progress_data(current_user) }
      format.js #for table form
    end


  end


end
