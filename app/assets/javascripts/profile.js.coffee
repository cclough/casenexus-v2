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

  # $("#cases_show_panel_right").slimscroll
  #   width: '300px'
  #   height: '500px'

  $(".cases_show_recommendation_content").slimscroll
    width: '170px'
    height: '138px'


window.modal_cases_show_show = (case_id) ->

  if !($("#modal_cases").hasClass("in"))

    $("#modal_cases").empty()
    
    $("#modal_cases").removeClass "analysis"
    $("#modal_cases").addClass "show"

    $(".modal").modal("hide")

    $.get "/cases/" + case_id, (data) ->
      $("#modal_cases").html data

      $("#modal_cases").modal "show"

      $("#modal_cases").on "shown", ->  

        setTimeout (-> # prevents jurk as modal slides to the bottom
          modal_cases_show_prime()
        ), 100




$(document).ready ->


  # Prime scrollers
  $('#profile_index_friends_friends').slimscroll
    height: 'auto'
    width: 'auto'
  $('#profile_index_feedback_cases').slimscroll
    height: 'auto',
    width: '260px'


  # Friends item: show actions on mouseover
  mouseover = ->
    $(this).find(".profile_index_friends_friends_item_actions").show "slide", direction: "right", 100
  mouseout = ->
    $(this).find(".profile_index_friends_friends_item_actions").hide "slide", direction: "right", 100
  $(".profile_index_friends_friends_item").hoverIntent
    over: mouseover,
    out: mouseout,
    interval: 250



  # On load animations
  if $("#profile_index_panel_user").size() > 0
    setTimeout (->
      # Fade in counts cases
      $(".profile_index_info_cases_counts_container").fadeIn "500"

      # Users Item Cascade Fade
      $(".profile_index_friends_friends_item").each (i) ->
        $(this).delay((i + 1) * 50).fadeIn()

      $(".profile_index_feedback_cases_item").each (i) ->
        $(this).delay((i + 1) * 50).fadeIn()
    ), 500

  $("#profile_index_feedback_chart").fadeIn "500"


  # User action buttons - settings etc.
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


  # FRIENDS items
  $("#profile_index_friends_actions_message").click ->
    friend_id = $("#profile_index_friends_action_input").val()

    unless !friend_id
      window.modal_message_show(friend_id)
    else
      alert "Please select a friend from the list..."

  $("#profile_index_friends_actions_event").click ->
    friend_id = $("#profile_index_friends_action_input").val()
    
    unless !friend_id
      window.modal_event_new_show(friend_id,null)
    else
      alert "Please select a friend from the list..."


  # FEEDBACK items
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



  # Analysis in modal
  $("#profile_index_feedback_actions_analysis").click ->

    if !($("#modal_cases").hasClass("in"))

      $("#modal_cases").removeClass "show"
      $("#modal_cases").addClass "analysis"

      $("#modal_cases").html ""
      $(".modal").modal("hide")


      $.get "/cases/results?view=analysis", (data) ->
        $("#modal_cases").html data

        $("#modal_cases").modal "show"

        $("#modal_cases").on "shown", ->

          setTimeout (-> # prevents jurk as modal slides to the bottom
            if (cases_analysis_chart_case_count == 0)
              $("#cases_analysis_chart_table_empty").fadeIn "fast"
            else
              window.cases_resultstable_prime("analysis")
          ), 100

