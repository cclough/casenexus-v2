# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(document).ready ->

  $(".profile_index_friends_friends_item").click ->
    
    $(".profile_index_friends_friends_item").removeClass "active"
    $(this).addClass "active"