class FriendshipsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user
    
  def index
    @friendships = current_user.friendships.includes(:friend)
  end

  def new
    @users = User.where("id != ?", current_user.id).all
  end

  def create
    @friendship = Friendship.new(params[:friendship])
    @friendship.user_id = current_user.id

    # Check that there is not any kind of block, or friendship between the users
    if Friendship.blocked?(@friendship.friend, current_user)
      flash[:error] = "Cannot invite #{friendship.friend}"
    end

    respond_to do |format|
      if flash[:error].nil? && Friendship.request(current_user, @friendship.friend, @friendship.invitation_message)
        format.js
        flash.now[:success] = 'Contact request sent'
      else
        format.js
        flash.now[:notice] = 'Sorry you cannot invite that user'
      end
    end
  end

  def show
    @friendship = current_user.friendships.find(params[:id])
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    Friendship.breakup(@friendship.user, @friendship.friend)
    flash[:success] = "Contact Deleted"
    redirect_to action: :index
  end

  def accept
    @friendship = current_user.friendships.find(params[:id])
    Friendship.accept(@friendship.user, @friendship.friend)
    flash[:success] = "Contact Accepted"
    redirect_to action: :index
  end

  def reject
    @friendship = current_user.friendships.find(params[:id])
    Friendship.reject(@friendship.user, @friendship.friend)
    flash[:success] = "Contact Rejected"
    redirect_to action: :index
  end

  def block
    @friendship = current_user.friendships.find(params[:id])
    Friendship.block(@friendship.user, @friendship.friend)
    flash[:success] = "Contact Rejected"
    redirect_to action: :index
  end

  # List all the friendships requests the user has made
  def requests
    @pending_requests = current_user.pending_friends
  end

  # List all the pending friendships the user can accept, reject or block
  def invites
    @invites = current_user.requested_friendships
  end

  # List all the friends the user has blocked
  def blocked
    @blocked_users = current_user.blocked_friends
  end
end