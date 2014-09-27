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
      flash[:success] = 'Thank you'
      redirect_to new_arrival_path
    else
      render 'new'
    end
  end
end
