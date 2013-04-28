# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



window.books_index_books_updatelist = ->
  $.get("/books", $("#books_index_books_form").serialize(), null, "script")
  false


window.books_init = () ->
	
	$(".books_rating_read").raty
		score: ->
			return parseInt $(this).data("rating")
		readOnly: true
		precision:true
		half:true

	# For book show! another way to do this?
	$(".books_rating_set").raty
		target: "#books_rating_set_field"
		#half: true
		targetType   : 'number'
		targetKeep   : true
		target: "#books_rating_set_field"


	$(".books_index_books_item_comments, .books_index_books_item_full_desc").click ->

		book_id = $(this).data("id")

		window.application_mode_switch("books", book_id)


	$("#books_index_books .application_pagination a").click ->
	  $.getScript this.href
	  false

  # List action Button->Radio link
  $(".books_index_books_form_button_type, .books_index_books_form_button_sort").click ->

    action = $(this).data("action")
    id = $(this).data("id")

    $("input[name=books_list_" + action + "]:eq(" + id + ")").prop "checked", "true"
    
    $(".books_index_books_form_button_" + action).removeClass "active"
    $(this).addClass "active"
    
    window.books_index_books_updatelist()

  # Update list of user when enter is pressed
  $("#books_index_books_form input").keypress (e) ->
    window.books_index_books_updatelist() if e.which is 13


