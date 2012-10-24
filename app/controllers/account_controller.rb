class AccountController < ApplicationController
  def show
    @user = current_user

    # TODO: This actually should go on the members controller
    respond_to do |format|
      @notification = @user.notifications.build
      @friendship = @user.friendships.build unless current_user.friend_with?(@user)

      format.html { render :layout => false }
    end
  end

  def edit
    @user = current_user
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
      redirect_to dashbaord_path
    else
      render 'edit'
    end
  end
end
