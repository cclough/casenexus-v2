class MembersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user, except: [:show_help, :help_checkbox]

  # Map - access via /map
  def index

    # Set scope of users list depending on params from filter menu
    case params[:users_listtype]

      when "local"
        users_scope = User.includes(:cases).list_local(current_user)
      when "online_today"
        users_scope = User.includes(:cases).list_online_today
      when "global"
        users_scope = User.includes(:cases).list_global


      when "language"
        users_scope = User.includes(:cases).list_language(params[:users_filter_language])
      when "firm"
        users_scope = User.includes(:cases).list_firm(params[:users_filter_firm])
      when "university"
        users_scope = User.includes(:cases).list_university(params[:users_filter_university])
      when "country"
        users_scope = User.includes(:cases).list_country(params[:users_filter_country])

    end

    # Using scoped_search gem
    if users_scope
      @users = users_scope.search_for(params[:search]).paginate(per_page: 16, page: params[:page])
    end

    respond_to do |format|
      format.js # links index.js.erb!
      format.json { render json: User.markers } # USING get_markers_within_viewport INSTEAD
    end

  end


  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def show_infobox
    @user = User.find(params[:id])

    respond_to do |format|
      format.html { render layout: false }
    end
  end


  def show_modals
    @user = User.find(params[:id])
    
    @notification = @user.notifications.build
    @friendship = @user.friendships.build unless Friendship.exist?(current_user, @user)
    
    respond_to do |format|
      format.html { render layout: false }
    end
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
