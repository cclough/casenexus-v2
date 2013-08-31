

window.notifications_index_jump = (user_id) ->
  $.get "/notifications/" + user_id, (data) ->
    $("#notifications_index_conversation").html data

    # scroll div (animate)

    # $("#notifications_show_body_subcontainer").animate
    #   scrollTop: document.getElementById("notifications_show_body_subcontainer").scrollHeight;
    # , "fast"
    
    # scroll div (instant)
    $("#notifications_show_body_subcontainer").scrollTop document.getElementById("notifications_show_body_subcontainer").scrollHeight




$(document).ready ->


  $(".notifications_index_notifications_item").click ->

    user_id = $(this).data("user_id")

    # get and load
    window.notifications_index_jump user_id

    # add selected class
    $(".notifications_index_notifications_item").removeClass "notifications_index_notifications_item_select"
    $(this).addClass "notifications_index_notifications_item_select"