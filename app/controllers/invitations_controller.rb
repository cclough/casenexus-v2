class InvitationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  def index
    
    @invitations = Invitation.where(user_id: current_user.id)
    @invitation = current_user.invitations.build(params[:invitation])
    
    render layout: false

  end
  def show
    redirect_to edit_account_path
  end

  def create
    @invitation = current_user.invitations.build(params[:invitation])

    if @invitation.save
      flash[:notice] = "An invitation was sent to #{@invitation.email}"
      if params[:back_url]
        redirect_to params[:back_url]
      else
        redirect_to action: :index
      end
    else
      flash[:error] = "An error was encountered while sending the invitation."
      if params[:back_url]
        @invitation.errors.messages.each do |key, value|
          flash[:error] += "<br/>#{key}: #{value.join(", ")}.".html_safe
        end
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
