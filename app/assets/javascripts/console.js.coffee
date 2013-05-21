# console_index_subnav_sendpdf_check = ->
#   # if ($("#console_index_subnav_select_books").val() != "") && ($("#console_index_subnav_select_friends").val() != "")
#   $("#console_index_subnav_button_sendpdf").removeClass "disabled"
#   $("#console_index_subnav_button_sendpdf").attr "disabled", "false"

$(document).ready ->

  $(".chzn-select").chosen()



  $("#console_index_subnav_select_books").change ->

    book = "/console/pdfjs?id=" + $(this).val()

    $("#console_index_pdfjs_iframe").attr "src", book

    # console_index_subnav_sendpdf_check



  $("#console_index_subnav_select_friends").change ->

    $.get "/cases/new?user_id=" + $(this).val(), (data) ->

    	$("#console_index_feedback_frame").html data

    # console_index_subnav_sendpdf_check
