class MapController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  def index
    # All the ajax actions for users/members should go to the members controller
  end

end