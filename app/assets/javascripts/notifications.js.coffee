
window.modal_contact_show = () ->
  if !($("#modal_contact").hasClass("in"))

    # clear out inputs and textareas
    $("#modal_contact input, #modal_contact textarea").val ""

    $(".modal").modal "hide"

    $("#modal_contact").on "shown", ->      
      window.application_spinner_prime(".modal.in")

    $("#modal_contact").modal "show"


window.modal_message_prime = () ->

  # Scroll conversation and scrollTo
  scroll_bottom_height = $(".modal.in #modal_message_conversation").prop('scrollHeight') + 'px'
  $(".modal.in #modal_message_conversation").slimScroll
    width: '100%'
    height: '310px'

  $(".modal.in #modal_message_conversation").slimScroll
    scrollTo: scroll_bottom_height

  # Prime spinner and submit
  window.application_spinner_prime(".modal.in")

  # Enter key submits
  $(".modal.in #modal_message_textarea").off 'keydown'
  $(".modal.in #modal_message_textarea").keydown((event) ->
    if event.keyCode is 13
      $(@form).submit()
      $(".modal.in .application_spinner_container").show()
      false
  )



window.modal_message_show = (friend_id) ->
  
  if !($("#modal_message").hasClass("in"))

    $(".modal").modal("hide")

    $.get "/notifications/modal_message_form?id=" + friend_id, (data) ->
      $("#modal_message").html data

      # Bless after modal 'shown' callback fires - prevents bless missing which was a big problem!
      $("#modal_message").on "shown", ->
        window.modal_message_prime()

      $("#modal_message").modal "show"



window.modal_friendship_req_show = (friend_id) ->
  
  if !($("#modal_friendship_req").hasClass("in"))

    $(".modal").modal("hide")

    $.get "/contacts/modal_friendship_req_form?id=" + friend_id, (data) ->
      $("#modal_friendship_req").html data

      $("#modal_friendship_req").on "shown", ->
        window.application_spinner_prime(".modal.in")

      $("#modal_friendship_req").modal "show"





window.notifications_index_show_show = (user_id) ->
  $.get "/notifications/" + user_id, (data) ->

    $("#notifications_index_conversation").html data
    window.notifications_index_show_prime(user_id)



window.notifications_index_show_prime = (user_id) ->

  # Scroll conversation and scrollTo
  $("#notifications_show_body_subcontainer").slimScroll
    width: '100%'
    height: '100%'

  scroll_bottom_height = $("#notifications_show_body_subcontainer").prop('scrollHeight') + 'px'
  $("#notifications_show_body_subcontainer").slimScroll
    scrollTo: scroll_bottom_height

  # Keep currently selected conversation id in memory so can re activate the item in the index on refresh if needed
  window.notifications_index_notifications_currently_selected = user_id

  # prime spinner
  window.application_spinner_prime("#notifications_show_form")

  # Bind enter submit
  $("#notifications_show_newmessage_textarea").keydown((event) ->
    if event.keyCode is 13
      $(@form).submit()
      $("#notifications_show_form .application_spinner_container").show()
      false
  )

  # Hide the read highlight
  $("#notifications_index_notifications_item_" + user_id).removeClass "unread"

  # Update the menu
  $.get "/notifications/menu", (data) ->
    $("#header_notifications_menu_container").html data

  # Prime action buttons
  window.map_index_users_item_bless()

window.notifications_index_notifications_prime = () ->

  # Reselect current item if needed
  if window.notifications_index_notifications_currently_selected
    current_item = window.notifications_index_notifications_currently_selected
    $("#notifications_index_notifications_item_" + current_item).removeClass "unread"
    $("#notifications_index_notifications_item_" + current_item).addClass "notifications_index_notifications_item_select"
  
  $(".notifications_index_notifications_item").off 'click'
  $(".notifications_index_notifications_item").click ->

    user_id = $(this).data("user_id")

    # get and load
    window.notifications_index_show_show user_id

    # add selected class
    $(".notifications_index_notifications_item").removeClass "notifications_index_notifications_item_select"
    $(this).addClass "notifications_index_notifications_item_select"


  $("#notifications_index_notifications").slimscroll
    width: '100%'
    height: '100%'


$(document).ready ->

  if $("#notifications_index_notifications_container").size() > 0

    window.notifications_index_notifications_prime()

    # prime the initial conversation
    last_user_id = $("#notifications_index_conversation").data "last_user_id"
    window.notifications_index_show_prime(last_user_id)

    # highlight intial conversation in index
    $("#notifications_index_notifications .notifications_index_notifications_item:first").addClass "notifications_index_notifications_item_select"


