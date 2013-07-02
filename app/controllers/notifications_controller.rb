class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  helper_method :sort_column, :sort_direction

  layout 'profile'

  def index
    @notifications = Notification.most_recent_for(current_user.id).search_for(params[:search]).paginate(per_page: 20, page: params[:page])
    respond_to do |format|
      format.html
      format.js # for infinite scroll
    end

  end

  def show

    # for jump to
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

    @sender = User.find(@id)

    @notifications = Notification.history(current_user, @sender)

    render partial: "conversation", layout: false
  end

  def new_message_form
    @user = User.find(params[:id])
    @notification = @user.notifications.build

    render layout:false
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
            flash.now[:success] = 'Message sent'
          when "friendship_req"
            flash.now[:success] = 'Case Partner request sent'
            format.js
        end

        # Send a Pusher notification
        # Pusher['private-' + @notification.user_id.to_s].trigger('new_message', {:from => @notification.sender.name, :subject => @notification.content_trunc})

      else
        case params[:notification][:ntype]
          when "message", "friendship_req"
            @user = @notification.user
            format.js
        end
      end
    end
  end

  def read
    @notification = current_user.notifications.find(params[:id])
    @notification.read!
    render text: "OK"
  end

end
