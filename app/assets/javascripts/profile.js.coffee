# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


  

modal_cases_show_prime = () ->

  window.cases_resultstable_prime("show")

  # Browse Buttons
  $(".cases_show_subnav_browse_button").click ->
    next_case_id = $(this).attr "data-case_id"
    $("#modal_cases").html("")

    $.get "/cases/" + next_case_id, (data) ->
      $("#modal_cases").html data
      modal_cases_show_prime()

  # Select Case Pull Down
  $("#cases_show_subnav_select").change ->
    next_case_id = $(this).val()
    $("#modal_cases").html("")

    $.get "/cases/" + next_case_id, (data) ->
      $("#modal_cases").html data
      modal_cases_show_prime()



window.modal_cases_show_show = (case_id) ->

  if !($("#modal_cases").hasClass("in"))

    $("#modal_cases").empty()
    
    $("#modal_cases").removeClass "analysis"
    $("#modal_cases").addClass "show"

    $(".modal").modal("hide")
    $("#modal_cases").modal "show"

    $.get "/cases/" + case_id, (data) ->
      $("#modal_cases").html data
      modal_cases_show_prime()
      
    # $("#modal_cases").on "shown", ->
    #   modal_cases_show_prime()


$(document).ready ->

  # If profile page
  if $("#profile_index_panel_calendar_container").length > 0

    # Load results table
    $.get "/cases/results?view=analysis", (data) ->
      $("#cases_analysis_results").html data
      if (cases_analysis_chart_case_count == 0)
        $("#cases_analysis_chart_table_empty").fadeIn "fast"
      else
        window.cases_resultstable_prime("analysis")



  $('#profile_index_friends_friends').slimscroll({
    height: 'auto'
    width: 'auto'
  });

  # Prime calendar shift buttons
  $(".profile_index_panel_calendar_shift_button").click ->
    direction = $(this).data "direction"

    # profile_index_calendar_scoller.scrollTo(direction, 0, 300,true) 


  # Load Scroller
  # profile_index_calendar_scoller = new iScroll("profile_index_panel_calendar_container",
  #   momentum: true
  # )
  # profile_index_friends_scoller = new iScroll("profile_index_friends_friends",
  #   #snap: 'div',
  #   vScrollbar: true,
  #   momentum: true
  # )

  # , #profile_index_feedback_cases

  # # Scroll calendar to today
  # if $("#profile_index_panel_calendar_container").find(".today")
  #   setTimeout (->
  #     distance_to_today = $("#profile_index_panel_calendar_container").find(".today").position().left - ($("#profile_index_panel_calendar_container").width() /2)
  #     profile_index_calendar_scoller.scrollTo(distance_to_today,0, 500,true)
  #   ), 100



  mouseover = ->
    # $(this).find(".profile_index_friends_friends_item_actions").fadeIn 200

    $(this).find(".profile_index_friends_friends_item_actions").show "slide", direction: "right", 100

    
  mouseout = ->
    # $(this).find(".profile_index_friends_friends_item_actions").fadeOut 200
    $(this).find(".profile_index_friends_friends_item_actions").hide "slide", direction: "right", 100

  # $(".profile_index_friends_friends_item").hover mouseover, mouseout
    

  $(".profile_index_friends_friends_item").hoverIntent
    over: mouseover,
    out: mouseout,
    interval: 250

  setTimeout (->
    # Fade in counts cases
    $(".profile_index_info_cases_counts_container").fadeIn "500"

    # Users Item Cascade Fade
    $(".profile_index_friends_friends_item").each (i) ->
      $(this).delay((i + 1) * 50).fadeIn()

    ), 500
  







  # INFO
  $("#profile_index_info_actions_settings").click ->

    $("#modal_profile").off "shown"
    
    if !($("#modal_profile").hasClass("in"))

      $(".modal").modal("hide")
      $("#modal_profile").html("")
      $("#modal_profile").modal "show"

      # Bless after modal 'shown' callback fires - prevents bless missing which was a big problem!
      $("#modal_profile").on "shown", ->
        $.get "/account/edit", (data) ->
          $("#modal_profile").html data
          window.account_completeedit_bless()


  $("#profile_index_info_actions_invite").click ->

    $("#modal_profile").off "shown"

    if !($("#modal_profile").hasClass("in"))

      $(".modal").modal("hide")
      $("#modal_profile").html("")
      $("#modal_profile").modal "show"

      $.get "/invitations", (data) ->
        $("#modal_profile").html data

  # $("#profile_index_info_actions_visitors").click ->

  #   if !($("#modal_profile").hasClass("in"))

  #     $(".modal").modal("hide")

  #     $.get "/account/visitors", (data) ->
  #       $("#modal_profile").html data

  #       # Bless after modal 'shown' callback fires - prevents bless missing which was a big problem!
  #       # $("#modal_profile").on "shown", ->

  #       #   #window.account_completeedit_bless()

  #       $("#modal_profile").modal "show"



  # FRIENDS
  # $("#profile_index_friends_actions_invite")
  
  # $("#profile_index_friends_actions_skype")
  #   friend_id = $("#profile_index_friends_action_input").val()
  #   window.location.href = "skype:friend's_skype?call" + friend_id

  $("#profile_index_friends_actions_start").click ->
    friend_id = $("#profile_index_friends_action_input").val()

    unless !friend_id
      window.location.href = "/console?friend_id=" + friend_id
    else
      alert "Please select a friend from the list..."


  $("#profile_index_friends_actions_message").click ->
    friend_id = $("#profile_index_friends_action_input").val()

    unless !friend_id
      window.modal_message_show(friend_id)
    else
      alert "Please select a friend from the list..."


  $("#profile_index_friends_actions_profile").click ->
    friend_id = $("#profile_index_friends_action_input").val()
    
    unless !friend_id
      window.location.href = "/map?user_id=" + friend_id
    else
      alert "Please select a friend from the list..."


  $("#profile_index_friends_actions_event").click ->
    friend_id = $("#profile_index_friends_action_input").val()
    
    unless !friend_id
      window.modal_event_new_show(friend_id,null)
    else
      alert "Please select a friend from the list..."



  # FEEDBACK

  $(".profile_index_feedback_cases_item").click ->

    # if item unread
    unread_flag = $(this).find(".profile_index_feedback_cases_item_read_highlight")
    if unread_flag.hasClass "unread"
      # Fade out unread marker
      unread_flag.fadeOut "fast"
      # Update unread count
      current_count = $("#profile_index_feedback").find(".iconbar-unread").html()
      $("#profile_index_feedback").find(".iconbar-unread").html(Number(current_count) - 1)

    case_id = $(this).attr "data-case_id"

    window.modal_cases_show_show(case_id)





