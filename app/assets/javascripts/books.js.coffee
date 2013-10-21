# Update the User List - submits form...
window.books_index_books_updatelist = ->
  $.get "/books", $("#books_index_form").serialize(), null, "script"
  false

window.books_index_books_item_prime = ->

  # Schedule button
  $(".books_index_books_item_event_button").click ->

    book_id = $(this).data("book_id")
    window.modal_event_new_show(null,book_id)

  # Ajax pagination
  $("#books_index_books .pagination a").click ->
    $.getScript @href
    false

  # Set rate, for book#show
  $(".books_rating_set").raty
    targetType   : 'number'
    targetKeep   : true
    target: "#books_rating_set_field"

  # WHEN I PUT FUNCTIONS ABOVE, BELOW PRIME RATY IT DOESN"T WORK - SOMETHING BROKEN?
  window.application_raty_prime()




$(document).ready ->

  if $("#books_show_comments_form_container").size() > 0
    window.books_index_books_item_prime()

  # update list on load
  if $("#books_index_form").size() > 0
    window.books_index_books_updatelist()

  # Direction of sort
  $("#books_index_form_filters_sort_direction_button").click ->
    
    if $("#books_filter_sort_direction").val "asc"
      $("#books_filter_sort_direction").val "desc"
      $(this).html "Descending <i class=icon-arrow-down></i>"
      window.books_index_books_updatelist()
    
    if $("#books_filter_sort_direction").val "desc"
      $("#books_filter_sort_direction").val "asc"
      $(this).html "Ascending <i class=icon-arrow-up></i>"
      window.books_index_books_updatelist()

  # Tag Select click
  $(".books_index_form_fitlers_tag_selector_item").click ->
    tag_id = $(this).data "tag_id"

    $("#books_filter_tag").val tag_id
    $(".books_index_form_fitlers_tag_selector_item").removeClass "books_index_form_fitlers_tag_selector_item_active"
    $(this).addClass "books_index_form_fitlers_tag_selector_item_active"

    window.books_index_books_updatelist()
