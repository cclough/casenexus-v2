# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


onlinepanel_item_togglemenu = (showbutton, menu) ->

  if $(showbutton).hasClass "active"
    menu.hide "slide", direction: "right", 200
    $(showbutton).removeClass "active"
    $(showbutton).html "<i class=icon-ellipsis-horizontal></i>"
  else
    menu.show "slide", direction: "right", 200
    $(showbutton).addClass "active"
    $(showbutton).html "<i class=icon-angle-right></i>"



window.onlinepanel_prime = () ->

  $(".onlinepanel_show_menu_open").click ->

    friend_id = $(this).data("friend_id")
    menu = $(".onlinepanel_show_menu_container[data-friend_id='" + friend_id + "']")

    onlinepanel_item_togglemenu(this, menu)


  # Show message
  $(".onlinepanel_show_menu_message").click ->
    friend_id = $(this).data "friend_id"
    window.modal_message_show(friend_id)


  # Non-friends - add friend
  $(".onlinepanel_show_menu_addfriend").click ->

    friend_id = $(this).data "friend_id"
    window.modal_friendship_req_show(friend_id)


  # Response view - show panel
  $("#onlinepanel_response_min").click ->
    if $("#onlinepanel_response").is(':visible')
      $("#onlinepanel_response").fadeOut "fast"
    else
      $("#onlinepanel_response").fadeIn "fast"


  # New post button
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

    callback() if callback




$(document).ready ->

  # ONLINE PANEL STUFF
  window.onlinepanel_prime()

  $("#onlinepanel_posts_post_close").click ->
    $("#onlinepanel_posts_post").fadeOut "fast"

  