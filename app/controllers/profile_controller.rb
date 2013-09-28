class ProfileController < ApplicationController

  before_filter :authenticate_user!
  before_filter :completed_user


  def index
    @friends = current_user.accepted_friends
    @friends_pending = current_user.pending_friends

    @cases = current_user.cases

    @case_count_bracket = current_user.case_count_bracket

  end
end
