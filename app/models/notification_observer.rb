class NotificationObserver < ActiveRecord::Observer


  def after_create(notification)

    # NB .content has varying roles
    user_from = User.find_by_id(notification.sender_id)

    case notification.ntype
    when "welcome"
      UserMailer.welcome(notification.target, 
                         notification.url).deliver
    when "feedback"
      UserMailer.feedback(user_from,
                          notification.target, 
                          notification.url, 
                          notification.event_date,
                          notification.content).deliver
    when "feedback_req"
      UserMailer.feedback_req(user_from,
                              notification.target, 
                              notification.url,
                              notification.event_date,
                              notification.content).deliver
    when "message"
      UserMailer.usermessage(user_from,
                             notification.target, 
                             notification.url, 
                             notification.content).deliver
    when "friendship_req"
      UserMailer.friendship_req(user_from,
                                notification.target,
                                notification.url,
                                notification.content).deliver
    when "friendship_app"
      UserMailer.friendship_app(user_from,
                                notification.target, 
                                notification.url).deliver
    end
  
  end

end
