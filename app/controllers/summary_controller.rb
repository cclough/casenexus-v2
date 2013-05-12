class SummaryController < ApplicationController

  before_filter :authenticate_user!
  before_filter :completed_user
  
	layout 'profile'

	def index
		# Identical to events/index
		@events_by_date = current_user.events.group_by {|i| i.datetime.to_date}
    	@date = params[:date] ? Date.parse(params[:date]) : Date.today

    	@cases = current_user.cases.first(10)
    	@events = current_user.events.first(10)
    	@friends = current_user.accepted_friends.first(10)
	end

end
