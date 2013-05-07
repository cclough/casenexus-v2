class EventsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :completed_user

  layout 'profile'

  def index
    @events_by_date = Event.all.group_by {|i| i.datetime.to_date}
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
    @event = Event.new(params[:event])
    #if @event.save
    if Event.set(current_user, @event.partner, @event.datetime, @event.book_id_user, @event.book_id_partner)
      flash[:success] = "Appointment booked."
      redirect_to @event
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
      flash[:success] = "Appointment updated."
      redirect_to @event
    else
      render :edit
    end
  end

  def update
    @event = current_user.events.find(params[:id])
    if Event.change(@event.user, @event.partner, params[:event][:datetime], params[:event][:book_id_user], params[:event][:book_id_partner])
      flash[:success] = "Appointment updated. " + @event.partner.first_name + " has been notified."
      redirect_to @event
    else
      redirect_to events_path
    end
  end

  def destroy
    @event = current_user.events.find(params[:id])
    Event.cancel(@event.user, @event.partner)
    flash[:success] = "Appointment cancelled. " + @event.partner.first_name + " has been notified."
    if params[:back_url]
      redirect_to params[:back_url]
    else
      redirect_to events_path
    end
  end
    
end
