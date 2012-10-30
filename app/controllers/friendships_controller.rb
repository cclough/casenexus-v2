class FriendshipsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user
    
  def index
    @friends = current_user.friends
  end

  def new
    @users = User.where("id != ?", current_user.id).all
  end

  def create
    @friendship = Friendship.new(params[:friendship])
    @friendship.user_id = current_user.id
    # Check that the user doesn't invite himself
    if @friendship.user_id.to_i == @friendship.friend_id.to_i
      @friendship.errors.add(:base, "cannot invite yourself")
    end
    # Check that there is not any kind of block, or friendship between the users
    if current_user.find_any_friendship_with(@friendship.friend)
      @friendship.errors.add(:base, "cannot invite")
    end

    respond_to do |format|
      if @friendship.save
        format.js
        flash.now[:success] = 'Friend request sent'
      else
        format.js
        flash.now[:notice] = 'Sorry you cannot invite that user'
      end
    end
  end

  def update
    inviter = User.find(params[:id])
    if current_user.approve inviter
      
      #not nice, but model after_update callback won't work as amistad approve method uses update_attribute
      # inviter.notifications.create(user_id: inviter.id,
      #                              sender_id: current_user.id,
      #                              ntype: "friendship_app")

      redirect_to new_friendship_path, notice: "Successfully confirmed friend!"
    else
      redirect_to new_friendship_path, notice: "Sorry! Could not confirm friend!"
    end
  end

  def requests
    @pending_requests = current_user.pending_invited_by
  end
  
  def invites
    @pending_invites = current_user.pending_invited
  end

  def destroy
    user = User.find(params[:id])
    if current_user.remove_friendship user
      redirect_to friendships_path, notice: "Successfully removed friend!"
    else
      redirect_to friendships_path, notice: "Sorry, couldn't remove friend!"
    end
  end 
  
end