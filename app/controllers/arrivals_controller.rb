class ArrivalsController < ApplicationController

  layout 'home'
  
  def index
  end

  def new
    @arrival = Arrival.new
  end

  def create
    @arrival = Arrival.new(params[:arrival])

    if @arrival.save
      flash[:success] = 'Thanks for your interest - we will be in touch soon'
      redirect_to arrivals_path
    else
      flash[:error]
      render 'new'
    end
  end
end
