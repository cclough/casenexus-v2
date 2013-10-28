class ProfileController < ApplicationController

  before_filter :authenticate_user!
  before_filter :completed_user

  def index
    @friends = current_user.accepted_friends.order("username ASC").includes(:university)
    
    @friends_requested = current_user.requested_friends.order("username ASC")

    @cases = current_user.cases.includes(:interviewer).order("created_at desc")

    @case_count_recd = current_user.case_count_recd

    @post_in_view = Post.where("approved = true").order("created_at asc").last
  
    @current_user_id_masked = current_user.obfuscated_id
  end

end
