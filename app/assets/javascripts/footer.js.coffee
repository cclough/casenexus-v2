footer_posts_post_prime = () ->

  $("#footer_posts_post").click ->

    user_id = $(this).attr("data-user_id")

    if typeof map_index_map_lat_start is "string"
      window.map_index_users_form_reset()

      # Check params, add user_id and update the list - sweet
      $("#users_listtype_params").prop "checked", true
      $("#user_id").val user_id
      window.map_index_users_updatelist()
    else
      $(window.location.replace("/map?user_id="+user_id))


  # Prime close button
  $("#footer_posts_post_close").click ->
    $("#footer_posts_post").fadeOut "fast"

  # Prime widget for click to show post
  $("#footer_posts_widget").off "click"
  $("#footer_posts_widget").click ->
    $("#footer_posts_post").fadeIn "fast"




$(document).ready ->

  # New posts button
  $("#footer_posts_new_button").click ->
    if !($("#modal_post").hasClass("in"))
      $(".modal").modal("hide")
      $("#modal_post").on "shown", ->
        window.application_spinner_prime(".modal.in")
      $("#modal_post").modal "show"


  # Guide - posts browser controls
  $("#footer_posts_arrow_buttons_container .btn").click ->

    direction = $(this).attr("data-direction")
    # get current post id
    current_post_id = $("#footer_posts_post_container").attr "data-current_post_id"

    $.get "/posts/" + current_post_id + "?direction=" + direction, (data) ->
      $("#footer_posts_post_container").html data

      $("#footer_posts_post").fadeIn "fast"

      # get new post id
      new_post_id = $("#footer_posts_post").attr "data-post_id"
      # update current_post_id
      $('#footer_posts_post_container').attr('data-current_post_id', new_post_id)

      # update username

      $("#footer_posts_username").fadeOut "fast", ->
        $.get "/posts/" + new_post_id + "/show_username", (data) ->
          $("#footer_posts_username").html data
          $("#footer_posts_username").fadeIn "fast"

      # hide up arrow if nothing in future
      if ($("#footer_posts_post").attr("data-post_next_id") == "nil")
        $("#footer_posts_arrow_button_up").fadeOut "fast"
      else
        $("#footer_posts_arrow_button_up").fadeIn "fast"

      # hide down arrow if nothing in past
      if ($("#footer_posts_post").attr("data-post_prev_id") == "nil")
        $("#footer_posts_arrow_button_down").fadeOut "fast"
      else
        $("#footer_posts_arrow_button_down").fadeIn "fast"

      # prime click
      footer_posts_post_prime()


  # Post fade in after short delay
  if $("#footer_posts_post").size() > 0

    unless $("#footer_posts_post").hasClass "initial_show_complete"
      setTimeout (->
        $("#footer_posts_post").fadeIn "fast"
      ),1000

    # prime initial post
    footer_posts_post_prime()


  # Onlineusers button
  $("#footer_onlineusers").click ->
    
    if typeof map_index_map_lat_start is "string"
      window.map_index_users_form_reset()
      # Check params, add user_id and update the list - sweet
      $("#users_listtype_online_now").prop "checked", true
      $("#map_index_users_form_button_online_now").addClass "active"
      window.map_index_users_updatelist()
    else
      $(window.location.replace("/map?show=onlinenow"))
