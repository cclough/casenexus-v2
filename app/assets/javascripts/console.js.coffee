window.console_index_subnav_sendpdf_check = ->
  if ($("#console_index_subnav_select_books").val() != "") && ($("#console_index_subnav_select_friends").val() != "")
    $("#console_index_subnav_button_sendpdf").css("display", "inline")
  else
    $("#console_index_subnav_button_sendpdf").css("display", "none")

$(document).ready ->

	query = getQueryParams(document.location.search)

	if query.id != ""
		$.get "/cases/new?user_id=" + query.friend_id, (data) ->

			$("#console_index_feedback_frame").html data


  $(".chzn-select").chosen()

  $("#console_index_subnav_select_books").change ->

    book = "/console/pdfjs?id=" + $(this).val()

    $("#console_index_pdfjs_iframe").attr "src", book

    console_index_subnav_sendpdf_check()


  $("#console_index_subnav_select_friends").change ->

  	# change feedback form
    $.get "/cases/new?user_id=" + $(this).val(), (data) ->

    	$("#console_index_feedback_frame").html data

    # change skypebutton
    $.get "/console/skypebutton?friend_id=" + $(this).val(), (data) ->

    	$("#console_index_subnav_button_skype_container").html data

    console_index_subnav_sendpdf_check()
