$(document).ready(function(){



////////////////////////////////////////////////////////////////////
/////////////////////////    NEW     ///////////////////////////////
////////////////////////////////////////////////////////////////////


  // $("#users_new_education_group_optional_1, #users_new_education_group_optional_2").hide();
  // $("#users_new_experience_group_optional_1, #users_new_experience_group_optional_2").hide();

  $("input[type=submit]").attr("disabled",true);
  $('#user_accepts_tandc').attr('checked', false);

  // reset form here?

  $("#users_new_step2, #users_new_step_3").css({ opacity: 0.3 });


  $("#user_password_confirmation").keyup(function() {
    if ($('#user_password_confirmation').val() == $('#user_password').val()) {
      $("#users_new_step2").css({
        opacity: 1
      });
      $.users_new_step1_complete = true;
    } else {
      $("#users_new_step2").css({
        opacity: 0.3
      });
    };
  });


  function users_new_step2_test() {
    if (($.users_new_step1_complete_1 == "complete") && ($.users_new_step1_complete_2 == "complete") && ($.users_new_step1_complete_3 == "complete")) {
      
      $("#users_new_step2")
      .css({
        "background-image": "url(app/tick.png)",
        "background-position": "top right",
        "background-repeat": "no-repeat"
      });
      
      $("#users_new_step3").css({
        opacity: 1
      });

      $.users_new_step2_complete = true;
    }
  };
  
  $("#users_new_status").keyup(function(){
    $.users_new_step1_complete_1 = "complete"; 
    users_new_step2_test();
  });
  
  $("#user_education1").keyup(function(){
    $.users_new_step1_complete_2 = "complete"; 
    users_new_step2_test();
  });

  $("#user_experience1").keyup(function(){
    $.users_new_step1_complete_3 = "complete"; 
    users_new_step2_test();
  });


  $("#user_accepts_tandc").click(function(){

    $.step3complete = true;

    if (this.checked && ($.users_new_step1_complete == true) && ($.users_new_step2_complete == true) && ($.users_new_step3_complete == true)) { // check entire form is complete
      $("input[type=submit]").attr("disabled",false);
    } else {
      $("input[type=submit]").attr("disabled",true);
    };

  });



////////////////////////////////////////////////////////////////////
///////////////////////    NEW & EDIT     //////////////////////////
////////////////////////////////////////////////////////////////////

  // Map Load
  $('#users_new_map,#users_edit_map').gmap({

      'zoom': 12,
      'center': new google.maps.LatLng(lat_start, lng_start),
      'mapTypeId': google.maps.MapTypeId.ROADMAP,
      'streetViewControl': false,
      'mapTypeControl': false

  }).bind('init', function(ev, map) {

    $('#users_new_map,#users_edit_map').gmap('addMarker', {
        'position': new google.maps.LatLng(lat_start, lng_start),
        'bounds': false,
        'draggable': true
    }).drag(function() {
      document.getElementById('lat').value = this.position.lat();
      document.getElementById('lng').value = this.position.lng();    
    });

  });




////////////////////////////////////////////////////////////////////
////////////////////////    INDEX    ///////////////////////////////
////////////////////////////////////////////////////////////////////





 // List populate on page load
  updatelist();

  // Update the User List - submits form...
  function updatelist () {
    $.get($("#users_index_users_form").attr("action"), $("#users_index_users_form").serialize(), null, "script");
    return false;
  }

  // List populate on search field change
  $("#users_index_users_form input").keyup(function() {
    updatelist();
  });

  // List populate on change radio buttons in filter
  $("input[name=users_listtype]").change(function () {
    updatelist();
  });

  // Ajax pagination
  $("#users_index_users .nexus_pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });




  // Map Load
  $('#users_index_map').gmap({

    'center': new google.maps.LatLng(lat_start, lng_start),
    'zoom': 14,
    'mapTypeId': 'roadmap', // option: terrain
    'disableDefaultUI': true,
    'zoomControl': true,
    'zoomControlOptions': {
        position: google.maps.ControlPosition.LEFT_CENTER
    },
    'callback': function(map) {

      // custom control position hack - http://stackoverflow.com/questions/2934269/google-maps-api-v3-custom-controls-position
      $(map).addEventListener('tilesloaded', function() {
        
          if($('#users_index_map_zoomcontrol').length==0){
              $('div.gmnoprint').last().parent().wrap('<div id="users_index_map_zoomcontrol" />');
              $('div.gmnoprint').fadeIn(500);
          }

      });

    }

  }).bind('init', function() { 

    var shadow = new google.maps.MarkerImage('http://www.casenexus.com/images/markers/mark_shadow.png',
        new google.maps.Size(62.0, 62.0),
        new google.maps.Point(0, 0),
        new google.maps.Point(15.0, 62.0)
        );
    
    $.getJSON('users', function(json) { 

      $.each( json, function(i, marker) {

        $('#users_index_map').gmap('addMarker', {

          'id': marker.id,
          'position': new google.maps.LatLng(marker.lat, marker.lng), 
          'bounds': false,
          'shadow': shadow,
          'animation': google.maps.Animation.DROP,
          'icon': 'http://www.casenexus.com/images/markers/mark_god.png'

        }).click(function() {

          //// panTo & Zoom
          newlatlng = this.getPosition();
          $(this).get(0).map.panTo(newlatlng);
          $(this).get(0).map.setZoom(10);

          //// Animate
          // Start Bounce
          this.setAnimation(google.maps.Animation.BOUNCE);

          // Stop Bounce
          var that = this; // <- Cache the item (no idea why this is needed)
          setTimeout(function () {
            that.setAnimation(null);
          }, 1400);

          //// Hide, reload and show User Panel
          $("#users_index_mapcontainer_user").fadeOut('slow', function() {

            $.get('/users/' + marker.id, function(data) {

              // Insert ajax data!
              $('#users_index_user').html(data);

              // Fade panel back in
              $("#users_index_mapcontainer_user").fadeIn('slow');


              // Code for 'close button' - needs to be here otherwise not applied in time
              $("#users_show_close").click(function() {
                $('#users_index_mapcontainer_user').fadeOut('slow');
              });


              // Modal Stuff!
              $('#modal_message').modal({
                backdrop: false,
                show: false
              });

              $('#modal_feedback_req').modal({
                backdrop: false,
                show: false
              });

              // message button click, hides other modal
              // not using TBS data-toggle etc. as doesn't let you hide others
              $('#users_index_user_button_message').click(function() {
                $('#modal_message').modal('show');
                $('#modal_feedback_req').modal('hide')
              });

              $('#users_index_user_button_feedback_req').click(function() {
                $('#modal_message').modal('hide');
                $('#modal_feedback_req').modal('show')
              });

              $("#modal_feedback_req_datepicker").datepicker();

            });

          });

        });
        
      });

    });

  });




////////////////////////////////////////////////////////////////////
///////////////////////////    ALL    //////////////////////////////
////////////////////////////////////////////////////////////////////

  $(".users_datepicker").datepicker();
  // Put '{dateFormat: 'dd/mm/yy'}' in brackets to anglify


});