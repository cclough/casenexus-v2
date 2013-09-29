
window.notifications_index_show_prime = (user_id) ->
  $.get "/notifications/" + user_id, (data) ->
    $("#notifications_index_conversation").html data
    $("#notifications_show_body_subcontainer").scrollTop document.getElementById("notifications_show_body_subcontainer").scrollHeight

    # Keep currently selected conversation id in memory so can re activate the item in the index on refresh if needed
    window.notifications_index_notifications_currently_selected = user_id

    # prime spinner
    window.application_spinner_prime("#notifications_show_form")

    # Bind enter submit
    $("#notifications_show_newmessage_textarea").keydown((event) ->
      if event.keyCode is 13
        $(@form).submit()
        $("#notifications_show_form .application_spinner_container").show()
        false
    )

    # Hide the read highlight
    $("#notifications_index_notifications_item_" + user_id + " .notifications_index_notifications_item_read_highlight").fadeOut "fast"

    # Update the menu
    $.get "/notifications/menu", (data) ->
      $("#header_notifications_menu_container").html data


window.notifications_index_notifications_prime = () ->

  # Reselect current item if needed
  if window.notifications_index_notifications_currently_selected
    current_item = window.notifications_index_notifications_currently_selected
    $("#notifications_index_notifications_item_" + current_item).addClass "notifications_index_notifications_item_select"
  
  
  $(".notifications_index_notifications_item").click ->

    user_id = $(this).data("user_id")

    # get and load
    window.notifications_index_show_prime user_id

    # add selected class
    $(".notifications_index_notifications_item").removeClass "notifications_index_notifications_item_select"
    $(this).addClass "notifications_index_notifications_item_select"


$(document).ready ->

  window.notifications_index_notifications_prime();
