class RouletteController < ApplicationController
  before_filter :authenticate_user!
  before_filter :completed_user

  def index
    # current_user.update_attribute(:roulette_token, ('a'..'z').to_a.shuffle[0,8].join)
  end

  def item
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
