class UsersController < ApplicationController

	# only signed in users can do these
  before_filter :signed_in_user,
                only: [:index, :edit, :show, :update, :destroy]
  # only current user can do these
  before_filter :correct_user, only: [:edit, :update]

  # Map
	def index


    # Users Sunspot search, according to 'searchable' in User model
    # refactor into model?

    @list = User.approved.search_for(params[:search])
            .paginate(per_page: 7, page: params[:page])

		# load json of map markers, inc. only user id, lat & lng
    respond_to do |format|
      format.html 
      format.js # links index.js.erb!
      format.json { render json: User.markers }
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

      #send welcome email
      UserMailer.welcome_email(@user).deliver

      # sign in the new user
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

  # Show Profile (used without layout on map page only)
  def show
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.html { render :layout => false }
     end  
  end

end
