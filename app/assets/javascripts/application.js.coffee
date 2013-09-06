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
#= require lib/jquery.truncate

#= require lib/bootstrap.min
#= require lib/bootstrap-datetimepicker
#= require bootstrap-wysihtml5





#= require lib/bootstrap-select
#= require lib/bootstrap-switch
#= require lib/flatui-checkbox
#= require lib/flatui-radio
#= require lib/jquery.stacktable
#= require lib/jquery.tagsinput
#= require lib/jquery.ui.touch-punch.min






# Get query params, global function

window.getQueryParams = (qs) ->
  qs = qs.split("+").join(" ")
  params = {}
  tokens = undefined
  re = /[?&]?([^=]+)=([^&]*)/g
  params[decodeURIComponent(tokens[1])] = decodeURIComponent(tokens[2])  while tokens = re.exec(qs)
  params


window.application_form_errors_close = () ->
  $("#application_error_explanation").click ->
    $(this).fadeOut "fast"


window.notification_trigger = (data_inc) ->

  # Show Popup
  $.get "/notifications/" + data_inc.notification_id + "/popup", (data) ->
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

  # TitleAlert options here: http://heyman.info/2010/sep/30/jquery-title-alert/
  title_msg = "You have a new notification from " + data_inc.from
  $.titleAlert title_msg,
    stopOnFocus: true,
    stopOnMouseMove: true

  # Refresh Header Icon
  $.get "/notifications/menu", (data) ->
    $("#application_profilenav_notifications").html data

  #Friend's List
  window.onlinepanels_refresh ->
    
    # once online list has refreshed, commence animations
    x = 0
    intervalID = setInterval(->
      
      glow = $("#application_profilenav_item_icon_notifications")
      (if not glow.hasClass("glow") then glow.addClass("glow") else glow.removeClass("glow"))
      glow = $("#onlinepanel_container .notifications_glowable")
      (if not glow.hasClass("glow") then glow.addClass("glow") else glow.removeClass("glow"))

      if ++x is 10
        window.clearInterval intervalID
        $("#application_profilenav_item_icon_notifications").removeClass 'glow'
        $("#onlinepanel_container .notifications_glowable").removeClass 'glow'

    , 500)








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
    , 500

    window.application_help_checkbox help_page




window.application_truncatables = () ->
  $('.application_truncatable').truncate
    width: 'auto'
    token: '&hellip;'
    side: 'right'
    multiline: false



window.application_countchar = (val) ->
  len = val.value.length
  if len >= 500
    val.value = val.value.substring(0, 500)
    val.parent("div").find(".application_countchar_count").text 0
  else
    val.parent("div").find(".application_countchar_count").text 500 - len
  



window.modal_spinner_prime = () ->

  $(".modal.in .application_spinner_container").hide()

  # SUBMIT CLICK: Submit button loading animation and submit button prime
  $(".modal.in .application_submit_button_with_spinner").click ->

    $(this).closest("form").submit()
    $(".modal.in .application_spinner_container").show()





window.modal_message_prime = () ->
  # Scroll div
  $("#modal_message_conversation").scrollTop(document.getElementById("modal_message_conversation").scrollHeight);

  window.modal_spinner_prime()

window.modal_message_show = (friend_id) ->
  
  if !($("#modal_message").hasClass("in"))

    $(".modal").modal("hide")

    $.get "/notifications/modal_message_form?id=" + friend_id, (data) ->
      $("#modal_message").html data

      # Bless after modal 'shown' callback fires - prevents bless missing which was a big problem!
      $("#modal_message").on "shown", ->
        window.modal_message_prime()

      $("#modal_message").modal "show"




window.modal_post_show = () ->
  
  if !($("#modal_post").hasClass("in"))

    $(".modal").modal("hide")

    $("#modal_post").on "shown", ->
      window.modal_spinner_prime()

    $("#modal_post").modal "show"





window.modal_friendship_req_show = (friend_id) ->
  
  if !($("#modal_friendship_req").hasClass("in"))

    $(".modal").modal("hide")

    $.get "/contacts/modal_friendship_req_form?id=" + friend_id, (data) ->
      $("#modal_friendship_req").html data

      $("#modal_friendship_req").on "shown", ->
        window.modal_spinner_prime()

      $("#modal_friendship_req").modal "show"


      # repeat of modal spinner prime, but with online refresh command under submit
      $(".application_spinner_container").css "display","none"
      
      $(".application_submit_button_with_spinner").click ->
        $(".application_spinner_container").show()
        $(this).closest("form").submit()
        window.onlinepanels_refresh()




window.modal_event_new_show = (friend_id, book_id) ->

  if !($("#modal_event").hasClass("in"))
    $(".modal").modal("hide")

    if friend_id && !book_id
      url = "/events/new?friend_id=" + friend_id
    else if book_id && !friend_id
      url = "/events/new?book_id_usertoprepare=" + book_id
    else if friend_id && book_id
      url = "/events/new?friend_id=" + friend_id + "&book_id_usertoprepare=" + book_id
    else
      url = "/events/new"

    $.get url, (data) ->
      $("#modal_event").html data

      if friend_id
        $.get "/events/user_timezone?display_which=timezone&user_id=" + friend_id, (data) ->
          $("#events_new_friend_timezone").html data


      # to increase height of the modal (removed by new show)
      $("#modal_event").removeClass "event_edit"

      # Bless after modal 'shown' callback fires - prevents bless missing which was a big problem!
      $("#modal_event").on "shown", ->
        window.modal_events_rebless()

      $("#modal_event").modal("show")


window.modal_events_new_timezone_calcs = ->

  friend_id = $("#events_new_friend_select").val()
  datetime = $("#events_new_datetime_input").val()
  
  if friend_id > 0
    $.get "/events/user_timezone?display_which=timezone&user_id=" + friend_id, (data) ->
      $("#events_new_friend_timezone").html data
  else
    $("#events_new_friend_timezone").html("")

  if (friend_id > 0) && (datetime != "")
    $.get "/events/user_timezone?display_which=timeforfriend&user_id=" + friend_id+"&datetime="+datetime, (data) ->
      $("#events_new_datetime_friend").html data
  else
    $("#events_new_datetime_friend").html("")


window.modal_events_rebless = ->

  $("#events_new_datetime_picker").datetimepicker
    format: "dd M yyyy - hh:ii"
    minuteStep: 15
    pickerPosition: 'bottom-left'
    autoclose: true
    showMeridian: true
    startDate: $("#events_new_datetime_input").data "start_date"
    #startDate: "2013-07-07 10:00"


  $("#events_new_friend_select").change ->
    window.modal_events_new_timezone_calcs()

  $("#events_new_datetime_input").change ->
    window.modal_events_new_timezone_calcs()


  $("#events_new_book_select").change ->
    book_id = $(this).val()

    if book_id > 0
      $.get "/books/" + book_id + "/show_small", (data) ->
        $("#events_new_book_viewer_partnertoprepare").html data
    else
      $("#events_new_book_viewertoprepare").html "<div id=events_new_book_viewer_empty>No book selected</div>"

  window.modal_spinner_prime()





window.application_raty_prime = () ->
  
  $(".books_rating_read").raty
    readOnly: true
    # hints: ["Very Poor", "Poor", "OK", "Good", "Excellent"]
    score: ->
      return parseFloat $(this).data("rating")


window.application_profilepanel_toggle = () ->
  panel = $("#application_container_profilepanel")
  caret = $("#header_nav_links_right_name_caret i")

  if panel.hasClass "in"
    panel.hide "slide", direction: "up", 200
    caret.removeClass "icon-caret-up"
    caret.addClass "icon-caret-down"
    panel.removeClass "in"
  else
    panel.show "slide", direction: "up", 200
    caret.addClass "icon-caret-up"
    caret.removeClass "icon-caret-down"
    panel.addClass "in"


$(document).ready ->


  $("#header_nav_links_right_name").click ->
    window.application_profilepanel_toggle()

  # Jquery truncate
  window.application_truncatables()

  # Switch
  $("[data-toggle='switch']").wrap('<div class="switch" />').parent().bootstrapSwitch()

  # Chosen
  $(".chzn-select").chosen()
  $(".chzn-select-nosearch").chosen disable_search_threshold: 10
  $(".chzn-select-tags").chosen max_selected_options: 5

  # Style for the checkboxes
  # $("input:checkbox").uniform()

  # Tooltips on Avatars
  $(".application_avatar_icon").tooltip()

  # Tooltips throughout app
  $(".application_tooltip").tooltip()

  # Countchar
  $('.application_countchar').keyup ->
    window.application_countchar(this)

  # Placeholders
  $("input, textarea").placeholder()

  # Header search - only if not on map page
  if typeof map_index_map_lat_start is "undefined"
    $("#header_nav_search_form").on "submit", ->
      window.location.href = "/map?search=" + $("#header_nav_search_field").val()

  # Modals
  $("#modal_contact, #modal_message, #modal_post, #modal_friendship_req, #modal_event, #modal_help").modal
    backdrop: true
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
      $("#modal_help").modal "show", ->
        window.ArrowNav.goTo "1"

  # Modal contact link
  $("#header_link_contact").click ->
    if !($("#modal_contact").hasClass("in"))
      $(".modal").modal "hide"

      $("#modal_contact").on "shown", ->      
        window.modal_spinner_prime()

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

  # Click form errors to hide them
  $("#application_error_explanation").click ->
    $(this).fadeOut "fast"





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


