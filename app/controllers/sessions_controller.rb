class SessionsController < ApplicationController

	def new
  end

	def destroy
		sign_out
		redirect_to root_path
	end

  def create

    # raise auth.to_yaml

    if !auth

			user = User.find_by_email(params[:session][:email])
			if user && user.authenticate(params[:session][:password])
				sign_in user
				redirect_back_or '/users'
			else
				flash.now[:error] = "Invalid email/password combination"
				render 'new'
			end

    else

	    user = User.find_by_email(auth["info"]["email"]) || User.create_with_omniauth(auth)
	    sign_in user

	    if completed?
				redirect_back_or '/users'
		  else
	    	redirect_to new_user_path
	    end

	  end
    
  end


  protected

  def auth
    request.env['omniauth.auth']
  end

end
