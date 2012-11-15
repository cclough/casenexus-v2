notifications_index_notifications_link = ->
  query = getQueryParams(document.location.search)
  $("#notifications_index_notifications_item_content_" + query.id).slideDown("fast") if query.id

$(document).ready ->
  notifications_index_notifications_link()

  # Show content
  $(".notifications_index_notifications_item_button_expand").click ->
    item_id = $(this).attr("data-id")
    notification = $("#notifications_index_notifications_item_" + item_id)

    # Toggle Read
    notification.addClass("read")

    # Slide
    if notification.hasClass("slid")
      $("#notifications_index_notifications_item_content_" + item_id).slideUp "fast"
      notification.removeClass "slid"
      notification.addClass "read"
    else
      # Mark the notification as readed
      $.ajax("/notifications/" + item_id + "/read", type: 'PUT')

      $("#notifications_index_notifications_item_content_" + item_id).slideDown "fast"
      notification.addClass "slid"
      notification.removeClass "read"

  $("#notifications_show_header_back").click ->
    history.go -1
    false

  $("#notifications_show_footer_button_message").click ->
    if !($("#modal_message").hasClass("in"))
      $(".modal").modal "hide"
      $("#modal_message").modal "show"

