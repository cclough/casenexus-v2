
$(document).ready ->


  # Modal Help nav
  if $("#account_complete_panel").size() > 0
    
    window.ArrowNav =
      init: ->
        $("a[href*=#]").click (e) ->
          e.preventDefault()
          window.ArrowNav.goTo $(this).attr("href").split("#")[1]  if $(this).attr("href").split("#")[1]
        
      goTo: (page) ->
        next_page = $("#application_arrownav_page_" + page)
        nav_item = $("nav ul li a[href=#" + page + "]")
        $("nav ul li").removeClass "current"
        nav_item.parent().addClass "current"
        $(".arrownav_page").hide()
        $(".arrownav_page").removeClass "current"
        next_page.addClass "current"
        
        next_page.fadeIn 100

        # NEXT BUTTON - on last, change
        $('#account_complete_panel_nav_arrow_right').off('click');
        if page == "9"
          $("#account_complete_panel_nav_arrow_right").hide()
          $("#account_complete_panel_nav_arrow_right").click ->
            $(window.location.replace("/"))
        else
          $("#account_complete_panel_nav_arrow_right").show()
          if page == "1"
            $("#account_complete_panel_nav_arrow_left").hide()
          else
            $("#account_complete_panel_nav_arrow_left").show()

          $("#account_complete_panel_nav_arrow_right").off 'click'
          $("#account_complete_panel_nav_arrow_right").click ->
 
            if page == "2"
              $(".application_spinner_container").show()
              $("#account_complete_form_info").submit()
            else if page == "5"
              $(".application_spinner_container").show()
              $("#account_complete_form_timezone").submit()
            else if page == "6"   
              $(".application_spinner_container").show()
              $("#account_complete_form_skype").submit()
            else
              window.ArrowNav.goTo String(parseInt(page) + 1)

        # PREVIOUS BUTTON
        $('#account_complete_panel_nav_arrow_left').off('click');
        $("#account_complete_panel_nav_arrow_left").click ->
          window.ArrowNav.goTo String(parseInt(page) - 1)    

        # PAGE NUM
        $("#modal_help_page_num").html("Part " + page + " of 8")

    window.ArrowNav.goTo "3"
