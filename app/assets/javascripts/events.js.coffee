window.events_new_timezone_calcs = ->
  if $("#events_new_friend_select").val()
    $.get "/events/user_timezone?user_id=" + $("#events_new_friend_select").val(), (data) ->
      $("#events_new_friend_timezone").html data
  else
    $("#events_new_friend_timezone").html("")

  if $("#events_new_friend_select").val() && $("#events_new_datetime_input").val()
    $.get "/events/user_timezone?user_id=" + $("#events_new_friend_select").val()+"&datetime="+$("#events_new_datetime_input").val(), (data) ->
      $("#events_new_datetime_friend").html data
  else
    $("#events_new_datetime_friend").html("")


window.events_modal_rebless = ->
  $("#events_new_datetime_picker").datetimepicker
    format: "dd MM yyyy - hh:ii"
    minuteStep: 15
    pickerPosition: 'bottom-left'

  # $(".chzn-select").chosen()

  $("#events_new_friend_select").change ->
    window.events_new_timezone_calcs()

  $("#events_new_datetime_input").change ->
    window.events_new_timezone_calcs()

  $(".events_new_time_hour_button").click ->
    $(".events_new_input_hour_button").removeClass "active"
    $(this).addClass "active"

  $(".events_new_time_minute_button").click ->
    $(".events_new_input_minute_button").removeClass "active"
    $(this).addClass "active"

  $(".events_new_time_ampm_button").click ->
    $(".events_new_input_ampm_button").removeClass "active"
    $(this).addClass "active"

$(document).ready ->
  # Modal Stuff!


  $("#modal_event").modal
  	backdrop: false
  	show: false


  $("#events_calendar_new_button").click ->
    if !($("#modal_event").hasClass("in"))
      $(".modal").modal("hide")
      $.get "/events/new", (data) ->
        $("#modal_event").html data
        window.events_modal_rebless()
      $("#modal_event").modal("show")

  # $(".events_calendar_event").click ->
  #   if !($("#modal_event").hasClass("in"))
  #     $(".modal").modal("hide")
  #     event_id = $(this).data("id")
  #     $.get "/events/" + event_id + "/edit", (data) ->
  #       $("#modal_event").html data
  #       window.events_modal_rebless()
  #     $("#modal_event").modal("show")

  $(".events_index_events_item").click ->
    if !($("#modal_event").hasClass("in"))
      $(".modal").modal("hide")
      event_id = $(this).data("id")
      $.get "/events/" + event_id + "/edit", (data) ->
        $("#modal_event").html data
        window.events_modal_rebless()
      $("#modal_event").modal("show")