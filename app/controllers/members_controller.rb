class MembersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  # Map - access via /map
  def index

    # Set scope of users list depending on params from filter menu
    case params[:users_listtype]
      when "global"
        users_scope = User.includes(:cases).list_global
      when "local"
        users_scope = User.includes(:cases).list_local(current_user)
      when "contacts"
        users_scope = current_user.accepted_friends.includes(:cases)
    end

    # Using scoped_search gem
    if users_scope
      @users = users_scope.search_for(params[:search]).paginate(per_page: 10, page: params[:page])
    end

    respond_to do |format|
      format.js # links index.js.erb!
      format.json { render json: User.markers } # USING get_markers_within_viewport INSTEAD
    end

  end


  # used without layout on map page only
  def show
    @user = User.find(params[:id])

    # defines radar chart last 5 count
    (current_user.cases.where("interviewer_id = #{@user.id}").count < 6) ? (@radar_count = 1) : (@radar_count = 5)

    respond_to do |format|
      @notification = @user.notifications.build
      @friendship = @user.friendships.build unless Friendship.exist?(current_user, @user)

      format.html { render layout: false }
    end
  end

  def tooltip
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

  def check_roulette
    if !params[:roulette_token].blank? && User.where(roulette_token: params[:roulette_token]).exists?
      @user = User.where(roulette_token: params[:roulette_token]).first
      render text: @user.id
    else
      render text: "-1"
    end
  end

end
