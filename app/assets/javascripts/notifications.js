// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


// Update the User List - submits form...
function notifications_index_notifications_updatelist () {
  $.get($("#notifications_index_notifications_form").attr("action"), $("#notifications_index_notifications_form").serialize(), null, "script");
  return false;
}


$(document).ready(function(){


/////////////////////////////////////////////////////////////////
//////////////////////////// INDEX //////////////////////////////
/////////////////////////////////////////////////////////////////

  ///////// Filters

  $("#notifications_index_notifications_form input").keypress(function(e) {
    if(e.which == 13) {
      notifications_index_notifications_updatelist();
    }
  });

  // Listtype Button-Radio link
  $('.notifications_index_sidenav_item').click(function() {

    var listtype = this.id.split('_');

    $('input[name=notifications_listtype]:eq('+listtype[5]+')').attr('checked', 'checked');

    $('.notifications_index_sidenav_item').removeClass('active');

    $(this).addClass('active');

    notifications_index_notifications_updatelist();

  });


  // Ajax pagination
  $("#notifications_index_notifications .application_pagination a, #notifications_index_notifications_form_sort a").live("click", function() {
    $.getScript(this.href);
    return false;
  });



/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
//////////////////////////    CALLS    //////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

  notifications_index_notifications_updatelist();

/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

});