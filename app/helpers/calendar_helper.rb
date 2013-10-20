module CalendarHelper

  def calendar(date = Date.today, current_user, &block)
    Calendar.new(self, date, current_user, block).table
  end

  class Calendar < Struct.new(:view, :date, :current_user, :callback)

    START_DAY = :sunday

    delegate :content_tag, to: :view

    def table
      content_tag :div, class:"calendar" do
        week_rows
      end
    end

    def week_rows
      weeks.map.with_index do |week,index|
        content_tag :div, class: (if index == (weeks.length-1) then "events_calendar_week last_week_of_period out_of_focus" else "events_calendar_week out_of_focus" end), "data-week_number"=> index, "data-events_this_week"=> current_user.events.where(datetime: (week[1].beginning_of_week)..(week[1].end_of_week)).count do
          week.map { |day| day_cell(day) }.join.html_safe
        end
      end.join.html_safe
    end

    def day_cell(day)
      content_tag :div, view.capture(day, &callback), class: day_classes(day), "data-day_num"=> day.day, "data-month"=> day.strftime("%B")
    end

    def day_classes(day)
      classes = ["events_calendar_day"]
      classes << "today" if day == Date.today
      classes << "last_day_of_week" if day.wday == 6
      # classes << "notmonth" if day.month != date.month
      classes.empty? ? nil : classes.join(" ")
    end

    def weeks
      first = (date - 1.month).beginning_of_month.beginning_of_week(START_DAY)
      last = (date + 2.month).end_of_month.end_of_week(START_DAY)
      (first..last).to_a.in_groups_of(7)
    end
  end
end
