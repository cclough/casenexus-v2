# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(document).ready ->

  # Voteables
  $(".votes_control i").click ->

    direction = $(this).data "vote_direction"
    voteable_id = $(this).data "voteable_id"
    voteable_type = $(this).data "voteable_type"

    $.post("/votes/" + direction + "?voteable_id="+voteable_id+"&voteable_type="+voteable_type)