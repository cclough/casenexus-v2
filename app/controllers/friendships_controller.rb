class FriendshipsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  def modal_friendship_req_form
    @user = User.find(params[:id])
    @friendship = Friendship.new

    render partial: "friendships/modal_friendship_req_form", layout:false
  end

  def create
    @friendship = Friendship.new(params[:friendship])
    @friendship.user_id = current_user.id

    # Check that there is not any kind of block, or existing friendship between the users
    if Friendship.blocked?(@friendship.friend, current_user)
      flash[:error] = "Unable to partner with #{friendship.friend}."
    end

    respond_to do |format|
      if @friendship.valid? && Friendship.request(current_user, @friendship.friend, @friendship.invitation_message)
        flash.now[:success] = 'Partner request sent to ' + @friendship.friend.username + '.'
        format.js
      else
        format.js
        @user = @friendship.friend
      end
    end
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    Friendship.breakup(@friendship.user, @friendship.friend)
    flash[:success] = @friendship.friend.username + " is no longer a partner."
    if params[:back_url]
      redirect_to params[:back_url]
    else
      redirect_to notifications_path
    end
  end

  def accept
    @friendship = current_user.friendships.find(params[:id])
    Friendship.accept(@friendship.user, @friendship.friend)
    flash[:success] = @friendship.friend.username + " is now a partner!"
    if params[:back_url]
      redirect_to params[:back_url]
    else
      redirect_to notifications_path
    end
  end

  def reject
    @friendship = current_user.friendships.find(params[:id])

    # Instead of marking the Friendship as rejected, we break it so the user may invite the friend again later
    #Friendship.reject(@friendship.user, @friendship.friend)
    Friendship.breakup(@friendship.user, @friendship.friend)

    flash[:success] = "Partner request from #{@friendship.friend.username} rejected."

    if params[:back_url]
      redirect_to params[:back_url]
    else
      redirect_to notifications_path
    end
  end

  def block
    @friendship = current_user.friendships.find(params[:id])
    Friendship.block(@friendship.user, @friendship.friend)
    flash[:success] = "Partner blocked."
    if params[:back_url]
      redirect_to params[:back_url]
    else
      redirect_to notifications_path
    end
  end

  def unblock
    @friendship = current_user.friendships.find(params[:id])
    Friendship.unblock(@friendship.user, @friendship.friend)
    flash[:success] = "Partner unblocked."
    if params[:back_url]
      redirect_to params[:back_url]
    else
      redirect_to notifications_path
    end
  end

  # List all the friendships requests the user has made
  def requests
    @friendships = current_user.pending_friendships.includes(:friend)
  end

  # List all the pending friendships the user can accept, reject or block
  def invites
    @friendships = current_user.requested_friendships.includes(:friend)
  end

  # List all the friends the user has blocked
  def blocked
    @friendships = current_user.blocked_friendships.includes(:friend)
  end
end