
events_ordinal = (date) ->
  if date > 20 or date < 10
    switch date % 10
      when 1
        return "st"
      when 2
        return "nd"
      when 3
        return "rd"
  "th"
  

events_set_week_date = () ->

  current_week_div = $(".calendar").find(".events_calendar_week:nth-child("+window.events_current_week_number+")")

  $(".calendar").find(".events_calendar_week").addClass "out_of_focus"
  current_week_div.removeClass "out_of_focus"

  current_week_first_day_num = current_week_div.find(".events_calendar_day:nth-child(1)").data "day_num"
  current_week_last_day_num = current_week_div.find(".events_calendar_day:nth-child(7)").data "day_num"
  current_week_month = current_week_div.find(".events_calendar_day:nth-child(1)").data "month"
  
  # Set dates
  current_week_first_day_num_with_ord = current_week_first_day_num + events_ordinal(current_week_first_day_num)
  current_week_last_day_num_with_ord = current_week_last_day_num + events_ordinal(current_week_last_day_num)
  string = current_week_month + ", week " + current_week_first_day_num_with_ord + " - " + current_week_last_day_num_with_ord
  $("#events_calendar_month_date").html string

  # Set number of appts this week
  events_this_week = current_week_div.data "events_this_week"
  $("#events_calendar_month_text_count").html events_this_week + " appointments"


window.events_calendar_rebless = ->

  # On load animations
  setTimeout (->
    # Scroll calendar to today
    distance_to_this_week = ($("#profile_index_panel_calendar_container").find(".today").position().top - 47 - 47) + 'px'
    $('#profile_index_panel_calendar_container').animate
      scrollTop: distance_to_this_week
    , 500
  ), 500

  # Set current week variable
  today_div = $("#profile_index_panel_calendar_container .today")
  current_week_div = today_div.parent()
  current_week_num = current_week_div.data "week_number"
  window.events_current_week_number = current_week_num + 1
  events_set_week_date()
    
  # Event click
  $(".events_calendar_day_event").click ->
    event_id = $(this).data("id")
    window.events_calendar_edit_modal_show(event_id)

  $(".application_tooltip").tooltip()
  
  # New event button
  $("#profile_index_calendar_actions_new").click ->
    window.modal_event_new_show(null,null)

  # Prime scroll within days
  $(".more_than_two_events").slimscroll({
    height: '55px'
    width: 'auto'
  });

  # Prime calendar shift buttons
  $(".profile_index_panel_calendar_shift_button").click ->
    direction = $(this).data "direction"

    if direction == "up"
      unless window.events_current_week_number == 1
        scroll_by = "+=-96px"
        window.events_current_week_number -= 1
        $('#profile_index_panel_calendar_container').animate
          scrollTop: scroll_by
        , 150
    else
      unless window.events_current_week_number == $("#profile_index_panel_calendar_container .events_calendar_week").length
        scroll_by = "+=96px"
        window.events_current_week_number += 1
        $('#profile_index_panel_calendar_container').animate
          scrollTop: scroll_by
        , 150

    events_set_week_date()


window.events_calendar_edit_modal_show = (event_id) ->
  if !($("#modal_event").hasClass("in"))
    $(".modal").modal("hide")
    
    $.get "/events/" + event_id + "/edit", (data) ->
      $("#modal_event").html data
      window.modal_events_rebless()

    # to increase height of the modal (removed by new show)
    $("#modal_event").addClass "event_edit"

    $("#modal_event").modal("show")

$(document).ready ->

  # Params show event trigger used e.g. by event emails
  # if typeof events_index_choosecase_event_id is "string"
  #   window.events_calendar_edit_modal_show(events_index_choosecase_event_id)

  if $("#profile_index_panel_calendar_container").length > 0
    window.events_calendar_rebless()



