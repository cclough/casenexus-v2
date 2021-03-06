console_countdown = (element, minutes, seconds) ->
  
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


console_index_subnav_viewswitch_toggle = ->

  current_view_state = $("#console_index_subnav_form").attr "data-current_view_state"

  if $("#console_index_pdfjs").hasClass "single-left"
    # switch back to split
    $("#console_index_pdfjs").removeClass "single-left"
    $("#console_index_pdfjs_blank").removeClass "single-left"

    $("#console_index_feedback_frame").show "slide", direction: "right", 100

    $("#console_index_subnav_button_viewswitch").html "Full screen <i class=icon-fontawesome-webfont-38></i>"
  
  else
    $("#console_index_pdfjs").addClass "single-left"
    $("#console_index_pdfjs_blank").addClass "single-left"

    $("#console_index_feedback_frame").hide "slide", direction: "right", 100
    $("#console_index_subnav_button_viewswitch").html "Split screen <i class=icon-fontawesome-webfont-41></i>"

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
    console_countdown "console_index_subnav_timer", window.console_timer_set, 0

    $("#console_index_subnav_timer").removeClass "with_cover"
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
    console_countdown "console_index_subnav_timer", current_mins, current_secs

    switch_to("pause")


  ########### GOTO STATE
  switch_to = (state) ->

    # Hide other buttons
    $(".console_index_timer_panel_container").css("display","none")

    # Show new buttons
    $("#console_index_timer_"+state+"_container").css("display","inline")




$(document).ready ->


  # Prime Message button on load
  $("#console_index_subnav_button_message").click ->
    friend_id = $(this).data "friend_id"
    window.modal_message_show(friend_id)

  # Fade on load
  $("#console_index_splash_panel").fadeIn "slow"

  # Splash -> interviewee - DISABLED CURRENTLY
  $("#console_index_splash_panel_button_interviewee").click ->
    # $("#console_index_splash").hide()
    # $("#console_index_interviewee_container").show()

  # Splash -> interviewer
  $("#console_index_splash_panel_button_interviewer").click ->
    $("#console_index_splash").hide()
    $("#console_index_interviewer_container").show()

  # Return from intervewee to splash
  $("#console_index_interviewee_panel_button_return, #console_index_subnav_button_return").click ->
    $("#console_index_splash").show()
    $("#console_index_interviewee_container").hide()
    $("#console_index_interviewer_container").hide()

  # View switch button
  $("#console_index_subnav_button_viewswitch").click ->
    console_index_subnav_viewswitch_toggle()

  # Case select change
  $("#console_index_subnav_select_books").change ->

    book_id = $(this).val()
    if book_id > 0
      book_url = "/console/pdfjs?id=" + book_id

      # $("#console_index_pdfjs_blank").fadeOut "fast"
      $("#console_index_pdfjs_iframe").attr "src", book_url
      $("#console_index_pdfjs_blank").hide()

      console_index_subnav_sendpdf_check()

      $("#cases_new_nobook").css("display","none")
      $.get "/books/" + book_id + "/show_small", (data) ->
        $("#cases_new_book").html data

    else
      $("#cases_new_book").html ""
      $("#console_index_pdfjs_blank").show()
      $("#console_index_pdfjs_iframe").attr "src", ""

      $("#cases_new_nobook").fadeIn "fast"



  # Friend select change
  $("#console_index_subnav_select_friends").change ->

    friend_id = $(this).val()

    if friend_id > 0

    	# change feedback form
      $.get "/cases/new?user_id=" + friend_id, (data) ->
        $("#console_index_feedback_frame").html data

        # Scroll up page - a detail
        $('#console_index_feedback_frame').animate({scrollTop: 0},'slow')

        window.cases_new_prime()

        book_id = $("#console_index_subnav_select_books").val()
        # Check on book selection?

        if book_id
          $("#cases_new_nobook").css("display","none")
          $.get "/books/" + book_id + "/show_small", (data) ->
            $("#cases_new_book").html data

      # change skypebutton
      $.get "/console/skypebutton?friend_id=" + friend_id, (data) ->
        $("#console_index_subnav_button_skype_container").html data
        $("#console_index_subnav_button_skype").tooltip()

      # Pdf button  
      console_index_subnav_sendpdf_check()

      # Message button
      $("#console_index_subnav_button_skype_message").click ->
        friend_id = $(this).data "friend_id"
        window.modal_message_show(friend_id)


    else
      $("#console_index_feedback_frame").html ""


  # Prime the Timer
  if $(".console_index_timer_panel_container").size() > 0
    window.console_index_subnav_timer_prime()
