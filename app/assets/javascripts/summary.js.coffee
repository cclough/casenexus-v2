window.summary_index_events_modal_rebless = ->
  $("#events_datepicker").datepicker dateFormat: "dd/mm/yy"
  $(".chzn-select").chosen()



$(document).ready ->
  # Modal Stuff!


  $("#modal_event").modal
  	backdrop: false
  	show: false




  $("#events_calendar_button_new").click ->
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