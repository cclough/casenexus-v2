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

    @user = User.find(params[:notification][:user_id])
    @notification = @user.notifications.build(params[:notification])

    respond_to do |format|

      if @notification.save

        case params[:notification][:ntype]
        when "feedback_req"
          format.js
          #flash.now[:success] = 'Feedback request sent'
        when "message"
          format.js
          #flash.now[:success] = 'Message sent'
        when "friendship_req"
          format.js
          #flash.now[:success] = 'Message sent'
        end

      else

        case params[:notification][:ntype]
        when "message", "feedback_req", "friendship_req"
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
