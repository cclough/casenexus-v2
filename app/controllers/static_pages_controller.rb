class StaticPagesController < ApplicationController

  def home

	 	if signed_in?
			redirect_to users_path
		else
			@user = User.new
		end

  end

  def about
  end

end
