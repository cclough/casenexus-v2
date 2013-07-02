

window.notifications_index_jump = (user_id) ->
  $.get "/notifications/" + user_id, (data) ->
    $("#notifications_index_conversation").html data

    # scroll div
    $("#notifications_show_body_subcontainer").animate
      scrollTop: document.getElementById("notifications_show_body_subcontainer").scrollHeight;
    , "fast"

    # scroll div
    # objDiv = document.getElementById("notifications_show_body")
    # objDiv.scrollTop = objDiv.scrollHeight



$(document).ready ->


  $(".notifications_index_notifications_item").click ->

    user_id = $(this).data("user_id")

    # get and load
    window.notifications_index_jump user_id

    # add selected class
    $(".notifications_index_notifications_item").removeClass "select"
    $(this).addClass "select"


  # for index infinite scrolling
  $('a.load-more-posts').on 'inview', (e, visible) ->
    return unless visible
    
    $.getScript $(this).attr('href')

