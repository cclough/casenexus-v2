$(document).ready ->

  # slider start
  c = 2
  interval = setInterval(->
    window.ArrowNav.goTo c
    c++
    if c >= 6
      c = 1

  , 10000)

  # slider stop on mouseover
  $('#static_home_slider_panel').mouseover ->
    clearInterval(interval);

  ######################### SIGNUP ############################

  $('.chzn-select').click ->
    $('.chzn-select').width 400

  $('.chzn-select').chosen().change ->
    $('#user_email').val("{your email}" + $(this).find('option:selected').val())
    $('.chzn-select').css("width:232px;")
  $('.chzn-search').hide();

  $('#static_home_signup_option_linkedin_button').click ->
    $('#static_home_signup_option_university_button').removeClass('active');
    $('#static_home_signup_option_linkedin_button').addClass('active');
    $('#static_home_signup_option_university').slideUp "fast"
    $('#static_home_signup_option_university_submit').slideUp "fast"
    $('#static_home_signup_option_linkedin').slideDown "fast"
    $('#static_home_signup_option_linkedin_submit').slideDown "fast"

  $('#static_home_signup_option_university_button').click ->
    $('#static_home_signup_option_university_button').addClass('active');
    $('#static_home_signup_option_linkedin_button').removeClass('active');
    $('#static_home_signup_option_university').slideDown "fast"
    $('#static_home_signup_option_university_submit').slideDown "fast"
    $('#static_home_signup_option_linkedin').slideUp "fast"
    $('#static_home_signup_option_linkedin_submit').slideUp "fast"

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