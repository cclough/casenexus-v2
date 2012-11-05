class InvitationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  def index
    @invitations = current_user.invitations
  end

  def new
    redirect_to action: index, notice: "You have already invited 5 friends" if current_user.invitations.count >= Invitation::INVITATION_LIMIT
    @invitation = Invitation.new
  end

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
