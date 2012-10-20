class DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  def index
# Set scope of users list depending on params from filter menu
    case params[:users_listtype]
      when "global"
        users_scope = User.list_global
      when "local"
        users_scope = User.list_local(current_user.lat, current_user.lng)
      when "rand"
        users_scope = User.list_rand
      when "friendships"
        users_scope = User.list_contacts
    end

    # Using scoped_search gem
    if users_scope
      @users = users_scope.search_for(params[:search]).paginate(per_page: 10, page: params[:page])
    end

    respond_to do |format|
      format.html
      format.js # links index.js.erb!
      format.json { render json: User.markers } # USING get_markers_within_viewport INSTEAD
    end
  end
end
