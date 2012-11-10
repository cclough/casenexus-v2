class AccountController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user

    @invitations = Invitation.where(user_id: current_user.id)
    @invitation = current_user.invitations.build(params[:invitation])
  end

  def update
    @user = current_user

    if @user.update_attributes(params[:user])
      if @user.completed
        flash[:success] = 'Success - Profile updated'
      else
        @user.toggle!(:completed)
        flash[:success] = 'Welcome to casenexus.com'
      end
      redirect_to dashboard_path
    else
      @invitations = current_user.invitations
      @invitation = current_user.invitations.build(params[:invitation])

      if params[:back_url]
        redirect_to params[:back_url]
      else
        render 'edit'
      end
    end
  end

  def complete_profile
    @user = current_user
  end
end
