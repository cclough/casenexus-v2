class AccountController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user, except: [:complete, :update]

  def show
    redirect_to action: :edit
  end

  def edit
    @user = current_user
    render partial: 'edit', layout: false
  end

  def visitors
    @users = User.all
    render layout:false
  end

  def update
    @user = current_user

    if @user.update_attributes(params[:user])
      if @user.completed
        flash[:success] = 'Your profile has been updated.'
        respond_to do |format|
          format.js
          format.html { redirect_to '/' }
        end
      else
        respond_to do |format|

          if params[:user][:complete_page] == "end"
            flash[:success] = 'Welcome ' + @user.username
            @user.completed = true
            @user.save
            format.html { redirect_to '/' }
          else
            format.js
          end
          
        end
      end
    else
      # @invitations = current_user.invitations
      # @invitation = current_user.invitations.build(params[:invitation])

      if params[:back_url]
        if params[:back_url].include?('complete')
          respond_to do |format|
            format.js
            format.html { render 'complete', layout: "home" }
          end
        else
          redirect_to params[:back_url]
        end
      else
        respond_to do |format|
          format.js
          format.html { render template: "account/edit_password" }
        end
      end
    end


  end

  def complete
    @friendship = Friendship.new
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
