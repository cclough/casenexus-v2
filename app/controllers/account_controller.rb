class AccountController < ApplicationController
  before_filter :authenticate_user!

  def show
    #@user = current_user
    redirect_to action: :edit
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
        flash[:success] = 'Your profile has been updated'
      else
        @user.completed = true
        @user.save
        flash[:success] = 'Welcome to casenexus.com'
      end
      redirect_to map_path
    else
      @invitations = current_user.invitations
      @invitation = current_user.invitations.build(params[:invitation])

      if params[:back_url]
        if params[:back_url].include?('complete')
          render 'complete_profile'
        else
          redirect_to params[:back_url]
        end
      else
        render 'edit'
      end
    end
  end

  def complete_profile
    @user = current_user
  end

  def edit_password
    @user = current_user
  end

  def delete
    @user = current_user
  end

  def destroy
    @user = current_user
    @user.destroy
    flash[:success] = "Your account has now been deleted."
    redirect_to root_path
  end

  def random_name
    @first_name = Faker::Name.first_name
    @last_name = Faker::Name.last_name
  end
end
