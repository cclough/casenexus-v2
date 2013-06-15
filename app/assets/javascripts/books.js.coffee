$(document).ready ->

	$(".books_rating_read").raty
		readOnly: true
    	# hints: ["Very Poor", "Poor", "OK", "Good", "Excellent"]
		score: ->
			return parseFloat $(this).data("rating")

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


	# # Search submit
	# $("#books_index_books_form_searchfield").keypress (e) ->
 #  		@form.submit()  if e.which is 10 or e.which is 13