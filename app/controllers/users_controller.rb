class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:index, :new, :edit, :show, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :completed_user, except: [:new, :create, :update]

  def test
  end

  # Map
	def index

    # Set scope of users list depending on params from filter menu
    case params[:users_listtype]
    when "global"
      users_scope = User.list_global
    when "local"
      users_scope = User.list_local(current_user.lat, current_user.lng)
    when "rand"
      users_scope = User.list_rand
    when "friendships"
      users_scope = User.list_contacts
    end

    # Using scoped_search gem
    if users_scope
      @users = users_scope.search_for(params[:search])
               .paginate(per_page: 10, page: params[:page])
    end

    respond_to do |format|
      format.html 
      format.js # links index.js.erb!
      format.json { render json: User.markers } # USING get_markers_within_viewport INSTEAD
    end

	end


  # used without layout on map page only
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      @notification = @user.notifications.build
      @friendship = @user.friendships.build unless current_user.friend_with?(@user)

      format.html { render :layout => false } 
    end

  end

  
  # Signup Part 2!
  def new
    if completed?
      redirect_to users_path
    else
      @user = current_user
    end
  end

  def create
    @user = User.new(params[:user])
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to casenexus.com"
  		redirect_to users_path
  	else
  		render "/static_pages/home"
  	end
  end


	def edit
	end


  def update
    if @user.update_attributes(params[:user])

      sign_in @user

      if !completed?
        @user.toggle!(:completed)
        flash[:success] = 'Welcome to casenexus.com'.html_safe
      else
        flash[:success] = 'Success - Profile updated'.html_safe
      end
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
  
  # def get_markers_within_viewport

  #   bounds = params[:bounds].split(",")

  #   @sw = GeoKit::LatLng.new(bounds[0],bounds[1])
  #   @ne = GeoKit::LatLng.new(bounds[2],bounds[3])

  #   respond_to do |format|
  #     format.json { render json: User.in_bounds([@sw, @ne]) }
  #   end

  # end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

end
