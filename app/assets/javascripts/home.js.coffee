$(document).ready ->
  
  window.setTimeout(->

    $("#static_home_panels_left").fadeIn "slow"
    $("#static_home_panels_right").fadeIn "slow", ->

      # show page one
      $("#static_home_panels_left_page_1").show "slide", direction: "right", 500
      $("#static_home_panels_right_page_1").show "slide", direction: "right", 500, ->
        
        $("#static_home_panels_left_nav_circle_1").addClass "on_now"
        $("#static_home_panels_right_nav_circle_1").addClass "on_now"
        
        $("#static_home_panels_left_page_1 .static_home_panels_text").fadeIn "fast"
        $("#static_home_panels_right_page_1 .static_home_panels_text").fadeIn "fast"
        
        $(".static_home_panels_nav").fadeIn "slow"


        # slider start
        window.l = 1
        window.r = 1
        window.interval = setInterval(->
          $("#static_home_panels_left_page_" + window.l).hide "slide", direction: "left", 500
          $("#static_home_panels_right_page_" + window.r).hide "slide", direction: "left", 500, ->
            $("#static_home_panels_left_page_" + window.l + " .static_home_panels_text").fadeOut "fast"
            $("#static_home_panels_right_page_" + window.r + " .static_home_panels_text").fadeOut "fast"
            
            $("#static_home_panels_left_nav_circle_" + window.l).removeClass "on_now"
            $("#static_home_panels_right_nav_circle_" + window.r).removeClass "on_now"

            window.l++
            window.r++
            if window.l == 4
              window.l = 1
              window.r = 1

            $("#static_home_panels_left_nav_circle_" + window.l).addClass "on_now"
            $("#static_home_panels_right_nav_circle_" + window.r).addClass "on_now"

            $("#static_home_panels_left_page_" + window.l).show "slide", direction: "right", 500
            $("#static_home_panels_right_page_" + window.r).show "slide", direction: "right", 500, ->
              $("#static_home_panels_left_page_" + window.l + " .static_home_panels_text").fadeIn "fast"
              $("#static_home_panels_right_page_" + window.r + " .static_home_panels_text").fadeIn "fast"

              

        , 5000)

        # slider stop on mouseover
        $('#static_home_panels_left #static_home_panels_right').mouseover ->
          clearInterval(window.interval);
  , 1000)

  # Code for circle nav
  $(".static_home_panels_nav_circle").click ->

    clearInterval(window.interval)

    that = $(this)

    if !(that.hasClass("on_now"))

      panel = that.attr("data-panel")
      page_id = that.attr("data-page-id")

      if panel == "left"
        old_panel_var = window.l
        window.l = page_id
      else if panel == "right"
        old_panel_var = window.r
        window.r = page_id

      $("#static_home_panels_" + panel + "_nav_circle_" + old_panel_var).removeClass "on_now"
      $(that).addClass "on_now"

      $("#static_home_panels_" + panel + "_page_" + old_panel_var + " .static_home_panels_text").fadeOut "fast"
      $("#static_home_panels_" + panel + "_page_" + old_panel_var).hide "slide", direction: "left", 500, ->

        $("#static_home_panels_" + panel + "_page_" + page_id).show "slide", direction: "right", 500, ->
          $("#static_home_panels_" + panel + "_page_" + page_id + " .static_home_panels_text").fadeIn "fast"


  ######################### SIGNUP ############################

  $('#static_home_signup_option_university_notlisted_button').click ->
    if !($("#modal_contact").hasClass("in"))
      $(".modal").modal "hide"
      $("#modal_contact").modal "show"

  $('.chzn-select').chosen()
    # not really needed...
    #.change ->
    #$('#user_email').val("{your email}" + $(this).find('option:selected').val())
  $('.chzn-search').hide();

  $('#static_home_signup_option_linkedin_button').click ->
    $('#static_home_signup_option_university_button').removeClass('active');
    $('#static_home_signup_option_linkedin_button').addClass('active');
    $('#static_home_signup_option_university').slideUp "fast"
    $('#static_home_signup_option_university_submit').slideUp "fast"
    $('#static_home_signup_option_linkedin').slideDown "fast"
    $('#static_home_signup_option_linkedin_submit').slideDown "fast"

  $('#static_home_signup_option_university_button').click ->
    $('#static_home_signup_option_university_button').addClass('active');
    $('#static_home_signup_option_linkedin_button').removeClass('active');
    $('#static_home_signup_option_university').slideDown "fast"
    $('#static_home_signup_option_university_submit').slideDown "fast"
    $('#static_home_signup_option_linkedin').slideUp "fast"
    $('#static_home_signup_option_linkedin_submit').slideUp "fast"

  check_confirm_email = ->
    if !$('#user_confirm_tac').is(':checked')
      $("#static_home_signup_option_university_button_submit").attr('disabled', 'disabled')
    else
      $("#static_home_signup_option_university_button_submit").attr('disabled', false)

  check_confirm_linkedin = ->
    if $('#user_confirm_tac').is(':checked') && $('#confirm_linkedin').is(':checked')
      $("#static_home_signup_option_linkedin_button_submit").attr('disabled', false)
    else
      $("#static_home_signup_option_linkedin_button_submit").attr('disabled', 'disabled')

  check_confirm_email()
  check_confirm_linkedin()

  $("#user_confirm_tac").click ->
    check_confirm_email()
    check_confirm_linkedin()

  $("#confirm_linkedin").click ->
    check_confirm_linkedin()

  $("#static_home_signup_option_linkedin_button_submit, #static_home_signup_option_linkedin_button_submit img, #static_home_signup_option_linkedin_button_submit span").click (e) ->
    if $("#static_home_signup_option_linkedin_button_submit").attr('disabled') == 'disabled'
      e.preventDefault()