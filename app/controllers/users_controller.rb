class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:index, :edit, :show, :update]
  before_filter :correct_user, only: [:edit, :update]

  # Map
	def index

    # Set scope of users list depending on params from filter menu
    case params[:users_listtype]
    when "global"
      users_scope = User.list_global
    when "local"
      users_scope = User.list_local(current_user)
    when "rand"
      users_scope = User.list_rand
    when "friendships"
      users_scope = User.list_contacts(current_user)
    end

    # Using scoped_search gem
    if users_scope
      @users = users_scope.search_for(params[:search])
               .paginate(per_page: 10, page: params[:page])
    end

		# load json of map markers, inc. only user id, lat & lng
    respond_to do |format|
      format.html 
      format.js # links index.js.erb!
      format.json { render json: User.markers } # map marker feed
    end

	end


  # Show Profile (used without layout on map page only)
  def show
    @user = User.find(params[:id])

      if @user.approved?
        respond_to do |format|
          @notification = @user.notifications.build
          @friendship = @user.friendships.build unless current_user.friend_with?(@user)

          format.html { render :layout => false } 
        end
      else
        render 'index'
      end
  end

  
  # Signup
  def new
    @user = User.new
  end

  # Create User
  def create
    @user = User.new(params[:user])
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to casenexus.com"
  		redirect_to users_path
  	else
  		render 'new'
  	end
  end

  # Edit Profile
	def edit
	end

  # Update Profile
  def update
    if @user.update_attributes(params[:user])
      sign_in @user
      flash[:success] = '<strong>Success</strong> - Profile updated'.html_safe
      redirect_to users_path
    else
      render 'edit'
    end
  end


  # CUSTOM

  def tooltip
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { render :layout => false } 
    end
  end

  # AJAX

  def get_latlng
    respond_to do |format|
      format.json { render json: { lat: current_user.lat, lng: current_user.lng } }
    end
  end


  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

end
