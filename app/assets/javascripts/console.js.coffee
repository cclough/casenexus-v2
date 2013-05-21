$(document).ready ->

  $(".chzn-select").chosen()

  $("#console_index_subnav_select_books").change ->

    book = "/console/pdfjs?id=" + $(this).val()

    $("#console_index_pdfjs_iframe").attr "src", book

  $("#console_index_subnav_select_friends").change ->

    friend = "/cases/new?user_id=" + $(this).val()

    $("#console_index_feedback_iframe").attr "src", friend