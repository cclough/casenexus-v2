class MembersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  # Map - access via dashboard/
  def index

    # Set scope of users list depending on params from filter menu
    case params[:users_listtype]
      when "global"
        users_scope = User.includes(:cases).list_global
      when "local"
        users_scope = User.includes(:cases).list_local(current_user)
      when "rand"
        users_scope = User.includes(:cases).list_rand
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
    #current_user.update_attribute(column_name, true)
    render text: "OK"
  end
end
