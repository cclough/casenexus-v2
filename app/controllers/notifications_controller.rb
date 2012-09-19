class NotificationsController < ApplicationController

  before_filter :signed_in_user, only: [:index, :show, :create]
  before_filter :correct_user, only: [:show]

	def index
  	@notifications = current_user.notifications.paginate(per_page: 10, page: 
                     params[:page], order: "created_at DESC")
	end

	def show
		@notification = Notification.find(params[:id])

		@notification.read? ? nil : @notification.toggle!(:read) 
	end

	def create

    @notification = Notification.new(params[:notification])

    respond_to do |format|

      if @notification.save

        case params[:notification][:ntype]
        when "feedback_req"
          format.js
          flash.now[:success] = 'Feedback request sent'
        when "message"
          format.js
          flash.now[:success] = 'Message sent'
        when "friend_req"
          format.js
          flash.now[:success] = 'Contact Request sent'
        end

      else
        
        case params[:notification][:ntype]
        when "message", "feedback_req", "friend_req"
          # need to declare target user again for form
          @user = @notification.target
          format.js
        end

      end

    end
	
  end

	private

    def correct_user
      @notification = current_user.notifications.find_by_id(params[:id])
      redirect_to root_path if @notification.nil?
    end
	
end
