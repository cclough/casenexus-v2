class MembersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  # Map - access via /map
  def index

    users_pre_scope = User.where(degree_level:params[:users_filter_degreelevel]).list_language(params[:users_filter_language]).search_for(params[:search]).order("last_online_at desc")

    # Set scope of users list depending on params from filter menu
    case params[:users_listtype]
      when "params"
        require 'will_paginate/array' # neccessary to allow list_local to work in members
        target_user = User.find(params[:user_id])
        users_scope = users_pre_scope.list_local(target_user,true).reverse! # reverse brings current_user to the top
      when "local"
        require 'will_paginate/array' # neccessary to allow list_local to work in members
        users_scope = users_pre_scope.list_local(current_user,true).reverse! # reverse brings current_user to the top
      when "new"
        users_scope = users_pre_scope.list_new
      when "online_today"
        users_scope = users_pre_scope.where(["users.id <> ?",current_user.id]).list_online_today
      when "online_now"
        users_scope = users_pre_scope.where(["users.id <> ?",current_user.id]).list_online_now
    else
      users_scope = User.includes(:cases).list_all_excl_current(current_user)
    end

    if users_scope
      @users = users_scope.paginate(per_page: 10, page: params[:page])
    end

    respond_to do |format|
      format.js # links index.js.erb!
      format.json { render json: User.markers_geojson(@users) } # USING get_markers_within_viewport INSTEAD
    end

  end

end
