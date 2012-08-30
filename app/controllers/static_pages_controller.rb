class StaticPagesController < ApplicationController

  def home
  	# Home re-directs to user path here if signed in
	 	if signed_in?
			redirect_to users_path
		end
  end

  def about
  end

end
