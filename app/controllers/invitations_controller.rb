class InvitationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  def index
    @invitations = Invitation.where(user_id: current_user.id)
    @invitation = current_user.invitations.build(params[:invitation])
    
    render partial: "index", layout: false
  end

  def show
    redirect_to "/"
  end

  def create
    @invitation = current_user.invitations.build(params[:invitation])

    respond_to do |format|
      if @invitation.save
        flash[:notice] = "An invitation was sent to #{@invitation.email}."
        format.js
      else
        @invitations = Invitation.where(user_id: current_user.id)
        format.js
      end
    end
  end

  def destroy
    @invitation = current_user.invitations.find(params[:id])
    @invitation.destroy
    flash[:notice] = "Invitation cancelled."
    redirect_to "/"
  end
end
