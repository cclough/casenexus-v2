

$(document).ready ->

  # Schedule button
  $(".books_index_books_item_schedule_button").click ->

    book_id = $(this).data("book_id")

    window.modal_event_new_show(null,book_id)

  # Set rate, for book#show
  $(".books_rating_set").raty
    targetType   : 'number'
    targetKeep   : true
    target: "#books_rating_set_field"


  # WHEN I PUT FUNCTIONS ABOVE, BELOW PRIME RATY IT DOESN"T WORK - SOMETHING BROKEN?

  window.books_item_prime_raty()






