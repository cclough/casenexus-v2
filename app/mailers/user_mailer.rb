class UserMailer < ActionMailer::Base
  
  default from: "mailer@casenexus.com"

  # is layout below actually used?
 	layout 'email'


  def welcome(user_target, url)
    @user_target = user_target
    @url  = url

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus: Welcome")
  end

  # conflicts with actionmailer function if just called message
  def usermessage(user_from, user_target, url, message)
    @user_from = user_from
    @user_target = user_target
    @url  = url
    @message = message
    
    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus: You have been sent a message")
  end

  def feedback_req(user_from, user_target, url, date, subject)
    @user_from = user_from
    @user_target = user_target
    @url  = url
    @date = date
    @subject = subject
    
    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus: You have been sent a feedback request")
  end

  def feedback(user_from, user_target, url, date, subject)
    @user_from = user_from
    @user_target = user_target
    @url  = url
    @date = date
    @subject = subject
    
    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus: You have been sent case feedback")
  end

  def password_reset(user)
    @user_target = user

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus: Password Reset")
  end
end