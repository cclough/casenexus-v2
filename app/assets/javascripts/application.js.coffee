#= require jquery
#= require jquery_ujs

#= require jquery.ui.slider
#= require jquery.effects.slide
#= require jquery.effects.core
#= require lib/jquery.placeholder
#= require lib/jquery.uniform.min
#= require lib/chosen.jquery

#= require lib/bootstrap.min
#= require lib/bootstrap-datepicker
#= require bootstrap-wysihtml5

#= require lib/markerclustererplus



# Get query params, global function
getQueryParams = (qs) ->
  qs = qs.split("+").join(" ")
  params = {}
  tokens = undefined
  re = /[?&]?([^=]+)=([^&]*)/g
  params[decodeURIComponent(tokens[1])] = decodeURIComponent(tokens[2])  while tokens = re.exec(qs)
  params



$(document).ready ->
  # Style for the checkboxes
  $("input:checkbox").uniform()

  # Placeholders
  $("input, textarea").placeholder()

  # Modal help
  $("#modal_help").modal
    backdrop: false
    show: false

  # Modal help
  $("#header_link_help").click ->
    $(".modal").modal "hide"
    $("#modal_help").modal "show"

