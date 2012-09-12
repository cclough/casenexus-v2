 $(document).ready(function(){



  // Hide stuff with the JavaScript. If JS is disabled, the form will still be useable.
  // NOTE:
  // Sometimes using the .hide(); function isn't as ideal as it uses display: none; 
  // which has problems with some screen readers. Applying a CSS class to kick it off the
  // screen is usually prefered, but since we will be UNhiding these as well, this works.

  $("#users_new_education_group_optional_1, #users_new_education_group_optional_2").hide();
  $("#users_new_experience_group_optional_1, #users_new_experience_group_optional_2").hide();

  // Reset form elements back to default values on page load
  // ... don't want browser remembering values like checked checkboxes in this case
  $("#submit_button").attr("disabled",true);


  $("#num_attendees").val('Please Choose');
  $("#step_2 input[type=radio]").each(function(){
    this.checked = false;
  });
  $("#rock").each(function(){
    this.checked = false;
  });
  

  // Fade out steps 2 and 3 until ready
  $("#users_new_form_panel_step_2, #users_new_form_panel_step_3").css({ opacity: 0.3 });








  $("#user_password_confirmation").keyup(function() {
    if ($('#user_password_confirmation').val() == $('#user_password').val()) {
      $("#users_new_form_panel_step_2").css({
        opacity: 1
      });
    } else {
      $("#users_new_form_panel_step_2").css({
        opacity: 0.3
      });
    };
  });









  var users_new_education_group_count = 1;

  $("#users_new_button_education_add").click(function() {

    if (users_new_education_group_count == 1) {
      $('#users_new_education_group_optional_1').slideDown();
      users_new_education_group_count = users_new_education_group_count + 1;
    } else if (users_new_education_group_count == 2) {
      $('#users_new_education_group_optional_2').slideDown();
      users_new_education_group_count = users_new_education_group_count + 1;
    }

  });

  $("#users_new_button_education_remove").click(function() {

    if (users_new_education_group_count == 2) {
      $('#users_new_education_group_optional_1').slideUp();
      users_new_education_group_count++;
    } else if (users_new_education_group_count == 3) {
      $('#users_new_education_group_optional_2').slideDown();
      users_new_education_group_count++;
    }

  });

  var users_new_experience_group_count = 1;

  $("#users_new_button_experience_add").click(function() {

    if (users_new_experience_group_count == 1) {
      $('#users_new_experience_group_optional_1').slideDown();
      users_new_experience_group_count++;
    } else if (users_new_experience_group_count == 2) {
      $('#users_new_experience_group_optional_2').slideDown();
      users_new_experience_group_count++;
    }

  });

  $("#users_new_button_experience_remove").click(function() {

    if (users_new_experience_group_count == 2) {
      $('#users_new_experience_group_optional_1').slideUp();
      users_new_experience_group_count++;
    } else if (users_new_experience_group_count == 3) {
      $('#users_new_experience_group_optional_2').slideDown();
      users_new_experience_group_count++;
    }

  });







  $("#user_accepts_tandc").click(function(){

    if (this.checked && (step1complete == true) && (step2complete == true) && (step3complete == true)) { // check entire form is complete
      $("#submit_button").attr("disabled",false);
    } else {
      $("#submit_button").attr("disabled",false);
    };

  });
























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


  $(".users_datepicker").datepicker();
  // Put '{dateFormat: 'dd/mm/yy'}' in brackets to anglify





  
  // Hide stuff with the JavaScript. If JS is disabled, the form will still be useable.
  // NOTE:
  // Sometimes using the .hide(); function isn't as ideal as it uses display: none; 
  // which has problems with some screen readers. Applying a CSS class to kick it off the
  // screen is usually prefered, but since we will be UNhiding these as well, this works.
  $(".name_wrap, #company_name_wrap, #special_accommodations_wrap").hide();

  // Reset form elements back to default values on page load
  // ... don't want browser remembering values like checked checkboxes in this case
  $("#submit_button").attr("disabled",true);
  $("#num_attendees").val('Please Choose');
  $("#step_2 input[type=radio]").each(function(){
    this.checked = false;
  });
  $("#rock").each(function(){
    this.checked = false;
  });
  



  // Fade out steps 2 and 3 until ready
  $("#step_2, #step_3").css({ opacity: 0.3 });





  $.stepTwoComplete_one = "not complete";
  $.stepTwoComplete_two = "not complete"; 
    
  // When a dropdown selection is made
  $("#num_attendees").change(function() {

    $(".name_wrap").slideUp().find("input").removeClass("active_name_field");

        var numAttendees = $("#num_attendees option:selected").text();
                
        for ( i=1; i<=numAttendees; i++ ) {
            $("#attendee_" + i + "_wrap").slideDown().find("input").addClass("active_name_field");
        }
                  
  });
  
  // Check completeness of fields quickly
  $(".name_input").keyup(function() {
  
    var all_complete = true;
        
    $(".active_name_field").each(function() {
      if ($(this).val() == '' ) {
        all_complete = false;
      };
    });
    
    if (all_complete) {
      $("#step_1")
        .animate({
          paddingBottom: 120
        })
        .css({
          "background-image": "url(images/check.png)",
          "background-position": "bottom center",
          "background-repeat": "no-repeat"
        });
      $("#step_2").css({
        opacity: 1
      });
      $("#step_2 legend").css({
        opacity: 1 // For dumb Internet Explorer
      });
    } else { // not complete
      $("#step_1")
        .animate({
          paddingBottom: 20
        })
        .css({
          "background-image": "none"
        });
    };
  });
  
  function stepTwoTest() {
    if (($.stepTwoComplete_one == "complete") && ($.stepTwoComplete_two == "complete")) {
      $("#step_2")
      .animate({
        paddingBottom: 120
      })
      .css({
        "background-image": "url(images/check.png)",
        "background-position": "bottom center",
        "background-repeat": "no-repeat"
      });
      $("#step_3").css({
        opacity: 1
      });
      $("#step_3 legend").css({
        opacity: 1 // For dumb Internet Explorer
      });
    }
  };
  
  $("#step_2 input[name=company_name_toggle_group]").click(function(){
    $.stepTwoComplete_one = "complete"; 
    if ($("#company_name_toggle_on:checked").val() == 'on') {
      $("#company_name_wrap").slideDown();
    } else {
      $("#company_name_wrap").slideUp();
    };
    stepTwoTest();
  });
  
  $("#step_2 input[name=special_accommodations_toggle]").click(function(){
    $.stepTwoComplete_two = "complete"; 
    if ($("#special_accommodations_toggle_on:checked").val() == 'on') {
      $("#special_accommodations_wrap").slideDown();
    } else {
      $("#special_accommodations_wrap").slideUp();
    };
    stepTwoTest();
  });
  


  $("#rock").click(function(){
    if (this.checked && $("#num_attendees option:selected").text() != 'Please Choose'
        && $.stepTwoComplete_one == 'complete' && $.stepTwoComplete_two == 'complete') {
        $("#submit_button").attr("disabled",false);
      } else {
        $("#submit_button").attr("disabled",true);
    }
  });



});