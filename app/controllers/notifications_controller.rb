class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  def index
    @notifications = Notification.most_recent_for(current_user.id).includes(:sender).includes(:user).search_for(params[:search]).paginate(per_page: 25, page: params[:page])
    
    # For open conversation
    if Notification.most_recent_for(current_user.id).count > 0
      @last_user = Notification.includes(:sender).most_recent_conversation_with(current_user)
      @id = @last_user.id # of user
      @user = @last_user
      @notification = @user.notifications.build
    end

    respond_to do |format|
      format.js
      format.html
    end
  end

  def show # notifications#index right panel
    @id = params[:id] # of user
    @user = User.find(@id)
    @notification = @user.notifications.build

    # # mark them as read here, even though used SQL call is in partial - SAD
    # Notification.history(current_user, @sender).each { |n| n.read! }

    render partial: "show", layout: false
  end

  def conversation
    @id = params[:id] # of user

    render partial: "conversation", layout: false
  end

  def modal_message_form
    @user = User.find(params[:id])
    @notification = @user.notifications.build

    render partial: "notifications/modal_message_form", layout:false
  end

  def create
    @notification = Notification.new(params[:notification])
    @notification.sender = current_user

    respond_to do |format|

      if @notification.save
        case params[:notification][:ntype]
          when "message"
            format.js
            # format.html { redirect_to (notifications_path) }
            flash.now[:success] = 'Message sent to ' + @notification.sender.username
          when "friendship_req"
            format.js
            flash.now[:success] = 'Partner request sent'
        end

        # Send a Pusher notification
        Pusher['private-' + @notification.user_id.to_s].trigger('new_message', {:from => @notification.sender.username, :from_id => @notification.sender.id, :notification_id => @notification.id})

      else
        case params[:notification][:ntype]
          when "message", "friendship_req"
            @user = @notification.user
            format.js
        end
      end
    end
  end

  def notify
    @notification = Notification.find(params[:id])

    render layout: false
  end

  def menu
    @unread_count = current_user.notifications.unread.for_display.count

    render partial: "menu", layout: false
  end

end
