class NotificationObserver < ActiveRecord::Observer


  def after_create(model)
    # code to send confirmation email...
  end

  

end
