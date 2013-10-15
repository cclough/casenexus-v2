# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


  

modal_cases_show_prime = () ->

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

  window.cases_resultstable_prime("show")


window.modal_cases_show_show = (case_id) ->

  if !($("#modal_cases").hasClass("in"))

    $("#modal_cases").removeClass "analysis"
    $("#modal_cases").addClass "show"

    $("#modal_cases").html("")
    $(".modal").modal("hide")
    $("#modal_cases").modal "show"

    $.get "/cases/" + case_id, (data) ->
      $("#modal_cases").html data
      modal_cases_show_prime("show")



$(document).ready ->

  # If profile page
  if $("#profile_index_panel_calendar_container").length > 0

    # Scroll calendar to today
    setTimeout (->
      $("#profile_index_panel_calendar_container").animate
        scrollLeft:  $("#profile_index_panel_calendar_container").find(".today").position().left - ($("#profile_index_panel_calendar_container").width() /2)
      , 250
    ), 300


    # Load results table
    $.get "/cases/results?view=analysis", (data) ->
      $("#cases_analysis_results").html data
      if (cases_analysis_chart_case_count == 0)
        $("#cases_analysis_chart_table_empty").fadeIn "fast"
      else
        window.cases_resultstable_prime("analysis")


  # INFO
  $("#profile_index_info_actions_settings").click ->

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



  $(".profile_index_friends_friends_item").click ->

    $(".profile_index_friends_friends_item").removeClass "active"
    $(this).addClass "active"

    friend_id = $(this).data "friend_id"
    $("#profile_index_friends_action_input").val(friend_id)    




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

    case_id = $(this).data "case_id"

    window.modal_cases_show_show(case_id)





