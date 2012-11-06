$(document).ready ->

  $('.chzn-select').chosen().change ->
    $('#user_email').val("@" + $(this).find('option:selected').val())
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
