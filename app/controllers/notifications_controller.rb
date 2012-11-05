class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  helper_method :sort_column, :sort_direction

  def index
    notification_scope = current_user.notifications
    if !params[:ntype].blank? && params[:ntype] != "all"
      notification_scope = notification_scope.where(ntype: params[:ntype])
    end

    @notifications = notification_scope.search_for(params[:search]).order(sort_column + " " + sort_direction).paginate(per_page: 10, page: params[:page])
    @notifications.all
  end

  def show
    @notification = current_user.notifications.find(params[:id])
    @notifications = Notification.history(@notification.user_id, @notification.sender_id)

  end

  def create
    @notification = @user.notifications.build(params[:notification])
    @notification.sender = current_user

    respond_to do |format|

      if @notification.save
        case params[:notification][:ntype]
          when "feedback_req"
            format.js
            flash.now[:success] = 'Feedback request sent'
          when "message"
            format.js
            flash.now[:success] = 'Message sent'
          when "friendship_req"
            flash.now[:success] = 'Contact request sent'
            format.js
        end
      else
        case params[:notification][:ntype]
          when "message", "feedback_req", "friendship_req"
            @user = @notification.target
            format.js
        end
      end
    end
  end

  private

  def sort_column
    current_user.notifications.column_names.include?(params[:sort]) ? params[:sort] : "notifications.created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end
