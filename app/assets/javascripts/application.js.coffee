#= require jquery
#= require jquery_ujs

#= require jquery.ui.slider
#= require jquery.effects.slide
#= require jquery.effects.core
#= require lib/jquery.placeholder
#= require lib/jquery.uniform.min
#= require lib/chosen.jquery

#= require lib/bootstrap.min
#= require lib/bootstrap-datepicker
#= require bootstrap-wysihtml5

#= require lib/markerclustererplus



# Get query params, global function

window.getQueryParams = (qs) ->
  qs = qs.split("+").join(" ")
  params = {}
  tokens = undefined
  re = /[?&]?([^=]+)=([^&]*)/g
  params[decodeURIComponent(tokens[1])] = decodeURIComponent(tokens[2])  while tokens = re.exec(qs)
  params



$(document).ready ->
  # Style for the checkboxes
  $("input:checkbox").uniform()

  # Placeholders
  $("input, textarea").placeholder()

  # Modal help
  $("#modal_help").modal
    backdrop: false
    show: false

  # Modal help link
  $("#header_link_help").click ->
    $(".modal").modal "hide"
    $("#modal_help").modal "show"

  # Modal bug
  $("#modal_bug").modal
    backdrop: false
    show: false

  # Modal bug link
  $("#header_link_bug").click ->
    $(".modal").modal "hide"
    $("#modal_bug").modal "show"

  # Modal contact
  $("#modal_contact").modal
    backdrop: false
    show: false

  # Modal contact link
  $("#footer_link_contact").click ->
    $(".modal").modal "hide"
    $("#modal_contact").modal "show"


  # Arrows for the home page and help
  if $(".arrownav_home").size() > 0 || $("#modal_help").size() > 0
    ArrowNav =
      init: ->
        $("a[href*=#]").click (e) ->
          e.preventDefault()
          ArrowNav.goTo $(this).attr("href").split("#")[1]  if $(this).attr("href").split("#")[1]

        @goTo "1"

      goTo: (page) ->
        next_page = $("#application_arrownav_page_" + page)
        nav_item = $("nav ul li a[href=#" + page + "]")
        $("nav ul li").removeClass "current"
        nav_item.parent().addClass "current"
        $(".arrownav_page").hide()
        $(".arrownav_page").removeClass "current"
        next_page.addClass "current"
        next_page.fadeIn 500
        ArrowNav.centerArrow nav_item

      centerArrow: (nav_item, animate) ->
        left_margin = (nav_item.parent().position().left + nav_item.parent().width()) + 24 - (nav_item.parent().width() / 2)
        unless animate is false
          $("nav .arrow").animate
            left: left_margin - 8
          , 500, ->
            $(this).show()

        else
          $("nav .arrow").css left: left_margin - 8

    ArrowNav.init()