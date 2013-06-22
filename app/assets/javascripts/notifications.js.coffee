



$(document).ready ->


  $(".notifications_index_notifications_item").click ->

    user_id = $(this).data("user_id")

    $.get "/notifications/" + user_id, (data) ->
      $("#notifications_index_conversation").html data

    $(".notifications_index_notifications_item").removeClass "select"
    $(this).addClass "select"



  $('a.load-more-posts').on 'inview', (e, visible) ->
    return unless visible
    
    $.getScript $(this).attr('href')