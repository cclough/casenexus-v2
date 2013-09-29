class ProfileController < ApplicationController

  before_filter :authenticate_user!
  before_filter :completed_user


  def index
    @friends = current_user.accepted_friends
    @friends_requested = current_user.requested_friends

    @cases = current_user.cases

    @case_count_bracket = current_user.case_count_bracket

  end
end
