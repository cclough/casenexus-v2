class MembersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user, except: [:show_help, :help_checkbox]

  # Map - access via /map
  def index

    users_pre_scope = User.where(["users.id <> ?",current_user.id]).where(degree_level:params[:users_filter_degreelevel]).search_for(params[:search]).order("last_online_at desc")

    # Set scope of users list depending on params from filter menu
    case params[:users_listtype]

      when "local"
        users_scope = users_pre_scope.list_local(current_user)
      when "new"
        users_scope = users_pre_scope.list_new
      when "online_today"
        users_scope = users_pre_scope.list_online_today
      when "online_now"
        users_scope = users_pre_scope.list_online_now
      when "posts"
        users_scope = users_pre_scope.list_users_with_posts

      when "language"
        users_scope = users_pre_scope.list_language(params[:users_filter_language])
    else
      # users_scope = User.includes(:cases).list_global
    end

    if users_scope
      @users = users_scope.paginate(per_page: 50, page: params[:page])
    end

    respond_to do |format|
      format.js # links index.js.erb!
      format.json { render json: User.markers(@users) } # USING get_markers_within_viewport INSTEAD
    end

  end


  def show
    @user = User.find(params[:id])

    unless Visit.shouldnt_create?(current_user, @user)
      @user.visits.create(visitor_id: current_user.id)
    end

    # if via ajax render without layout form map, else redirect to map and profile link
    if request.xhr?
      render layout: false
    else
      redirect_to '/map?user_id='+params[:id]
    end
  end

  def show_small
    @user = User.find(params[:id])
    
    render layout: false
  end

  def mouseover
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def show_help
    column_name = "help_#{params[:page_id]}_checked"
    if params[:act] == "uncheck"
      current_user.update_attribute(column_name, false)
    elsif params[:act] == "check"
      current_user.update_attribute(column_name, true)
    end
    render text: "OK"
  end

  def help_checkbox
    @help_page = params[:help_page]

    respond_to do |format|
      format.html { render layout: false }
    end
  end

end
