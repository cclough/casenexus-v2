class EventsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :completed_user

  layout 'profile'

  def index
    @events_by_date = Event.all.group_by {|i| i.created_at.to_date}
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = current_user.events.new
    @friends = current_user.accepted_friends
    @books = Book.all
  end

  def create
    @event = current_user.events.new(params[:event])
    if @event.save
      redirect_to @event, notice: "Appointment booked."
    else
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
    @friends = current_user.accepted_friends
    @books = Book.all
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      redirect_to @event, notice: "Appointment updated."
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if @event.destroy
      redirect_to events_path, notice: "Appointment cancelled."
    else
      render :show
    end
  end
    
end
