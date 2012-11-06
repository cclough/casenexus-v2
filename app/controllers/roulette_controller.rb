class RouletteController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  def index
    # Generate a new token for the user and save
    current_user.generate_roulette_token
    current_user.save
  end

  def get_item
    @roulette_user = User.find(params[:id])
    respond_to do |format|
      format.html { render layout: false }
    end
  end

  def get_request
    @request_user = User.find(params[:id])
    @message = params[:msg]
    respond_to do |format|
      format.html { render layout: false }
    end
  end
end