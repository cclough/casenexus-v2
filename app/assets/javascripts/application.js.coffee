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


$(document).ready ->
  # Style for the checkboxes
  $("input:checkbox").uniform()

  # Tooltips on Avatars
  $(".application_avatar_icon").tooltip()

  # Tooltips throughout app
  $(".application_tooltip").tooltip()

  # Modal help checkbox
  $("#modal_help_checkbox").on 'change', ->
    page_id = $(this).attr("data-page_id")
    user_id = $(this).attr("data-user_id")
    if !$(this).is(':checked')
      $.ajax("/members/" + user_id + "/show_help?act=uncheck&page_id=" + page_id, type: 'PUT')
    else
      $.ajax("/members/" + user_id + "/show_help?act=check&page_id=" + page_id, type: 'PUT')

  # Placeholders
  $("input, textarea").placeholder()

  # Header search - only if not on map page
  if typeof map_index_map_lat_start is "undefined"
    $("#header_nav_panel_browse_search_form").on "submit", ->
      window.location.href = "/map?search=" + $("#header_nav_panel_browse_search_field").val()

  # Modal help
  $("#modal_help").modal
    backdrop: false
    show: false

  # Modal help link
  $("#header_link_help").click ->
    if !($("#modal_help").hasClass("in"))
      $(".modal").modal "hide"
      $("#modal_help").modal "show"
      window.ArrowNav.goTo 1

  # Modal contact
  $("#modal_contact").modal
    backdrop: false
    show: false

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


  setTimeout ->
    $("#application_flash").fadeOut('fast');
  , 4000

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