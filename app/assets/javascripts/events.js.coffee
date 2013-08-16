window.events_calendar_rebless = ->
  $(".events_calendar_event, #events_calendar_reminder").click ->
    event_id = $(this).data("id")
    window.events_calendar_edit_modal_show(event_id)

  $("#events_calendar_new_button").click ->
    window.modal_event_new_show(null,null)

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
  if typeof events_index_choosecase_event_id is "string"
    window.events_calendar_edit_modal_show(events_index_choosecase_event_id)

  $("#modal_event").modal
  	backdrop: false
  	show: false

  window.events_calendar_rebless()



