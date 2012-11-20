class SiteContactsController < ApplicationController

  def create_contact
    @site_contact = SiteContact.new(params[:site_contact])
    @site_contact.user = current_user if current_user

    if @site_contact.save
      flash[:notice] = "Thank you for your message"
      render 'create_contact_ok'
    else
      flash[:error] = "Oops! There was an error"
      render 'create_contact_error'
    end
  end

  def create_bug
    @site_bug = SiteBug.new(params[:site_bug])
    @site_bug.user = current_user

    if @site_bug.save
      flash[:notice] = "Thank you for your feedback"
      render 'create_bug_ok'
    else
      flash[:error] = "Oops! There was an error"
      render 'create_bug_error'
    end
  end

end
