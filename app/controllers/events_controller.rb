class EventsController < ApplicationController

  before_filter :authenticate_user!, except: [:ics]
  before_filter :completed_user, except: [:ics]
  before_filter :correct_user, :only => [:edit, :update, :destroy]

  require 'icalendar'

  def new
    @event = current_user.events.new
    @books = Book.where(btype: "case").order("author asc")

    @book_partnertoprepare = Book.find(params[:book_id_partnertoprepare]) if params[:book_id_partnertoprepare]
    @friend = User.find(params[:friend_id]) if params[:friend_id]

    render partial: "events/modal_event_new_form", layout: false
  end

  def create
    @event = Event.new(params[:event])
    @event.user = current_user
    
    respond_to do |format|

      if @event.valid? && Event.set(current_user, @event.partner, @event.datetime, @event.book_id_usertoprepare, @event.book_id_partnertoprepare)
        flash[:success] = "Appointment booked with " + @event.partner.username + "."
        format.js

        # Same as index - to update calendar on profile
        @events_by_date = current_user.events.group_by {|i| i.datetime.to_date}
        @date = params[:date] ? Date.parse(params[:date]) : Date.today
      else
        format.js

        # for when it fails
        @books = Book.where(btype: "case").order("author asc")
        @friend = @event.partner unless @event.partner.blank?
        @book_partnertoprepare = Book.find(@event.book_id_partnertoprepare) unless @event.book_id_partnertoprepare.blank?
      end
    end

  end

  def edit
    @event = Event.find(params[:id])
    @books = Book.where(btype: "case").order("author asc")

    @book_usertoprepare = Book.find(@event.book_id_usertoprepare) if @event.book_id_usertoprepare
    @book_partnertoprepare = Book.find(@event.book_id_partnertoprepare) if @event.book_id_partnertoprepare

    render partial: "events/modal_event_edit_form", layout: false
  end

  def update
    @event = current_user.events.find(params[:id])

    respond_to do |format|

      if @event.valid? && Event.change(@event.user, @event.partner, params[:event][:datetime], params[:event][:book_id_usertoprepare], params[:event][:book_id_partnertoprepare])
        flash[:success] = "Appointment amended. " + @event.partner.username + " has been notified."
        format.js

        # Same as index - to update calendar on profile
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
    flash[:success] = "Appointment cancelled. " + @event.partner.username + " has been notified."
    respond_to(:js)
  end

  def user_timezone
    if params[:datetime]
      @datetime = Time.parse(params[:datetime])
    end

    @user = User.find(params[:user_id])
    render partial: "user_timezone", layout: false
  end

  def ics # For subscribe

    user = User.find User.decrypt(params[:id])
    @calendar = Icalendar::Calendar.new
    
    @events = user.events
    @events.each do |event|
      @calendar.event do
        start       event.datetime.strftime("%Y%m%dT%H%M%S")
        summary     "Case Appt: " + event.partner.username
        description "casenexus.com: case appointment with " + event.partner.username
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
    
  private

    def correct_user
      @event = Event.find params[:id]
      redirect_to "/" unless current_user == @event.user
    end
  
end
