
window.static_switch_view = (object,speed) ->

    $(object).fadeOut("fast")

    # Show other button
    switch_from = $(object).data("switch_from")
    $("#static_home_switch_link_" + switch_from).fadeIn("fast")

    switch_to = $(object).data("switch_to")
    element = "#static_home_" + switch_from

    if speed == "instant"
      clicks = 1
    else if speed == "normal"
      clicks = 500

    $(element).animate
      left: "-50%"
    , clicks, ->
      $(element).css "left", "150%"
      $(element).appendTo "#static_home_container_main"
 
    $(element).next().animate
      left: "50%"
    , clicks

$(document).ready ->

  $(".static_home_switch_link").click ->
    window.static_switch_view(this,"normal")




  ######################### SIGNUP ############################

  $('#static_home_signup_notlisted_button').click ->
    if !($("#modal_contact").hasClass("in"))
      $(".modal").modal "hide"
      $("#modal_contact").modal "show"

  $('.chzn-select').chosen()
    # not really needed...
    #.change ->
    #$('#user_email').val("{your email}" + $(this).find('option:selected').val())
  $('.chzn-search').hide();




  # check_confirm_email = ->
  #   if !$('#user_confirm_tac').is(':checked')
  #     $("#static_home_signup_button_submit").attr('disabled', 'disabled')
  #   else
  #     $("#static_home_signup_button_submit").attr('disabled', false)

  # check_confirm_email()

  # $("#user_confirm_tac").click ->
  #   check_confirm_email()