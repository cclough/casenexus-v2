
window.static_switch_view = (object,speed) ->


  switch_from = $(object).data("switch_from")
  switch_to = $(object).data("switch_to")

  # Show other button
  $("#static_home_switch_link_" + switch_to).fadeOut "fast", ->
    $("#static_home_switch_link_" + switch_from).fadeIn("fast")


  # Switch
  $("#static_home_" + switch_from).fadeOut "fast", ->
    $("#static_home_" + switch_to).fadeIn "fast"

  # if speed == "instant"
  #   clicks = 1
  # else if speed == "normal"
  #   clicks = 500

  # $(element).animate
  #   left: "-50%"
  # , clicks, ->
  #   $(element).css "left", "150%"
  #   $(element).appendTo "#static_home_container_main"

  # $(element).next().animate
  #   left: "50%"
  # , clicks





$(document).ready ->

  $(".static_home_switch_link").click ->
    window.static_switch_view(this,"normal")

  window.application_disablesubmit_prime "#static_home_signin"
  window.application_disablesubmit_prime "#static_home_signup"

  ######################### SIGNUP ############################

  $('#static_home_signup_notlisted_button').click ->
    window.modal_contact_show()

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