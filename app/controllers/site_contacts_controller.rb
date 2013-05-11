class SiteContactsController < ApplicationController

  def create_contact
    @site_contact = SiteContact.new(params[:site_contact])
    @site_contact.user = current_user if current_user

    if @site_contact.save
      flash[:notice] = "Thank you for your message"
      render 'create_contact_ok'
    else
      # Not neccessary as errors handled in the form
      # flash[:error] = "Oops! There was an error"
      render 'create_contact_error'
    end
  end

end
