class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  helper_method :sort_column, :sort_direction

  layout 'profile'

  def index
    notification_scope = current_user.notifications.for_display
    if !params[:ntype].blank? && params[:ntype] != "all"
      notification_scope = notification_scope.where(ntype: params[:ntype])
    end

    # @notifications = notification_scope.search_for(params[:search]).order("notifications."+sort_column + " " + sort_direction).paginate(per_page: 10, page: params[:page])

    @notifications = User.where(id: current_user.id).joins(:notifications).order('notifications.created_at DESC')


    # @notifications.all


  end

  def show
    #@notification = current_user.notifications.for_display.find(params[:id])
    # @notification_for_display = current_user.notifications.find(params[:id])



    # for jump to
    @id = params[:id]

    @sender = User.find(@id)

    @notifications = Notification.history(current_user, @sender)
    
    @notifications.each { |n| n.read! }

    # for new message
    @notification = Notification.new

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
            format.html { redirect_to (@notification) }
            flash.now[:success] = 'Message sent'
          when "feedback_req"
            format.js
            flash.now[:success] = 'Feedback request sent'
          when "friendship_req"
            flash.now[:success] = 'Case Partner request sent'
            format.js
        end

        # Send a Pusher notification
        Pusher['private-' + @notification.user_id.to_s].trigger('new_message', {:from => @notification.sender.name, :subject => @notification.content_trunc})

      else
        case params[:notification][:ntype]
          when "message", "feedback_req", "friendship_req"
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

  private

  def sort_column
    current_user.notifications.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end
