$(document).ready ->

  $("#notifications_show_header_back").click ->
    history.go -1
    false

  $("#notifications_show_footer_button_message").click ->
    if !($("#modal_message").hasClass("in"))
      $(".modal").modal "hide"
      $("#modal_message").modal "show"

