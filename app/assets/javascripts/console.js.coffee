window.console_index_subnav_sendpdf_check = ->
  if ($("#console_index_subnav_select_books").val() != "") && ($("#console_index_subnav_select_friends").val() != "")
    $("#console_index_subnav_button_sendpdf").css("display", "inline")
  else
    $("#console_index_subnav_button_sendpdf").css("display", "none")



countdown = (element, minutes, seconds) ->
  
  # set time for the particular countdown
  time = minutes * 60 + seconds
  interval = setInterval(->
    el = document.getElementById(element)
    
    # if the time is 0 then end the counter
    if time is 0
      el.innerHTML = "countdown's over!"
      clearInterval interval
      return
    minutes = Math.floor(time / 60)
    minutes = "0" + minutes  if minutes < 10
    seconds = time % 60
    seconds = "0" + seconds  if seconds < 10
    text = minutes + ":" + seconds
    el.innerHTML = text
    time--
  , 1000)




$(document).ready ->

	query = getQueryParams(document.location.search)

	if query.id != ""
		$.get "/cases/new?user_id=" + query.friend_id, (data) ->

			$("#console_index_feedback_frame").html data


  $(".chzn-select").chosen()

  $("#console_index_subnav_select_books").change ->

    book = "/console/pdfjs?id=" + $(this).val()

    $("#console_index_pdfjs_iframe").attr "src", book

    console_index_subnav_sendpdf_check()

  $("#console_index_subnav_select_friends").change ->

  	# change feedback form
    $.get "/cases/new?user_id=" + $(this).val(), (data) ->

    	$("#console_index_feedback_frame").html data

    # change skypebutton
    $.get "/console/skypebutton?friend_id=" + $(this).val(), (data) ->

    	$("#console_index_subnav_button_skype_container").html data

    console_index_subnav_sendpdf_check()





  # TIMER STUFF
  $("#console_index_subnav_button_timer_start").click ->
    countdown "console_index_subnav_timer", window.console_timer_set, 0

    


  $(".console_index_subnav_button_timer_set").click ->

    new_time = $(this).data("set")
    window.console_timer_set = new_time

    $("#console_index_subnav_timer").html new_time + ":00"

    $(".console_index_subnav_button_timer_set").removeClass("active")
    $(this).addClass("active")
