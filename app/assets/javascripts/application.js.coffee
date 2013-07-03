#= require jquery
#= require jquery_ujs

#= require jquery.ui.effect-slide
#= require jquery.ui.effect
#= require jquery.ui.widget
#= require jquery.ui.accordion

#= require lib/jquery.placeholder
#= require lib/jquery.uniform
#= require lib/chosen.jquery

#= require lib/jquery.raty
#= require lib/jquery.titlealert
#= require lib/jquery.inview
#= require lib/jquery.truncate

#= require lib/bootstrap.min
#= require lib/bootstrap-datetimepicker
#= require bootstrap-wysihtml5

# Get query params, global function

window.getQueryParams = (qs) ->
  qs = qs.split("+").join(" ")
  params = {}
  tokens = undefined
  re = /[?&]?([^=]+)=([^&]*)/g
  params[decodeURIComponent(tokens[1])] = decodeURIComponent(tokens[2])  while tokens = re.exec(qs)
  params

window.application_help_checkbox = (help_page) ->
  $.get "/members/help_checkbox?help_page=" + help_page, (data) ->
    $("#modal_help_checkbox_container").html data
    $("input:checkbox").uniform()


window.application_show_help = (help_page) ->
  if !($("#modal_help").hasClass("in"))
    $(".modal").modal "hide"
    $("#modal_help").modal "show"

  setTimeout ->
    window.ArrowNav.goTo help_page
  , 50

  window.application_help_checkbox help_page

window.application_truncatables = () ->
  $('.application_truncatable').truncate
    width: 'auto'
    token: '&hellip;'
    side: 'right'
    multiline: false





window.modal_spinner_prime = () ->

  $("#application_spinner_container").css "display","none"

  # Submit button loading animation and submit Prime
  $(".modal_submit_button").click ->

    $("#application_spinner_container").show()

    $(this).closest("form").submit()







window.modal_message_prime = () ->
  # Scroll div
  $("#modal_message_conversation").animate
    scrollTop: document.getElementById("modal_message_conversation").scrollHeight;
  , "fast"

  # # Submit button loading animation and submit Prime
  # $("#modal_message_submit_button").click ->
  #   $("#application_spinner_container").show()
  #   $('#modal_message_form').submit();

  window.modal_spinner_prime()

window.modal_message_show = (friend_id) ->
  
  if !($("#modal_message").hasClass("in"))

    $.get "/notifications/modal_message_form?id=" + friend_id, (data) ->
      $("#modal_message").html data

      $("#modal_message").modal("show")

      window.modal_message_prime()








window.modal_event_new_show = (friend_id, book_id) ->

  if !($("#modal_event").hasClass("in"))
    $(".modal").modal("hide")

  if friend_id && !book_id
    url = "/events/new?friend_id=" + friend_id
  else if book_id && !friend_id
    url = "/events/new?book_id_user=" + book_id
  else if friend_id && book_id
    url = "/events/new?friend_id=" + friend_id + "&book_id_user=" + book_id
  else
    url = "/events/new"

  $.get url, (data) ->
    $("#modal_event").html data
    window.modal_events_rebless()

    if friend_id
      $.get "/events/user_timezone?user_id=" + friend_id, (data) ->
        $("#events_new_friend_timezone").html data

    $("#modal_event").modal("show")

    window.modal_spinner_prime()




window.modal_events_new_timezone_calcs = ->

  friend_id = $("#events_new_friend_select").val()
  datetime = $("#events_new_datetime_input").val()
  
  if friend_id
    $.get "/events/user_timezone?user_id=" + friend_id, (data) ->
      $("#events_new_friend_timezone").html data
  else
    $("#events_new_friend_timezone").html("")

  if friend_id && datetime
    $.get "/events/user_timezone?user_id=" + friend_id+"&datetime="+datetime, (data) ->
      $("#events_new_datetime_friend").html data
  else
    $("#events_new_datetime_friend").html("")

window.modal_events_rebless = ->
  $("#events_new_datetime_picker").datetimepicker
    format: "dd MM yyyy - hh:ii"
    minuteStep: 15
    pickerPosition: 'bottom-left'    
    showMeridian: true

  $("#events_new_friend_select").change ->
    window.modal_events_new_timezone_calcs()

  $("#events_new_datetime_input").change ->
    window.modal_events_new_timezone_calcs()

  window.modal_spinner_prime()






window.application_container_online_prime = () ->
  $(".application_container_online_item_menu_message").click ->

    friend_id = $(this).data "friend_id"
    window.modal_message_show(friend_id)





$(document).ready ->

  # Jquery truncate
  window.application_truncatables()

  # Chosen
  $(".chzn-select").chosen()
  $(".chzn-select-nosearch").chosen disable_search_threshold: 10

  # Style for the checkboxes
  $("input:checkbox").uniform()

  # Tooltips on Avatars
  $(".application_avatar_icon").tooltip()

  # Tooltips throughout app
  $(".application_tooltip").tooltip()

  # Placeholders
  $("input, textarea").placeholder()

  # Header search - only if not on map page
  if typeof map_index_map_lat_start is "undefined"
    $("#header_nav_panel_browse_search_form").on "submit", ->
      window.location.href = "/map?search=" + $("#header_nav_panel_browse_search_field").val()

  # Modals
  $("#modal_contact, #modal_message, #modal_friendship_req, #modal_event, #modal_help").modal
    backdrop: false
    show: false

  # Modal help checkbox
  $("#modal_help_checkbox").on 'change', ->
    page_id = $(this).attr("data-page_id")
    user_id = $(this).attr("data-user_id")
    if !$(this).is(':checked')
      $.ajax("/members/" + user_id + "/show_help?act=uncheck&page_id=" + page_id, type: 'PUT')
    else
      $.ajax("/members/" + user_id + "/show_help?act=check&page_id=" + page_id, type: 'PUT')

  # Modal help link
  $("#header_link_help").click ->
    if !($("#modal_help").hasClass("in"))
      $(".modal").modal "hide"
      $("#modal_help").modal "show"
      window.ArrowNav.goTo 1

  # Modal contact link
  $("#header_link_contact").click ->
    if !($("#modal_contact").hasClass("in"))
      $(".modal").modal "hide"
      $("#modal_contact").modal "show"

  # Modal buttons
  $(".modal-footer button").on 'click', (e) ->
    $that = $(this)
    setTimeout ->
      $that.parents(".modal-footer").find("a, button").attr('disabled', 'disabled')
    , 50
    $(this).parents(".modal").on "show", ->
      $(".modal-footer").find("a, button").attr('disabled', false)

  # Fade out any flash
  setTimeout ->
    $("#application_flash").fadeOut('fast');
  , 4000





  # ONLINE PANEL STUFF
  window.application_container_online_prime()
          
  # The Ping updater! Could be a lot smoother, but for now o-k
  setInterval ->
    $.get "/online_panel", (data) ->
      $("#application_container_online").html data
      window.application_container_online_prime()
  , 30000

      







  # Arrows for the home page and help
  if $("#static_home_arrownav").size() > 0 || $("#modal_help_arrownav").size() > 0
    window.ArrowNav =
      init: ->
        $("a[href*=#]").click (e) ->
          e.preventDefault()
          window.ArrowNav.goTo $(this).attr("href").split("#")[1]  if $(this).attr("href").split("#")[1]

        @goTo "1"
        
      goTo: (page) ->
        next_page = $("#application_arrownav_page_" + page)
        nav_item = $("nav ul li a[href=#" + page + "]")
        $("nav ul li").removeClass "current"
        nav_item.parent().addClass "current"
        $(".arrownav_page").hide()
        $(".arrownav_page").removeClass "current"
        next_page.addClass "current"
        
        if $("#modal_help_arrownav").size() > 0
          next_page.fadeIn 500
          $('.modal-body').scrollTop(0)
          window.application_help_checkbox(page)
        else
          next_page.show "slide", direction: "right", 500

        window.ArrowNav.centerArrow nav_item

      centerArrow: (nav_item, animate) ->
        left_margin = (nav_item.parent().position().left + nav_item.parent().width()) + 24 - (nav_item.parent().width() / 2)
        unless animate is false
          $("nav .arrow").animate
            left: left_margin - 8
          , 500, ->
            $(this).show()

        else
          $("nav .arrow").css left: left_margin - 8

    window.ArrowNav.init()



