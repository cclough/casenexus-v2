

window.notifications_index_show_prime = (user_id) ->
  $.get "/notifications/" + user_id, (data) ->
    $("#notifications_index_conversation").html data
    $("#notifications_show_body_subcontainer").scrollTop document.getElementById("notifications_show_body_subcontainer").scrollHeight

    window.application_spinner_prime("#notifications_show_form")


    $("#notifications_show_newmessage_textarea").keydown((event) ->
      if event.keyCode is 13
        $(@form).submit()
        $("#notifications_show_form .application_spinner_container").show()
        false
    )

$(document).ready ->

  $(".notifications_index_notifications_item").click ->

    user_id = $(this).data("user_id")

    # get and load
    window.notifications_index_show_prime user_id

    # add selected class
    $(".notifications_index_notifications_item").removeClass "notifications_index_notifications_item_select"
    $(this).addClass "notifications_index_notifications_item_select"
