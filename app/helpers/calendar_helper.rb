module CalendarHelper

  def calendar(date = Date.today, &block)
    Calendar.new(self, date, block).table
  end

  class Calendar < Struct.new(:view, :date, :callback)
    START_DAY = :sunday

    delegate :content_tag, to: :view

    def table
      content_tag :div, class: "calendar" do
        week_rows
      end
    end


    def week_rows
      weeks.map do |week|
        content_tag :div, class: "events_calendar_week" do
          week.map { |day| day_cell(day) }.join.html_safe
        end
      end.join.html_safe
    end

    def day_cell(day)
      content_tag :div, view.capture(day, &callback), class: day_classes(day)
    end

    def day_classes(day)
      classes = ["events_calendar_day"]
      classes << "today" if day == Date.today
      classes << "notmonth" if day.month != date.month
      classes.empty? ? nil : classes.join(" ")
    end

    def weeks
      first = date.beginning_of_month.beginning_of_week(START_DAY)
      last = date.end_of_month.end_of_week(START_DAY)
      (first..last).to_a.in_groups_of(7)
    end
  end
end
