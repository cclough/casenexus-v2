class UserMailer < ActionMailer::Base
  default :from => "info@casenexus.com"
  # is layout below actually used?
 	layout 'email' # use awesome.(html|text).erb as the layout

  # host prefix for all email URLs
  url_host = "https://radiant-shore-5325.herokuapp.com/"

  def welcome_email(user)
    @user = user
    @url  = "http://www.casenexus.com/signin"
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "casenexus: Welcome")
  end

end