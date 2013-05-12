class SummaryController < ApplicationController

  before_filter :authenticate_user!
  before_filter :completed_user
  
	layout 'profile'

	def index
		# Identical to events/index
		@events_by_date = current_user.events.group_by {|i| i.datetime.to_date}
    	@date = params[:date] ? Date.parse(params[:date]) : Date.today
	end

end
