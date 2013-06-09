class SummaryController < ApplicationController

  before_filter :authenticate_user!
  before_filter :completed_user
  
	layout 'profile'

	def index

  end

end
