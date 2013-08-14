# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


window.votes_controls_prime = () ->

  # Voteables
  $(".votes_control i").click ->

    voted = $(this).data "voted"
    if voted == 1

      vote_prev_id = $(this).data "vote_prev_id"

      $.ajax
        url: "/votes/" + vote_prev_id
        type: "DELETE"

    else
      direction = $(this).data "vote_direction"
      voteable_id = $(this).data "voteable_id"
      voteable_type = $(this).data "voteable_type"

      $.post("/votes/" + direction + "?voteable_id="+voteable_id+"&voteable_type="+voteable_type)



$(document).ready ->

  window.votes_controls_prime()
