class RouletteController < ApplicationController

  before_filter :signed_in_user, only: [:index]
  before_filter :completed_user
  
  def index
    current_user.roulette_token = SecureRandom.urlsafe_base64
  end

  def item
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { render :layout => false } 
    end
  end

end
