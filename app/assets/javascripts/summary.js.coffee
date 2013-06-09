window.summary_index_events_modal_rebless = ->
  $("#events_new_datetime_picker").datetimepicker
    format: "dd MM yyyy - hh:ii"

  # $(".chzn-select").chosen()

  $("#events_new_friend_select").change ->
    $.get "/events/user_timezone?user_id=" + $(this).val(), (data) ->
      $("#events_new_friend_timezone").html data


  $("#events_new_datetime_input").change ->

    $.get "/events/user_timezone?user_id=" + $("#events_new_friend_select").val()+"&datetime="+$(this).val(), (data) ->
      $("#events_new_datetime_friend").html data


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
        window.summary_index_events_modal_rebless()
      $("#modal_event").modal("show")


  $(".events_calendar_event").click ->
    if !($("#modal_event").hasClass("in"))
      $(".modal").modal("hide")
      event_id = $(this).data("id")
      $.get "/events/" + event_id + "/edit", (data) ->
        $("#modal_event").html data
        window.summary_index_events_modal_rebless()
      $("#modal_event").modal("show")

  $(".summary_item_events").click ->
    if !($("#modal_event").hasClass("in"))
      $(".modal").modal("hide")
      event_id = $(this).data("id")
      $.get "/events/" + event_id + "/edit", (data) ->
        $("#modal_event").html data
        window.summary_index_events_modal_rebless()
      $("#modal_event").modal("show")