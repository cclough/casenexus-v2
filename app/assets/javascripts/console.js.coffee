window.console_index_subnav_sendpdf_check = ->

  book_id = $("#console_index_subnav_select_books").val()
  friend_id = $("#console_index_subnav_select_friends").val()

  if (book_id != "") && (friend_id != "")

    # Get Email charts button
    $.get "/console/sendpdfbutton?friend_id=" + friend_id + "&book_id=" + book_id, (data) ->
      $("#console_index_subnav_button_sendpdf_container").html data

      # Prime button
      $("#console_index_subnav_button_sendpdf").click ->
        $(this).html "Sending..."
        $(this).addClass "active disabled"
        
        # Submit form
        $.get("/console/sendpdf", $("#console_index_subnav_form").serialize(), null, "script")
        false
        

window.console_index_subnav_timer_prime = ->

  # Prime Set Buttons
  $(".console_index_subnav_button_timer_set").click ->
    
    # Get and place new time
    new_time = $(this).data("set")
    window.console_timer_set = new_time
    $("#console_index_subnav_timer").html new_time + ":00"

    # Now start the timer
    countdown "console_index_subnav_timer", window.console_timer_set, 0

    switch_to("pause")

  # Prime Pause Button
  $("#console_index_subnav_button_timer_pause").click ->
    clearInterval window.interval

    switch_to("restartreset")

  # Prime Reset Button
  $("#console_index_subnav_button_timer_reset").click ->
    clearInterval window.interval
    $("#console_index_subnav_timer").html "00:00"

    switch_to("timeset")

  # Prime Restart Button
  $("#console_index_subnav_button_timer_restart").click ->

    # Get current time and start timer again with it
    current_time = $("#console_index_subnav_timer").html()
    current_mins = current_time.split(":").shift()
    current_secs = parseInt(current_time.substr(-2))
    countdown "console_index_subnav_timer", current_mins, current_secs

    switch_to("pause")


  ########### GOTO STATE

  switch_to = (state) ->

    # Hide other buttons
    $(".console_index_timer_panel_container").css("display","none")

    # Show new buttons
    $("#console_index_timer_"+state+"_container").css("display","inline")

    # window.console_index_subnav_timer_prime()







countdown = (element, minutes, seconds) ->
  
  # set time for the particular countdown
  time = minutes * 60 + seconds
  window.interval = setInterval(->
    el = document.getElementById(element)
    
    # if the time is 0 then end the counter
    if time is 0
      clearInterval window.interval
      alert "Case Closed!"
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



	# query = getQueryParams(document.location.search)

	# if query.id != ""
 #    book = "/console/pdfjs?id=" + query.id
 #    $("#console_index_pdfjs_iframe").attr "src", book

 #    console_index_subnav_sendpdf_check()


  $("#console_index_subnav_select_books").change ->

    if $(this).val()
      book = "/console/pdfjs?id=" + $(this).val()
      $("#console_index_pdfjs_iframe").attr "src", book

      console_index_subnav_sendpdf_check()


  $("#console_index_subnav_select_friends").change ->

    if $(this).val()
    	# change feedback form
      form_for_friend = "/cases/new?user_id=" + $(this).val()
      $("#console_index_feedback_iframe").attr "src", form_for_friend



      # change skypebutton
      $.get ("/console/skypebutton?friend_id=" + $(this).val()), (data) ->
      	$("#console_index_subnav_button_skype_container").html data

      $("#console_index_subnav_button_skype").tooltip()
      console_index_subnav_sendpdf_check()



  # Prime the Timer
  window.console_index_subnav_timer_prime()
