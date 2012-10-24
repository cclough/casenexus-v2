class AccountController < ApplicationController
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  # TODO: We should not ask for password, it log off the user when its updated
  def update
    @user = current_user

    if @user.update_attributes(params[:user])
      if @user.completed
        flash[:success] = 'Success - Profile updated'
      else
        @user.toggle!(:completed)
        flash[:success] = 'Welcome to casenexus.com'
      end
      redirect_to dashbaord_path
    else
      render 'edit'
    end
  end
end
