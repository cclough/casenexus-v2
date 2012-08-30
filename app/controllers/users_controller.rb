class UsersController < ApplicationController

	# only signed in users can do these
  before_filter :signed_in_user,
                only: [:index, :edit, :update, :destroy]
  # only current user can do these
  before_filter :correct_user, only: [:edit, :update]

  #map page
	def index

		# load json of map markers, inc. only user id, lat & lng
    respond_to do |format|
      format.html 
      format.json { render json: User.markers }
    end

	end

  # new user
  def new
    @user = User.new
  end

  # create user in model
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


	def edit
	end

  def update
  end

end
