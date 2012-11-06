class RouletteController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  def index
    # Check the user has a valid skype
    if current_user.skype.blank?
      flash[:notice] = "You need to provide a valid Skype user in order to use the Roulette feature"
      redirect_to edit_account_path and return
    end

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