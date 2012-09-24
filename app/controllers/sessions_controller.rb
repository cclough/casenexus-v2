class SessionsController < ApplicationController
# All from MH Rails Tutorial

require 'omniauth'

	def new
  end

	# def create
	# 	user = User.find_by_email(params[:session][:email])
	# 	if user && user.authenticate(params[:session][:password])
	# 		sign_in user
	# 		redirect_back_or '/users'
	# 	else
	# 		flash.now[:error] = "Invalid email/password combination"
	# 		render 'new'
	# 	end
	# end

	def destroy
		sign_out
		redirect_to root_path
	end

  def create
    # @user = User.find_or_create_from_auth_hash(auth_hash)
    # self.current_user = @user
    # flash[:success] = "You are now signed in"
    # redirect_back_or '/users'
    
    # auth = request.env['omniauth.auth']
    # raise auth.to_yaml

    user = User.find_by_provider_and_email(auth["provider"], auth["info"]["email"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_url, :notice => "Signed in with LinkedIn!"

  end

 #  def destroy
 #  	session[:user_id] = nil
 #  	redirect_to root_url, :notice => "Signed out!"
	# end

  protected

  def auth
    request.env['omniauth.auth']
  end

end
