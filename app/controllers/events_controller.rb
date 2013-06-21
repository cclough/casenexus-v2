class EventsController < ApplicationController

  before_filter :authenticate_user!, :except => [:ics]
  before_filter :completed_user, :except => [:ics]

  layout 'profile'

  require 'icalendar'

  def index
    # Identical to events/index
    @events_by_date = current_user.events.group_by {|i| i.datetime.to_date}

    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

  def show
    @event = Event.find(params[:id])
    render layout: false
  end

  def new
    @event = current_user.events.new
    @book_user = Book.find(params[:book_id_user])
    render layout: false
  end

  def create
    @event = Event.new(params[:event])

    respond_to do |format|

      if Event.set(current_user, @event.partner, @event.datetime, @event.book_id_user, @event.book_id_partner)
        format.js
        flash[:success] = "Appointment booked."
        #   redirect_to summary_path
      else
        @event.errors.add(:base, "You have filled in the form incorrectly")
        format.js
      end

    end

  end

  def edit
    @event = Event.find(params[:id])
    render layout: false
  end

  def update
    @event = current_user.events.find(params[:id])

    respond_to do |format|

      if Event.change(@event.user, @event.partner, params[:event][:datetime], params[:event][:book_id_user], params[:event][:book_id_partner])
        flash[:success] = "Appointment updated. " + @event.partner.first_name + " has been notified."
        format.js
      else
        @event.errors.add(:base, "You have filled in the form incorrectly")
        format.js
      end

    end
  end

  def destroy
    @event = current_user.events.find(params[:id])
    Event.cancel(@event.user, @event.partner)
    flash[:success] = "Appointment cancelled. " + @event.partner.first_name + " has been notified."
    if params[:back_url]
      redirect_to params[:back_url]
    else
      redirect_to summary_path
    end
  end

  def user_timezone

    if params[:datetime]
      @datetime = Time.parse(params[:datetime])
    end

    @user = User.find(params[:user_id])

    render partial: "user_timezone", layout: false
  end

  # For subscribe
  def ics

    @calendar = Icalendar::Calendar.new
    
    @events = current_user.events
    @events.each do |event|
      @calendar.event do
        start       event.datetime.strftime("%Y%m%dT%H%M%S")
        summary     "Case Appt: " + event.partner.name
        description "casenexus.com: case appointment with " + event.partner.name
        location    "Skype or in person"
        alarm do
          action    "DISPLAY" # This line isn't necessary, it's the default
          summary   "Alarm notification"
          trigger   "-PT3M" # 15 minutes before
        end
      end
    end

    @calendar.publish
    headers['Content-Type'] = "text/calendar; charset=UTF-8"
    render :text => @calendar.to_ical

  end
    
end
