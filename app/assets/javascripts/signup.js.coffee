$(document).ready ->
  check_confirm_email = ->
    if !$('#user_confirm_tac').is(':checked')
      $("#static_home_signup_option_university_button_submit").attr('disabled', 'disabled')
    else
      $("#static_home_signup_option_university_button_submit").attr('disabled', false)

  check_confirm_linkedin = ->
    if $('#user_confirm_tac').is(':checked') && $('#confirm_linkedin').is(':checked')
      $("#static_home_signup_option_linkedin_button_submit").attr('disabled', false)
    else
      $("#static_home_signup_option_linkedin_button_submit").attr('disabled', 'disabled')

  check_confirm_email()
  check_confirm_linkedin()

  $("#user_confirm_tac").click ->
    check_confirm_email()
    check_confirm_linkedin()

  $("#confirm_linkedin").click ->
    check_confirm_linkedin()

  $("#static_home_signup_option_linkedin_button_submit, #static_home_signup_option_linkedin_button_submit img, #static_home_signup_option_linkedin_button_submit span").click (e) ->
    if $("#static_home_signup_option_linkedin_button_submit").attr('disabled') == 'disabled'
      e.preventDefault()
