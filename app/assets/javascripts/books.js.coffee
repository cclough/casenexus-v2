$(document).ready ->

  window.books_item_prime_raty()

	# For book show! another way to do this?
	$(".books_rating_set").raty
		targetType   : 'number'
		targetKeep   : true
		target: "#books_rating_set_field"



	# List action Button->Radio link
	$(".books_index_books_form_button_type").click ->

	  action = $(this).data("action")
	  id = $(this).data("id")

	  $("input[name=books_list_" + action + "]:eq(" + id + ")").prop "checked", "true"
	  
	  $(".books_index_books_form_button_" + action).removeClass "active"
	  $(this).addClass "active"

	  $("#books_index_books_form").submit()



  $(".books_index_books_item_schedule_button").click ->

    book_id = $(this).data("book_id")

    window.modal_event_new_show(null,book_id)