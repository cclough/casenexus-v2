# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


window.onlinepanel_prime = () ->
  $(".onlinepanel_show_menu_message").click ->
    friend_id = $(this).data "friend_id"
    window.modal_message_show(friend_id)



  $(".onlinepanel_show_menu_addfriend").click ->

    friend_id = $(this).data "friend_id"
    window.modal_friendship_req_show(friend_id)

  $("#onlinepanel_response_min").click ->
    if $("#onlinepanel_response").is(':visible')
      $("#onlinepanel_response").fadeOut "fast"
    else
      $("#onlinepanel_response").fadeIn "fast"

  $("#onlinepanel_posts_new_button").click ->
    window.modal_post_show()


  # The Ping updater! Could be a lot smoother, but for now o-k
  # setInterval ->
  #   window.onlinepanels_refresh()
  # , 30000

window.onlinepanels_refresh = (callback) ->
  $.get "/onlinepanel/container", (data) ->

    $("#onlinepanel_container").html data

    window.onlinepanel_prime()   

    callback()


$(document).ready ->

  # ONLINE PANEL STUFF
  window.onlinepanel_prime()