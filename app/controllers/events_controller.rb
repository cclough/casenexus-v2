class EventsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :completed_user

  layout 'profile'

  def index
    @events = Event.all
    @events_by_date = @events.group_by(&:datetime)
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
      redirect_to @event, notice: "Created event."
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
      redirect_to @event, notice: "Updated event."
    else
      render :edit
    end
  end
end
