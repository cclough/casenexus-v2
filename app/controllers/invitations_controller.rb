class InvitationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  def create
    @invitation = current_user.invitations.build(params[:invitation])

    if @invitation.save
      flash[:notice] = "The Invitation was sent to #{@invitation.email}"
      if params[:back_url]
        redirect_to params[:back_url]
      else
        redirect_to action: :index
      end
    else
      flash[:error] = "There was a problem with the Invitation"
      if params[:back_url]
        redirect_to params[:back_url]
      else
        render action: :new
      end
    end
  end

  def destroy
    @invitation = current_user.invitations.find(params[:id])
    @invitation.destroy
    flash[:notice] = "Invitation cancelled"
    if params[:back_url]
      redirect_to params[:back_url]
    else
      redirect_to action: :index
    end
  end
end
