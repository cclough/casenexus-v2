class MapController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  def index
    # All the ajax actions for users/members should go to the members controller

    # (has to be in this controller)
    @post_in_view = Post.where("approved = true").order("created_at asc").last
  end

end