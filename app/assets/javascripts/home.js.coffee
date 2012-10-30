$(document).ready ->
  # Arrows for the home page
  if $(".arrownav_home").size() > 0
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