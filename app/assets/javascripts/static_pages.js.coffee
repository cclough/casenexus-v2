
window.static_switch_view = (object) ->

  switch_from = $(object).data("switch_from")
  switch_to = $(object).data("switch_to")

  $("#static_home_" + switch_from).fadeOut 300, ->
    $("#static_home_" + switch_to).fadeIn 300


window.modal_headsup_show = () ->
  if !($("#modal_headsup").hasClass("in"))

    # clear out inputs and textareas
    $("#modal_headsup input, #modal_headsup textarea").val ""

    $(".modal").modal "hide"

    $("#modal_headsup").on "shown", ->      
      window.application_spinner_prime(".modal.in")

    $("#modal_headsup").modal "show"


$(document).ready ->

  setTimeout (->
    window.modal_headsup_show()
  ), 2000

  $(".static_home_switch_link").click ->
    window.static_switch_view(this,"normal")

  window.application_disablesubmit_prime "#static_home_signin"
  window.application_disablesubmit_prime "#static_home_signup"

  ######################### SIGNUP ############################

  $('#static_home_signup_notlisted_button').click ->
    window.modal_contact_show()

  ######################### DEVISE ############################

  window.application_disablesubmit_prime "#devise_confirmations_new_panel"
  window.application_disablesubmit_prime "#devise_passwords_new_panel"
