class HeadsupsController < ApplicationController

  def create
    @headsup = Headsup.new(params[:headsup])

    if @headsup.save
      flash[:notice] = "Thank you, we'll be in touch soon."
    else
      # Not neccessary as errors handled in the form
      # flash[:error] = "Oops! There was an error"
    end
  end

end
