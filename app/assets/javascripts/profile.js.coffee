# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

modal_cases_analysis_prime = () ->
    # Order and Period buttons
  $("#cases_analysis_section_table .btn").click ->

    radio = $(this).data("radio")
    type = $(this).data("type")

    # Change radio
    $("input[name=resultstable_"+type+"]:eq(" + radio + ")").prop "checked", true
    
    # Remove and add active class to buttons
    $("#cases_resultstable_"+type+"_container .btn").removeClass "active"
    $(this).addClass "active"
    
    # Submit form
    $.get("/cases/analysis", $("#cases_resultstable_form").serialize(), null, "script")
    false


  # BAR BUTTONS
  $("#cases_analysis_chart_bar_button_all").click ->
    $("#cases_analysis_chart_bar").empty()
    cases_analysis_chart_bar_draw "all", cases_analysis_chart_case_count
    $("#cases_analysis_chart_bar_button_all").addClass "active"
    $("#cases_analysis_chart_bar_button_combined").removeClass "active"

  $("#cases_analysis_chart_bar_button_combined").click ->
    $("#cases_analysis_chart_bar").empty()
    cases_analysis_chart_bar_draw "combined", cases_analysis_chart_case_count
    $("#cases_analysis_chart_bar_button_all").removeClass "active"
    $("#cases_analysis_chart_bar_button_combined").addClass "active"

  window.cases_resultstable_bars_draw()

modal_cases_show_prime = () ->
  window.cases_resultstable_bars_draw()
  
  window.cases_show_category_chart_bar_draw("businessanalytics")
  window.cases_show_category_chart_bar_draw("structure")
  window.cases_show_category_chart_bar_draw("interpersonal")

  $(".cases_show_subnav_browse_button").click ->
    case_id = $(this).data "case_id"

    next_case_id = parseInt(case_id) + 1
    $("#modal_cases").html("")

    $.get "/cases/" + next_case_id, (data) ->
      $("#modal_cases").html data
      modal_cases_show_prime()



$(document).ready ->


  # INFO
  $("#profile_index_info_actions_settings").click ->

    if !($("#modal_profile").hasClass("in"))

      $(".modal").modal("hide")
      $("#modal_profile").html("")
      $("#modal_profile").modal "show"

      $.get "/account/edit", (data) ->
        $("#modal_profile").html data

        # Bless after modal 'shown' callback fires - prevents bless missing which was a big problem!
        $("#modal_profile").on "shown", ->

          window.account_completeedit_bless()



  # $("#profile_index_info_actions_visitors").click ->

  #   if !($("#modal_profile").hasClass("in"))

  #     $(".modal").modal("hide")

  #     $.get "/account/visitors", (data) ->
  #       $("#modal_profile").html data

  #       # Bless after modal 'shown' callback fires - prevents bless missing which was a big problem!
  #       # $("#modal_profile").on "shown", ->

  #       #   #window.account_completeedit_bless()

  #       $("#modal_profile").modal "show"


  $("#profile_index_info_actions_invite").click ->

    if !($("#modal_profile").hasClass("in"))

      $(".modal").modal("hide")
      $("#modal_profile").html("")
      $("#modal_profile").modal "show"

      $.get "/invitations", (data) ->
        $("#modal_profile").html data



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

    if !($("#modal_cases").hasClass("in"))

      case_id = $(this).data "case_id"

      $("#modal_cases").html("")
      $(".modal").modal("hide")
      $("#modal_cases").modal "show"

      $.get "/cases/" + case_id, (data) ->
        $("#modal_cases").html data

        # Bless after modal 'shown' callback fires - prevents bless missing which was a big problem!
        $("#modal_cases").on "shown", ->
          modal_cases_show_prime()






  $("#profile_index_feedback_actions_resultstable").click ->

    if !($("#modal_cases").hasClass("in"))

      $("#modal_cases").html ""
      $(".modal").modal("hide")
      $("#modal_cases").modal "show"

      $.get "/cases/analysis?view=table", (data) ->
        $("#modal_cases").html data
        if (cases_analysis_chart_case_count == 0)
          $("#cases_analysis_chart_table_empty").fadeIn "fast"
        else
          modal_cases_analysis_prime()


