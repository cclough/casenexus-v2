class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  helper_method :sort_column, :sort_direction


  def index
    @notifications = Notification.most_recent_for(current_user.id).includes(:sender).includes(:user).search_for(params[:search]).paginate(per_page: 12, page: params[:page])
  
    respond_to do |format|
      format.js
      format.html
    end

  end


  def show
    # of user
    @id = params[:id]

    @sender = User.find(@id)

    if @sender == current_user
      @notifications = current_user.notifications_sent.order('created_at')
    else
      @notifications = Notification.history(current_user, @sender)
    end
    
    @notifications.each { |n| n.read! }

    # for new message
    @notification = Notification.new

    render layout: false

  end

  def conversation
    @id = params[:id]

    render partial: "conversation", layout: false
  end

  def modal_message_form
    @user = User.find(params[:id])
    @notification = @user.notifications.build

    render partial: "shared/modal_message_form", layout:false
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
            flash.now[:success] = 'Case Partner request sent'
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
    # @notifications = Notification.header(current_user)

    render partial: "menu", layout: false
  end


  def read
    @notification = current_user.notifications.find(params[:id])
    @notification.read!
    render text: "OK"
  end

end
