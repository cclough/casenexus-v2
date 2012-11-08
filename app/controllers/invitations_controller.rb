class InvitationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  def create
    @invitation = current_user.invitations.build(params[:invitation])

    if @invitation.save
      flash[:notice] = "The Invitation was sent to #{@invitation.email}"
      redirect_to action: :index
    else
      flash[:error] = "There was a problem with the Invitation"
      render action: :new
    end
  end

  def destroy
    @invitation = current_user.invitations.find(params[:id])
    @invitation.destroy
    flash[:notice] = "Invitation cancelled"
    redirect_to action: :index
  end
end
