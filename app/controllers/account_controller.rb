class AccountController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user, except: [:complete_profile, :update]

  def show
    #@user = current_user
    redirect_to action: :edit
  end

  def edit
    @user = current_user

    render partial: 'edit', layout:false
  end

  def visitors
    @users = User.all

    render layout:false
  end

  def update
    @user = current_user


    if @user.update_attributes(params[:user])
      if @user.completed
        flash[:success] = 'Your profile has been updated'
        respond_to(:js)
      else
        @user.completed = true
        @user.save
        flash[:success] = 'Welcome'
        redirect_to "/"
      end
    else
      @invitations = current_user.invitations
      @invitation = current_user.invitations.build(params[:invitation])

      if params[:back_url]
        if params[:back_url].include?('complete')
          render 'complete_profile', layout: "home"
        else
          redirect_to params[:back_url]
        end
      else
        respond_to(:js)
      end
    end


  end

  def complete_profile
    @user = current_user

    if @user.completed?
      redirect_to "/"
    else
      render layout: 'home'
    end

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


end
