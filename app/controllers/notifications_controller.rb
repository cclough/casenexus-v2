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

        # NB .content has varying roles
        case params[:notification][:ntype]
        when "welcome"
          UserMailer.welcome(@notification.target, 
                             @notification.url).deliver
        when "feedback"
          UserMailer.feedback(current_user,
                              @notification.target, 
                              @notification.url, 
                              @notification.event_date,
                              @notification.content).deliver
        when "feedback_req"
          UserMailer.feedback_req(current_user,
                                  @notification.target, 
                                  @notification.url,
                                  @notification.event_date,
                                  @notification.content).deliver
          format.js
          flash.now[:success] = 'Feedback request sent'
        when "message"
          UserMailer.usermessage(current_user,
                                 @notification.target, 
                                 @notification.url, 
                                 @notification.content).deliver
          format.js
          flash.now[:success] = 'Message sent'
        end

      else

        case params[:notification][:ntype]
        when "message", "feedback_req"
          # need to declare target user again for form
          @user = @notification.target
          format.js
        when "welcome", "feedback"
          flash.now[:error] = 'Notification could not be sent'
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
