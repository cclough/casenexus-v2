class UserMailer < ActionMailer::Base

  default from: "mailer@casenexus.com"

  layout 'email'


  def welcome(user_target, url)
    @user_target = user_target
    @url = url

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus: Welcome")
  end


  # conflicts with actionmailer function if just called message
  def usermessage(user_from, user_target, url, message)
    @user_from = user_from
    @user_target = user_target
    @url = url
    @message = message

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus: You have been sent a message")
  end


  def feedback_req(user_from, user_target, url, date, subject)
    @user_from = user_from
    @user_target = user_target
    @url = url
    @date = date
    @subject = subject

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus: You have been sent a feedback request")
  end

  def feedback(user_from, user_target, url, date, subject)
    @user_from = user_from
    @user_target = user_target
    @url = url
    @date = date
    @subject = subject

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus: You have been sent case feedback")
  end

  def friendship_req(user_from, user_target, url, message)
    @user_from = user_from
    @user_target = user_target
    @url = url
    @message = message

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus: You have been sent a contact request")
  end

  def friendship_app(user_from, user_target, url)
    @user_from = user_from
    @user_target = user_target
    @url = url

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus: Your contact request has been accepted")
  end

  def password_reset(user)
    @user_target = user

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus: Password Reset")
  end

  def invitation(invitation)
    sender = invitation.user.email
    receiver = "#{invitation.name} <#{invitation.email}>"

    @invitation = invitation

    mail(to: receiver, from: sender, subject: "Invitation to Casenexus")
  end

  def site_contact(site_contact)
    sender = site_contact.email
    receiver = "info@casenexus.com"

    @site_contact = site_contact

    mail(to: receiver, from: sender, subject: "Casenexus contact: #{site_contact.subject}")
  end
end