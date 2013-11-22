class MembersController < ApplicationController
  before_filter :authenticate_user!
  # before_filter :completed_user

  # Map - access via /map
  def index

    users_pre_scope = User.users_allowed_on_map.where(degree_level:params[:users_filter_degreelevel]).list_language(params[:users_filter_language]).list_by_experience(params[:users_filter_experience]).search_for(params[:search])

    require 'will_paginate/array' # neccessary to allow params to work in members

    # Set scope of users list depending on params from filter menu
    case params[:users_listtype]
      when "params"
        target_user = User.find(params[:user_id])
        users_scope = users_pre_scope.list_local(target_user,true).reverse! # reverse brings current_user to the top
      when "local"
        users_scope = users_pre_scope.list_local(current_user,true).reverse! # reverse brings current_user to the top
      when "all"
        users_scope = users_pre_scope.list_all_excl_current(current_user)
      when "new"
        users_scope = users_pre_scope.list_new
      when "online_today"
        users_scope = users_pre_scope.list_online_today(current_user)
      when "online_now"
        users_scope = users_pre_scope.list_online_now(current_user)
    else # user on complete_profile
      users_scope = User.users_allowed_on_map.list_all_excl_current(current_user)
    end

    if users_scope
      @users_unpaginated = users_scope.sort_by{|e| -e.cases_per_week}
      @users = @users_unpaginated.paginate(per_page: 20, page: params[:page])
    end

    respond_to do |format|
      format.js # links index.js.erb!
      format.json { render json: User.markers_geojson(@users_unpaginated) } # IS NEEDED FOR COMPLETE APPARENTLY
    end

  end

  def show
    user = User.find(params[:id])

    render partial: "users_item", layout: false, locals: { users_item: user}
  end

end
