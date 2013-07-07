window.events_calendar_rebless = ->
  $(".events_calendar_event").click ->
    if !($("#modal_event").hasClass("in"))
      $(".modal").modal("hide")
      event_id = $(this).data("id")
      $.get "/events/" + event_id + "/edit", (data) ->
        $("#modal_event").html data
        window.modal_events_rebless()

      # to increase height of the modal (removed by new show)
      $("#modal_event").addClass "event_edit"

      $("#modal_event").modal("show")

  $("#events_calendar_new_button").click ->
    window.modal_event_new_show(null,null)


$(document).ready ->
  # Modal Stuff!


  $("#modal_event").modal
  	backdrop: false
  	show: false

  window.events_calendar_rebless()



