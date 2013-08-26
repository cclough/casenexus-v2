$(document).ready ->
  



  # Sliding effect on home
  $(".static_home_slideable").click ->
    $(this).animate
      left: "-50%"
    , 500, ->
      $(this).css "left", "150%"
      $(this).appendTo "#static_home_container_main"

    $(this).next().animate
      left: "50%"
    , 500


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