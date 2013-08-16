class UserMailer < ActionMailer::Base

  default from: "mailer@casenexus.com"

  layout 'email'

  def welcome(user_target, url, title)
    @user_target = user_target
    @url = url

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus.com: " + title)
  end

  def newuser_to_admin(user)
    @user = user

    mail(to: "info@casenexus.com", subject: "New User")
  end


  def newpost_to_admin(post)
    @post = post

    mail(to: "info@casenexus.com", subject: "New Post")
  end

  # conflicts with actionmailer function if just called message
  def usermessage(user_from, user_target, url, message, title)
    @user_from = user_from
    @user_target = user_target
    @url = url
    @message = message

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus.com: " + title)
  end

  def feedback(user_from, user_target, url, date, subject, title)
    @user_from = user_from
    @user_target = user_target
    @url = url
    @date = date
    @subject = subject

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus.com: " + title)
  end


  def friendship_req(user_from, user_target, url, message, title)
    @user_from = user_from
    @user_target = user_target
    @url = url
    @message = message

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus.com: " + title)
  end

  def friendship_app(user_from, user_target, url, title)
    @user_from = user_from
    @user_target = user_target
    @url = url

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus.com: " + title)
  end




  def event_setchangecancelremind_partner(user_from, user_target, event_id, title, url, ntype)
    @user_from = user_from
    @user_target = user_target
    @event = Event.find(event_id)
    @url = url
    @ntype = ntype

    # Attach selected case file, if selected
    unless (ntype == "event_cancel_partner") || @event.book_id_partnertoprepare.blank?
      @book_partnertoprepare = Book.find(@event.book_id_partnertoprepare)

      # host = Rails.env == 'production' ? 'www.casenexus.com' : 'localhost:3000'
      # url = Rails.application.routes.url_helpers.root_url(host: host)
      attachments["case.pdf"] = File.read(File.join(Rails.root, 'app','assets','images','library',@book_partnertoprepare.url))
    end

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus.com: " + title)
  end

  def event_setchangecancelremind_sender(user_target, event_id, title, url, ntype)
    @user_target = user_target
    @event = Event.find(event_id)
    @url = url
    @ntype = ntype

    unless @event.book_id_partnertoprepare.blank?
      @book_partnertoprepare = Book.find(@event.book_id_partnertoprepare)
    end

    unless @event.book_id_usertoprepare.blank? #(ntype == "event_cancel_sender" || "event_set_sender") || 
      @book_usertoprepare = Book.find(@event.book_id_usertoprepare)

      # host = Rails.env == 'production' ? 'www.casenexus.com' : 'localhost:3000'
      # url = Rails.application.routes.url_helpers.root_url(host: host)
      attachments["case.pdf"] = File.read(File.join(Rails.root, 'app','assets','images','library',@book_usertoprepare.url))
    end

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus.com: " + title)
  end






  def password_reset(user)
    @user_target = user

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus.com: " + "Password Reset")
  end

  def invitation(invitation)
    receiver = "#{invitation.name} <#{invitation.email}>"

    @invitation = invitation

    if invitation.user.id == 1
      mail(to: receiver, subject: "Invitation to casenexus.com")
    else
      mail(to: receiver, subject: "Invitation to casenexus.com", template_name: 'invitation_user')
    end
  end

  def site_contact(site_contact)
    sender = site_contact.email
    receiver = "info@casenexus.com"

    @site_contact = site_contact

    mail(to: receiver, subject: "Site Contact: #{site_contact.subject}")
  end



  def case_pdf(user_from, user_target, book)
    
    @user_from = user_from
    @user_target = user_target
    @book = book

    host = Rails.env == 'production' ? 'www.casenexus.com' : 'localhost:3000'
    @url = Rails.application.routes.url_helpers.root_url(host: host)

    attachments["charts.pdf"] = File.read(File.join(Rails.root, 'app','assets','images','library','charts',book.charts_file_name))

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus.com: Charts for a Case") 

  end



  def points_unlock_voteup(user_target, title, url)
    @user_target = user_target
    @url = url

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus.com: " + title)
  end

  def points_unlock_votedown(user_target, title, url)
    @user_target = user_target
    @url = url

    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(to: email_with_name, subject: "casenexus.com: " + title)
  end
end