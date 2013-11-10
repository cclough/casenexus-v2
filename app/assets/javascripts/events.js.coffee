
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

  # Get current
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
  $("#events_calendar_week_date").html string

  # Set number of appts this week
  events_this_week = current_week_div.data "events_this_week"
  $("#events_calendar_week_text_count").html events_this_week + " appointments this week"


window.events_calendar_rebless = ->

  # On load animations
  setTimeout (->
    # Scroll calendar to today
    distance_to_this_week = ($("#profile_index_panel_calendar_container").find(".today").position().top - 47 - 47) + 'px'
    $('#profile_index_panel_calendar_container').animate
      scrollTop: distance_to_this_week
    , 500

    setTimeout (->
      $("#events_calendar_week_text_count").fadeIn "500"
    ), 1000
    
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
    height: '92px'
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

  # Prime next appt
  $("#events_calendar_nextappt").click ->
    event_id = $(this).data "event_id"
    window.events_calendar_edit_modal_show(event_id)


window.modal_event_new_show = (friend_id, book_id) ->

  if !($("#modal_event").hasClass("in"))
    $(".modal").modal("hide")

    if friend_id && !book_id
      url = "/events/new?friend_id=" + friend_id
    else if book_id && !friend_id
      url = "/events/new?book_id_partnertoprepare=" + book_id
    else if friend_id && book_id
      url = "/events/new?friend_id=" + friend_id + "&book_id_partnertoprepare=" + book_id
    else
      url = "/events/new"

    $.get url, (data) ->
      $("#modal_event").html data

      # why is this again?
      if friend_id
        $.get "/events/user_timezone?display_which=timezone&user_id=" + friend_id, (data) ->
          $("#events_modal_friend_timezone").html data

      # to increase height of the modal (removed by new show)
      $("#modal_event").removeClass "event_edit"

      # Bless after modal 'shown' callback fires - prevents bless missing which was a big problem!
      $("#modal_event").on "shown", ->
        window.modal_events_rebless()

      $("#modal_event").modal("show")


window.modal_events_modal_timezone_calcs = ->

  friend_id = $("#events_modal_friend_select").val()
  datetime = $("#events_modal_datetime_input").val()
  
  if friend_id > 0
    $.get "/events/user_timezone?display_which=timezone&user_id=" + friend_id, (data) ->
      $("#events_modal_friend_timezone").html data
  else
    $("#events_modal_friend_timezone").html("")

  if (friend_id > 0) && (datetime != "")
    $.get "/events/user_timezone?display_which=timeforfriend&user_id=" + friend_id + "&datetime=" + datetime, (data) ->
      $("#events_modal_datetime_friend").html data
  else
    $("#events_modal_datetime_friend").html("")


window.modal_events_rebless = ->

  $("#events_modal_datetime_picker").datetimepicker
    format: "dd M yyyy @ hh:iip"
    minuteStep: 15
    pickerPosition: 'bottom-left'
    autoclose: true
    showMeridian: true
    startDate: $("#events_modal_datetime_input").data "start_date"
    #startDate: "2013-07-07 10:00"

  # Tooltips
  $(".application_tooltip").tooltip()

  $("#events_modal_friend_select").change ->
    window.modal_events_modal_timezone_calcs()

  $("#events_modal_datetime_input").change ->
    window.modal_events_modal_timezone_calcs()

  $("#events_modal_book_select").change ->
    book_id = $(this).val()

    if book_id > 0
      $.get "/books/" + book_id + "/show_small", (data) ->
        $("#events_modal_book_viewer_partnertoprepare").html data
    else
      $("#events_modal_book_viewertoprepare").html "<div id=events_modal_book_viewer_empty>No book selected</div>"

  window.application_spinner_prime(".modal.in")



window.events_calendar_edit_modal_show = (event_id) ->
  if !($("#modal_event").hasClass("in"))
    $(".modal").modal("hide")
    
    $.get "/events/" + event_id + "/edit", (data) ->
      $("#modal_event").html data

      # to increase height of the modal (removed by new show)
      $("#modal_event").addClass "event_edit"

      # Bless after modal 'shown' callback fires - prevents bless missing which was a big problem!
      $("#modal_event").on "shown", ->
        window.modal_events_rebless()

      $("#modal_event").modal("show")

$(document).ready ->

  if $("#profile_index_panel_calendar_container").length > 0
    window.events_calendar_rebless()



