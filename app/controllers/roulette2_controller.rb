class Roulette2Controller < ApplicationController

	def index
	  respond_to do |format|
      format.html { render :layout => false }
    end
	end

end
