class EventsController < ApplicationController

  before_filter :authenticate_user!, :except => [:ics]
  before_filter :completed_user, :except => [:ics]

  layout 'profile'

  require 'icalendar'

  def index
    @events_by_date = current_user.events.group_by {|i| i.datetime.to_date}

    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end



  # DOESNT SEEM TO BLOODY WORK!
  def calendar
    render partial: "calendar", layout: false
  end




  def show
    @event = Event.find(params[:id])
  render layout: false
  end

  def new
    @event = current_user.events.new
    @book_user = Book.find(params[:book_id_user]) if params[:book_id_user]
    @friend = User.find(params[:friend_id]) if params[:friend_id]
    @books = Book.where(btype: "case").order("author asc")

    render partial: "shared/modal_event_new_form", layout: false
  end

  def create
    @event = Event.new(params[:event])
    @event.user = current_user
    
    respond_to do |format|

      if @event.valid? && Event.set(current_user, @event.partner, @event.datetime, @event.book_id_user, @event.book_id_partner)
        format.js
        flash[:success] = "Appointment booked with " + @event.partner.first_name + "."

        # Same as index - to update calendar
        @events_by_date = current_user.events.group_by {|i| i.datetime.to_date}
        @date = params[:date] ? Date.parse(params[:date]) : Date.today
      else
        format.js

        # for when it fails
        @friend = @event.partner unless @event.partner.blank?
        @book_user = Book.find(@event.book_id_partner) unless @event.book_id_partner.blank?
      end

    end

  end

  def edit
    @event = Event.find(params[:id])
    @books = Book.where(btype: "case")

    render partial: "shared/modal_event_edit_form", layout: false
  end

  def update
    @event = current_user.events.find(params[:id])

    respond_to do |format|

      if @event.valid? && Event.change(@event.user, @event.partner, params[:event][:datetime], params[:event][:book_id_user], params[:event][:book_id_partner])
        flash[:success] = "Appointment amended. " + @event.partner.first_name + " has been notified."
        format.js

        # Same as index - to update calendar
        @events_by_date = current_user.events.group_by {|i| i.datetime.to_date}
        @date = params[:date] ? Date.parse(params[:date]) : Date.today
        
      else
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
      redirect_to events_path
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
