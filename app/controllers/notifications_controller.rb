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

      user_target = @notification.target
      url = @notification.url

      # used as message, but also case subject
      !@notification.content.nil? ? content = @notification.content : nil
			!@notification.event_date.nil? ? event_date = @notification.event_date : nil

      case params[:notification][:ntype]
      when "welcome" then UserMailer.welcome(user_target, url).deliver
      when "message" then UserMailer.message(user_target, url, content).deliver
      when "feedback" then UserMailer.feedback(user_target, url, content, event_date).deliver
      when "feedback_req" then UserMailer.feedback_req(user_target, url, content, event_date).deliver
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
