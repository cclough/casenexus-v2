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

    if @notification.save

      # NB .content has varying roles
      case params[:notification][:ntype]
      when "welcome" then UserMailer.welcome(@notification.target, 
                                             @notification.url).deliver
      when "message" then UserMailer.message(@notification.target, 
                                             @notification.url, 
                                             @notification.content).deliver
      when "feedback" then UserMailer.feedback(@notification.target, 
                                               @notification.url, 
                                               @notification.content, 
                                               @notification.event_date).deliver
      when "feedback_req" then UserMailer.feedback_req(@notification.target, 
                                                       @notification.url,
                                                       @notification.content, 
                                                       @notification.event_date).deliver
      end

      flash.now[:success] = 'Notification sent & emailed!'
    else
    	flash.now[:error] = 'Notification could not be saved!'
    end

	end

	private

    def correct_user
      @notification = current_user.notifications.find_by_id(params[:id])
      redirect_to root_path if @notification.nil?
    end
	
end
