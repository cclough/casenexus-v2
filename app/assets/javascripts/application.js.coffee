#= require jquery
#= require jquery_ujs
#= require jquery.ui.effect-slide
#= require jquery.ui.effect
#= require bootstrap-wysihtml5

#= require lib/jquery.raty
#= require lib/jquery.titlealert
#= require lib/jquery.truncate
#= require lib/jquery.placeholder
#= require lib/jquery.hoverIntent
#= require lib/chosen.jquery
#= require lib/slimscroll
#= require lib/bootstrap
#= require lib/bootstrap-clickover
#= require lib/bootstrap-datetimepicker
#= require lib/bootstrap-lightbox
#= require lib/pusher
#= require lib/amcharts
#= require lib/amcharts-serial
#= require lib/mapbox

#= require account
#= require books
#= require cases
#= require complete
#= require console
#= require events
#= require footer
#= require map
#= require notifications
#= require profile
#= require static_pages





window.application_form_errors_close = () ->
  $("#application_error_explanation").click ->
    $(this).fadeOut "fast"


window.application_notification_trigger = (data_inc) ->

  # Show Popup
  $.get "/notifications/" + data_inc.notification_id + "/notify", (data) ->
    $("#application_notify").html data
    $("#application_notify").fadeIn()
    # Popup auto-hide
    setTimeout (->
      $("#application_notify").fadeOut()
    ), 20000

    # Popup close button prime
    $("#application_notify_close").click ->
      $("#application_notify").fadeOut "fast"

    # Truncatables
    window.application_truncatables()

    # Click prime
    $("#application_notify").off 'click'
    $("#application_notify").click ->
      window.modal_message_show(data_inc.from_id)

  # TitleAlert options here: http://heyman.info/2010/sep/30/jquery-title-alert/
  title_msg = "You have a new notification from " + data_inc.from
  $.titleAlert title_msg,
    stopOnFocus: true,
    stopOnMouseMove: true

  # Refresh Header Icon
  $.get "/notifications/menu", (data) ->
    $("#header_notifications_menu_container").html data



window.application_truncatables = () ->
  $('.application_truncatable').truncate
    width: 'auto'
    token: '&hellip;'
    side: 'right'
    multiline: false


window.application_spinner_prime = (container, confirm_text) ->

  # unbind the click (cause of event duplication bug)
  $(container + " .application_submit_button_with_spinner").off 'click'
  $(container + " .application_spinner_container").hide()

  # SUBMIT CLICK: Submit button loading animation and submit button prime
  $(container + " .application_submit_button_with_spinner").click ->

    if confirm_text
      r = confirm confirm_text
      if r is true
        $(this).closest("form").submit()
        $(container + " .application_spinner_container").show()
    else
      $(this).closest("form").submit()
      $(container + " .application_spinner_container").show()


window.application_disablesubmit_prime = (container) ->
  
  # unbind the click (cause of event duplication bug)
  $(container + " .application_submit_button_with_disable").off 'click'

  $(container + " .application_submit_button_with_disable").removeClass "disabled"

  # SUBMIT CLICK: Submit button loading animation and submit button prime
  $(container + " .application_submit_button_with_disable").click ->
    $(container + " .application_submit_button_with_disable").addClass "disabled"
    $(container + " .application_submit_button_with_disable").off 'click'
    $(this).closest("form").submit() # stops addclass on safari for some reason

  $(container + " input").keydown((event) ->
    if event.keyCode is 13
      $(container + " .application_submit_button_with_disable").addClass "disabled"
      $(container + " .application_submit_button_with_disable").off 'click'
      $(this).closest("form").submit() # stops addclass on safari for some reason
  )



window.application_raty_prime = () ->
  
  $(".books_rating_read").raty
    readOnly: true
    # hints: ["Very Poor", "Poor", "OK", "Good", "Excellent"]
    score: ->
      return parseFloat $(this).data("rating")



window.application_choiceNav = () ->
  window.ChoiceNav =
    init: ->
      $("li[href*=#]").click (e) ->
        e.preventDefault()
        filter_name = $(this).closest(".application_filtergroup_choicenav").attr "data-filter_name"
        window.ChoiceNav.goTo $(this).attr("href").split("#")[1], filter_name if $(this).attr("href").split("#")[1]

    goTo: (page, filter_name) ->
      filter_name_complete = "#application_filtergroup_choicenav_" + filter_name
      nav_item = $(filter_name_complete + " nav ul li[href=#" + page + "]")

      if filter_name == "btype"
        btype = $(nav_item).data "btype"
        $("#books_filter_" + filter_name).val btype
        window.books_index_books_updatelist()
      else if filter_name == "sort"
        sort = $(nav_item).data "sort"
        $("#books_filter_" + filter_name).val sort
        window.books_index_books_updatelist()
      else if filter_name == "period"
        period = $(nav_item).data "period"
        $("#cases_resultstable_" + filter_name).val period

      window.ChoiceNav.centerArrow nav_item, filter_name_complete
      window.ChoiceNav.growLine nav_item, filter_name_complete
    
    centerArrow: (nav_item, filter_name_complete) ->
      if filter_name_complete == "#application_filtergroup_choicenav_period"
        arrow_offset = 5
      else
        arrow_offset = 22
    
      left_margin = ((nav_item.position().left + nav_item.width()/2) + arrow_offset) - (nav_item.width() / 2)
      $(filter_name_complete + " nav .arrow").animate
        left: left_margin
      , 100, ->
        $(this).show()

    growLine: (nav_item, filter_name) ->
      left_margin = (nav_item.position().left + nav_item.width()/2) - (nav_item.width() / 2)
      $(filter_name + " nav .application_filtergroup_choicenav_follower_line").animate
        width: left_margin
      , 100, ->
        $(this).show()  

  window.ChoiceNav.init()




window.application_chosen_prime = () ->
  $(".chzn-select").chosen()
  $(".chzn-select-nosearch").chosen disable_search_threshold: 10
  $(".chzn-select-tags").chosen max_selected_options: 5
  $('.chzn-search').hide()



$(document).ready ->


  # Close buttons
  $(".close").click ->
    $(this).parent().hide()

  # Jquery truncate
  window.application_truncatables()

  # Chosen
  window.application_chosen_prime()

  # Tooltips throughout app
  $(".application_tooltip").tooltip()

  # Placeholders
  $("input, textarea").placeholder()

  # Modals
  $("#modal_contact, #modal_post, #modal_cases, #modal_profile, #modal_message, #modal_friendship_req, #modal_event").modal
    backdrop: true
    show: false

  # Contact modal show 
  $("#header_link_contact").click ->
    window.modal_contact_show()

  # Fade out any flash
  setTimeout ->
    $("#application_flash").fadeOut('fast');
  , 4000

  # Click form errors to hide them
  window.application_form_errors_close();

  # FILTER SLIDERS
  if $(".application_filtergroup_choicenav").size() > 0
    window.application_choiceNav()








