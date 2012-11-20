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
    mail(to: email_with_name, subject: "casenexus: You have been sent feedback on a case")
  end

  def friendship_req(user_from, user_target, url, message)
    @user_from = user_from
    @user_target = user_target
    @url = url
    @message = message

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus: You have been sent a Case Partner request")
  end

  def friendship_app(user_from, user_target, url)
    @user_from = user_from
    @user_target = user_target
    @url = url

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus: Your Case Partner request has been accepted")
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

    mail(to: receiver, subject: "Invitation to casenexus.com")
  end

  def site_contact(site_contact)
    sender = site_contact.email
    receiver = "info@casenexus.com"

    @site_contact = site_contact

    mail(to: receiver, subject: "Site Contact: #{site_contact.subject}")
  end

  def site_bug(site_bug)
    sender = "#{site_bug.user.name} <#{site_bug.user.email}>"
    receiver = "info@casenexus.com"

    @site_bug = site_bug

    mail(to: receiver, subject: "Site Bug")
  end

  def status_approved(user)
    @user = user
    email_with_name = "#{user.name} <#{@user.email}>"

    mail(to: email_with_name, subject: "Casenexus: Your status was approved")
  end

  def status_rejected(user)
    @user = user
    email_with_name = "#{user.name} <#{@user.email}>"

    mail(to: email_with_name, subject: "Casenexus: Your status was rejected")
  end

  def moderation_to_admin(user)
    @user = user

    mail(to: "info@casenexus.com", subject: "User moderation required")
  end

end