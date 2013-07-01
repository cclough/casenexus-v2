# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->

  #////////////////////////////////////////////////////////
  #//////////////////////// INDEX /////////////////////////
  #////////////////////////////////////////////////////////

  $(".posts_index_channels_item_submit_button").click ->

    radio_num = $(this).data "radio"

    $('input[name="post[channel_id]"]:eq(' + radio_num + ')').prop "checked", true

    $(".posts_index_channels_item_submit_button").removeClass "active"
    $(this).addClass "active"