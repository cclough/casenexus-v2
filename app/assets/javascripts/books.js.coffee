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

  # Tooltips
  $(".application_tooltip").tooltip()
  
  # WHEN I PUT FUNCTIONS ABOVE, BELOW PRIME RATY IT DOESN"T WORK - SOMETHING BROKEN?
  window.application_raty_prime()




$(document).ready ->

  # Scroller
  $('#books_index_form_filters_tag_selector').slimscroll
    height: '300px'
    width: '240px'

  if $("#books_show_comments_form_container").size() > 0
    window.books_index_books_item_prime()

  # update list on load
  if $("#books_index_form").size() > 0
    window.books_index_books_updatelist()

  # Direction of sort
  $("#books_index_form_filters_sort_direction_button").click ->
    
    if $("#books_filter_sort_direction").val() == "asc"
      $("#books_filter_sort_direction").val("desc")
      $("#books_index_form_filters_sort_direction_button").html "Descending <i class=icon-arrow-1-down></i>"
      window.books_index_books_updatelist()
    
    else if $("#books_filter_sort_direction").val() == "desc"
      $("#books_filter_sort_direction").val("asc")
      $("#books_index_form_filters_sort_direction_button").html "Ascending <i class=icon-arrow-1-up></i>"
      window.books_index_books_updatelist()


  # Tag Select click for form
  $("#books_index_form_filters_selector_tag .books_index_form_fitlers_selector_item").click ->
    tag_id = $(this).data "tag_id"

    $("#books_filter_tag").val tag_id
    $(".books_index_form_fitlers_selector_item").removeClass "books_index_form_fitlers_selector_item_active"
    $(this).addClass "books_index_form_fitlers_selector_item_active"

    window.books_index_books_updatelist()

  $("#books_index_form_filters_selector_difficulty .books_index_form_fitlers_selector_item").click ->
    difficulty_id = $(this).data "difficulty_id"

    $("#books_filter_difficulty").val difficulty_id
    $(".books_index_form_fitlers_selector_item").removeClass "books_index_form_fitlers_selector_item_active"
    $(this).addClass "books_index_form_fitlers_selector_item_active"

    window.books_index_books_updatelist()



  # SHOW - comment edit
  $(".books_show_comment_edit_button").click ->

    this_button = $(this)
    comment_id = this_button.data("comment_id")
    
    $.get "/comments/"+comment_id+"/edit", (data) ->
      this_button.parent().parent().parent().html(data)
      this_button.parent().parent().hide()
