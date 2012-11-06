class SiteContactsController < ApplicationController
  def create
    @site_contact = SiteContact.new(params[:site_contact])
    @site_contact.user = current_user if current_user

    if @site_contact.save
      flash[:notice] = "We received your message"
      render 'create_ok'
    else
      flash[:error] = "There was an error"
      render 'create_error'
    end
  end

  def feedback
    @feedback = Feedback.new(params[:feedback])
    @feedback.user = current_user

    if @feedback.save
      flash[:notice] = "We received your feedback"
      render 'feedback_ok'
    else
      flash[:error] = "There was an error"
      render 'feedback_error'
    end
  end
end
