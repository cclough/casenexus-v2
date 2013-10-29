
window.modal_help_show = () ->
  if !($("#modal_help").hasClass("in"))
    $(".arrownav_page").hide()
    $(".modal").modal "hide"
    $("#modal_help").modal "show"
    $("#modal_help").on "shown", ->
      # window.ArrowNav.init()
      window.ArrowNav.goTo "1"



$(document).ready ->

  # Modal Help nav
  if $("#modal_help").size() > 0
    
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
        
        if $("#modal_help").size() > 0
          next_page.fadeIn 100

          # NEXT BUTTON - on last, change
          $('#modal_help_button_next').off('click');
          if page == "5"
            $("#modal_help_button_next").html("<i class=icon-check-5></i> Finish")
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

