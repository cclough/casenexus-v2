window.static_switch_view = (object) ->

  switch_from = $(object).data("switch_from")
  switch_to = $(object).data("switch_to")

  $("#static_home_" + switch_from).fadeOut 300, ->
    $("#static_home_" + switch_to).fadeIn 300





$(document).ready ->


  $(".static_home_switch_link").click ->
    window.static_switch_view(this,"normal")

  window.application_disablesubmit_prime "#static_home_signin"
  window.application_disablesubmit_prime "#static_home_signup"

  # Contact modal show 
  $("#static_home_footer_contact").click ->
    window.modal_contact_show()

  # $("#static_home_title_url").fadeIn "200"
  # $("#static_home_subtitle").fadeIn "300"
  # $("#static_home_logo").fadeIn "400"
  # $("#static_home_footer").fadeIn "500"



  #////////////////////////////////////////////////////
  #//////////////////  SIGNUP   ///////////////////////
  #////////////////////////////////////////////////////

  $('#static_home_signup_notlisted_button').click ->
    window.modal_contact_show()

  #////////////////////////////////////////////////////
  #////////////////////  DEVISE   /////////////////////
  #////////////////////////////////////////////////////

  window.application_disablesubmit_prime "#devise_confirmations_new_panel"
  window.application_disablesubmit_prime "#devise_passwords_new_panel"
