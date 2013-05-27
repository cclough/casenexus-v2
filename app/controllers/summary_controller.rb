class SummaryController < ApplicationController

  before_filter :authenticate_user!
  before_filter :completed_user
  
	layout 'profile'

	def index
		# Identical to events/index
		@events_by_date = current_user.events.group_by {|i| i.datetime.to_date}
    	@date = params[:date] ? Date.parse(params[:date]) : Date.today

    	@cases = current_user.cases.paginate(per_page: 5, page: params[:page])
    	@events = current_user.events.paginate(per_page: 5, page: params[:page])
    	@friends = current_user.accepted_friends.first(10)
	
      # @friends = current_user.accepted_friends
      @books = Book.all 

      # Send a Pusher notification

      # Pusher.trigger('private-4', 'new_message', {:from => "christian", :subject => "hello"})

  end

end
