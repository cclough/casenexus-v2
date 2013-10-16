class ProfileController < ApplicationController

  before_filter :authenticate_user!
  before_filter :completed_user


  def index
    @friends = current_user.accepted_friends.order("username ASC")
    @friends_requested = current_user.requested_friends.order("username ASC")

    @cases = current_user.cases.order("created_at desc")

    @case_count_bracket = current_user.case_count_bracket

  end

end
