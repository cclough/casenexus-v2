class StaticPagesController < ApplicationController

  def home
	 	if signed_in?
			redirect_to dashboard_path
		else
			@user = User.new
    end
  end

  def about
    @user = User.new unless signed_in?
  end

  def terms
    @user = User.new unless signed_in?  
  end

end
