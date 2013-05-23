# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  # Modal Stuff!
  $("#modal_event").modal
  	backdrop: false
  	show: false

  $("#events_calendar_button_new").click ->
  	# if !($("#modal_event").hasClass("in"))
    	#$(".modal").modal("hide")
    $("#modal_event").modal("show")

  $("#events_datepicker").datepicker dateFormat: "dd/mm/yy"

  $(".chzn-select").chosen()