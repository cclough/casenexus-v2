class StaticPagesController < ApplicationController

  def home
	 	if signed_in?
			redirect_to dashboard_path
		else
			@user = User.new
    end
  end

  def about
  end

  def terms
  end

end
