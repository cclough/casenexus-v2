window.events_new_timezone_calcs = ->

  friend_id = $("#events_new_friend_select").val()
  datetime = $("#events_new_datetime_input").val()
  
  if friend_id
    $.get "/events/user_timezone?user_id=" + friend_id, (data) ->
      $("#events_new_friend_timezone").html data
  else
    $("#events_new_friend_timezone").html("")

  if friend_id && datetime
    $.get "/events/user_timezone?user_id=" + friend_id+"&datetime="+datetime, (data) ->
      $("#events_new_datetime_friend").html data
  else
    $("#events_new_datetime_friend").html("")


window.events_modal_rebless = ->
  $("#events_new_datetime_picker").datetimepicker
    format: "dd MM yyyy - hh:ii"
    minuteStep: 15
    pickerPosition: 'bottom-left'    
    showMeridian: true

  $("#events_new_friend_select").change ->
    window.events_new_timezone_calcs()

  $("#events_new_datetime_input").change ->
    window.events_new_timezone_calcs()

  window.modal_spinner_prime()

window.events_calendar_rebless = ->
  $(".events_calendar_event").click ->
    if !($("#modal_event").hasClass("in"))
      $(".modal").modal("hide")
      event_id = $(this).data("id")
      $.get "/events/" + event_id + "/edit", (data) ->
        $("#modal_event").html data
        window.events_modal_rebless()
      $("#modal_event").modal("show")

  $("#events_calendar_new_button").click ->
    if !($("#modal_event").hasClass("in"))
      $(".modal").modal("hide")
      $.get "/events/new", (data) ->
        $("#modal_event").html data
        window.events_modal_rebless()
      $("#modal_event").modal("show")

$(document).ready ->
  # Modal Stuff!


  $("#modal_event").modal
  	backdrop: false
  	show: false

  window.events_calendar_rebless()



