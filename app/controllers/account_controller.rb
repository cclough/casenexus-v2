class AccountController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user

    @invitations = current_user.invitations
    redirect_to action: index, notice: "You have already invited 5 friends" if current_user.invitations.count >= Invitation::INVITATION_LIMIT
    @invitation = Invitation.new
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
      render 'edit'
    end
  end

  def complete_profile
    @user = current_user
  end

  def show_help
    # current_user.help_+params[:help_id]? ? current_user.help_+params[:help_id]? == false : nil
  end

end
