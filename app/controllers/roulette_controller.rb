class RouletteController < ApplicationController

  before_filter :signed_in_user, only: [:index]

  def index
  end

  def item
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { render :layout => false } 
    end
  end

end
