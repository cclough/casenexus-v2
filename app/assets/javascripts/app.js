$(document).ready(function(){

	$("select, input:checkbox").uniform();

	$('input, textarea').placeholder();


  $('#modal_help').modal({
    backdrop: false,
    show: false
  });

  $('#header_link_help').click(function() {
    $('.modal').modal('show');
  });

});