# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



$(document).ready ->
  $(".questions_comment_button").click ->

    this_button = $(this)
    commentable_id = this_button.data("commentable_id")
    commentable_type = this_button.data("commentable_type")
    return_to_id = this_button.data("return_to_id")
    return_to_type = this_button.data("return_to_type")

    $.get "/comments/new?commentable_id="+commentable_id+"&commentable_type="+commentable_type, (data) ->
      this_button.after(data)
      this_button.remove()


  $("[name=\"answer[content]\"]").wysihtml5
    emphasis: true #Italics, bold, etc. Default true
    "font-styles": false #Font styling, e.g. h1, h2, etc. Default true
    link: false #Button to insert a link. Default true
    image: false #Button to insert an image. Default true