class ProfileController < ApplicationController
  def index
    @friends = current_user.accepted_friends
    @cases = current_user.cases

    @case_count_bracket = current_user.case_count_bracket

  end
end
