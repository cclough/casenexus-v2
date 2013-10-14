#= require jquery
#= require jquery_ujs
#= require jquery.ui.effect-slide
#= require jquery.ui.effect
#= require jquery.ui.widget
#= require jquery.ui.accordion
#= require lib/jquery.raty
#= require lib/jquery.titlealert
#= require lib/jquery.truncate
#= require lib/jquery.placeholder
#= require lib/jquery.uniform
#= require lib/chosen.jquery

#= require lib/bootstrap.min
#= require lib/bootstrap-clickover
#= require lib/bootstrap-datetimepicker
#= require bootstrap-wysihtml5
#= require lib/bootstrap-select
#= require lib/bootstrap-switch
#= require lib/flatui-checkbox
#= require lib/flatui-radio

#= require account
#= require books
#= require cases
#= require console
#= require events
#= require map
#= require notifications
#= require profile
#= require questions
#= require static_pages
#= require votes

#= require lib/pusher
#= require lib/amcharts
#= require lib/dragdealer
#= require lib/mapbox


# Get query params, global function


window.modal_help_show = () ->
  if !($("#modal_help").hasClass("in"))
    $(".arrownav_page").hide()
    $(".modal").modal "hide"
    $("#modal_help").modal "show"
    $("#modal_help").on "shown", ->
      # window.ArrowNav.init()
      window.ArrowNav.goTo "1"


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



window.application_countchar = (val) ->
  len = val.value.length
  if len >= 500
    val.value = val.value.substring(0, 500)
    val.parent("div").find(".application_countchar_count").text 0
  else
    val.parent("div").find(".application_countchar_count").text 500 - len
  



window.application_spinner_prime = (container) ->

  # unbind the click (cause of event duplication bug)
  $(container + " .application_submit_button_with_spinner").off 'click'

  $(container + " .application_spinner_container").hide()

  # SUBMIT CLICK: Submit button loading animation and submit button prime
  $(container + " .application_submit_button_with_spinner").click ->

    $(this).closest("form").submit()
    $(container + " .application_spinner_container").show()


window.application_disablesubmit_prime = (container) ->
  
  # unbind the click (cause of event duplication bug)
  # $(container + " .application_submit_button_with_disable").off 'click'

  $(container + " .application_submit_button_with_disable").removeClass "disabled"

  # SUBMIT CLICK: Submit button loading animation and submit button prime
  $(container + " .application_submit_button_with_disable").click ->
    $(container + " .application_submit_button_with_disable").addClass "disabled"
    $(container + " .application_submit_button_with_disable").off 'click'
    $(this).closest("form").submit() # stops addclass on safari for some reason




window.modal_contact_show = () ->
  if !($("#modal_contact").hasClass("in"))

    # clear out inputs and textareas
    $("#modal_contact input, #modal_contact textarea").val ""

    $(".modal").modal "hide"

    $("#modal_contact").on "shown", ->      
      window.application_spinner_prime(".modal.in")

    $("#modal_contact").modal "show"


window.modal_message_prime = () ->
  # Scroll div
  $(".modal.in #modal_message_conversation").scrollTop($(".modal.in #modal_message_conversation").prop("scrollHeight"));

  window.application_spinner_prime(".modal.in")

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


      window.application_spinner_prime(".modal.in")


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
          $("#events_modal_friend_timezone").html data


      # to increase height of the modal (removed by new show)
      $("#modal_event").removeClass "event_edit"

      # Bless after modal 'shown' callback fires - prevents bless missing which was a big problem!
      $("#modal_event").on "shown", ->
        window.modal_events_rebless()

      $("#modal_event").modal("show")


window.modal_events_modal_timezone_calcs = ->

  friend_id = $("#events_modal_friend_select").val()
  datetime = $("#events_modal_datetime_input").val()
  
  if friend_id > 0
    $.get "/events/user_timezone?display_which=timezone&user_id=" + friend_id, (data) ->
      $("#events_modal_friend_timezone").html data
  else
    $("#events_modal_friend_timezone").html("")

  if (friend_id > 0) && (datetime != "")
    $.get "/events/user_timezone?display_which=timeforfriend&user_id=" + friend_id + "&datetime=" + datetime, (data) ->
      $("#events_modal_datetime_friend").html data
  else
    $("#events_modal_datetime_friend").html("")


window.modal_events_rebless = ->

  $("#events_modal_datetime_picker").datetimepicker
    format: "dd M yyyy @ hh:ii"
    minuteStep: 15
    pickerPosition: 'bottom-left'
    autoclose: true
    showMeridian: true
    startDate: $("#events_modal_datetime_input").data "start_date"
    #startDate: "2013-07-07 10:00"


  $("#events_modal_friend_select").change ->
    window.modal_events_modal_timezone_calcs()

  $("#events_modal_datetime_input").change ->
    window.modal_events_modal_timezone_calcs()


  $("#events_modal_book_select").change ->
    book_id = $(this).val()

    if book_id > 0
      $.get "/books/" + book_id + "/show_small", (data) ->
        $("#events_modal_book_viewer_partnertoprepare").html data
    else
      $("#events_modal_book_viewertoprepare").html "<div id=events_modal_book_viewer_empty>No book selected</div>"

  window.application_spinner_prime(".modal.in")





window.application_raty_prime = () ->
  
  $(".books_rating_read").raty
    readOnly: true
    # hints: ["Very Poor", "Poor", "OK", "Good", "Excellent"]
    score: ->
      return parseFloat $(this).data("rating")




$(document).ready ->


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

  # Tooltips throughout app
  $(".application_tooltip").tooltip()

  # Countchar
  $('.application_countchar').keyup ->
    window.application_countchar(this)

  # Placeholders
  $("input, textarea").placeholder()

  # # Header search - only if not on map page
  # if typeof map_index_map_lat_start is "undefined"
  #   $("#header_nav_search_form").on "submit", ->
  #     window.location.href = "/map?search=" + $("#header_nav_search_field").val()

  # Modals
  $("#modal_contact, #modal_cases, #modal_profile, #modal_message, #modal_friendship_req, #modal_event").modal
    backdrop: false
    show: false

  $("#modal_help").modal
    backdrop:true
    show:false

  # Help modal show
  $("#header_link_help").click ->
    window.modal_help_show()

  # Contact modal show 
  $("#header_link_contact").click ->
    window.modal_contact_show()



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
  window.application_form_errors_close();




  # Arrows for the home page and help
  if $("#modal_help_arrownav").size() > 0
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
          next_page.fadeIn 100

          # NEXT BUTTON - on last, change
          $('#modal_help_button_next').off('click');
          if page == "5"
            $("#modal_help_button_next").html("Finish")
            $("#modal_help_button_skip").hide()
            $("#modal_help_button_next").click ->
              $("#modal_help").modal('hide')
          else
            $("#modal_help_button_next").html("Next")
            if page == "1"
              $("#modal_help_button_prev").hide()
            else
              $("#modal_help_button_prev").show()
            $("#modal_help_button_skip").show()
            $("#modal_help_button_next").click ->
              window.ArrowNav.goTo String(parseInt(page) + 1)     
          
          # PREVIOUS BUTTON
          $('#modal_help_button_prev').off('click');
          $("#modal_help_button_prev").click ->
            window.ArrowNav.goTo String(parseInt(page) - 1)    

          # PAGE NUM
          $("#modal_help_page_num").html("Part " + page + " of 5")

        else
          next_page.show "slide", direction: "right", 100

        window.ArrowNav.centerArrow nav_item

      centerArrow: (nav_item, animate) ->
        left_margin = (nav_item.parent().position().left + nav_item.parent().width()) + 24 - (nav_item.parent().width() / 2)
        unless animate is false
          $("nav .arrow").animate
            left: left_margin - 8
          , 100, ->
            $(this).show()

        else
          $("nav .arrow").css left: left_margin - 8

    # window.ArrowNav.init()


  # FILTER SLIDERS
  if $(".application_filtergroup_choicenav").size() > 0

    window.ChoiceNav =
      init: ->

        $("li[href*=#]").click (e) ->
          e.preventDefault()
          filter_name = $(this).closest(".application_filtergroup_choicenav").attr "data-filter_name"
          window.ChoiceNav.goTo $(this).attr("href").split("#")[1], filter_name if $(this).attr("href").split("#")[1]
        # @goTo "1"
      goTo: (page, filter_name) ->
        filter_name_complete = "#application_filtergroup_choicenav_" + filter_name
        nav_item = $(filter_name_complete + " nav ul li[href=#" + page + "]")

        btype = $(nav_item).data "btype"
        $("#books_filter_" + filter_name).val btype

        window.ChoiceNav.centerArrow nav_item, filter_name_complete
        window.ChoiceNav.growLine nav_item, filter_name_complete
      
      centerArrow: (nav_item, filter_name) ->
        left_margin = (nav_item.position().left + nav_item.width()/2) + 22 - (nav_item.width() / 2)
        $(filter_name + " nav .arrow").animate
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

