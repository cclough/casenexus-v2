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

    # Check that there is not any kind of block, or friendship between the users
    if Friendship.blocked?(@friendship.friend, current_user)
      flash[:error] = "Cannot invite #{friendship.friend}"
    end

    respond_to do |format|
      if flash[:error].nil? && @friendship.save
        format.js
        flash.now[:success] = 'Friend request sent'
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

  def requests
    @pending_requests = current_user.pending_friends
  end
  
  def invites
    @pending_invites = current_user.requested_friends
  end

  def blocked
    @blocked_users = current_user.blocked_friends
  end
end