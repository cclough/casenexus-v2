// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.



/////////////////////////////////////////////////////////////////
///////////////////// GLOBAL FUNCTIONS //////////////////////////
/////////////////////////////////////////////////////////////////

function notifications_index_notifications_link () {
  var query = getQueryParams(document.location.search);
  // alert(query.foo);

  if (query.id) {

    $('#notifications_index_notifications_item_content_' + query.id).slideDown('fast');     

  }

}

/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

$(document).ready(function(){

/////////////////////////////////////////////////////////////////
//////////////////////////    CALLS    //////////////////////////
/////////////////////////////////////////////////////////////////


  notifications_index_notifications_link();


/////////////////////////////////////////////////////////////////
//////////////////////////// INDEX //////////////////////////////
/////////////////////////////////////////////////////////////////

  // Show content
  $('.notifications_index_notifications_item_button_expand').click(function() {

    var item_id = $(this).attr('data-id');

    var notification = $('#notifications_index_notifications_item_' + item_id)

    // Toggle Read

    notification.addClass('read');

    // Slide
   
    if (notification.hasClass('slid')) {

      $('#notifications_index_notifications_item_content_' + item_id).slideUp('fast'); 

      notification.removeClass('slid');
      notification.addClass('read');

    } else {

      $('#notifications_index_notifications_item_content_' + item_id).slideDown('fast');     

      notification.addClass('slid');
      notification.removeClass('read');
   }

  });

  $("#notifications_show_back").click(function() {
    history.go(-1);return false;
  });


// $('.notifications_index_notifications_item_button_history').click(function() {

//  var user_id = $(this).attr('data-id');

//   $.get("/notifications/" + user_id, function(data) {

//       $("#notifications_index_notifications").html(data); 

//   });

// });

// $('.notifications_index_notifications_item').hover(

//   function() {
//    if ($(this).hasClass('read')) {
//        $(this).stop().fadeTo('fast', 1);
//     }
//   },
//   function(){
//    if ($(this).hasClass('read')) {
//       $(this).stop().fadeTo('fast', 0.3);
//     }
//   }

// );


/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////






});