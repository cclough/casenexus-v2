class ProfileController < ApplicationController
  def index
    @friends = current_user.accepted_friends
    @cases = current_user.cases
  end
end
