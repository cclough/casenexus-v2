$(document).ready(function(){



////////////////////////////////////////////////////////////////////
/////////////////////////    NEW     ///////////////////////////////
////////////////////////////////////////////////////////////////////


  // $("#users_new_education_group_optional_1, #users_new_education_group_optional_2").hide();
  // $("#users_new_experience_group_optional_1, #users_new_experience_group_optional_2").hide();

  $("#users_new_button_submit").attr("disabled",true);
  $('#user_accepts_tandc').attr('checked', false);

  // reset form here?

  $("#users_new_step2, #users_new_step3").css({ opacity: 0.3 });


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
      $("#users_new_button_submit").attr("disabled",false);
    } else {
      $("#users_new_button_submit").attr("disabled",true);
    };

  });



////////////////////////////////////////////////////////////////////
/////////////////////////// NEW & EDIT /////////////////////////////
////////////////////////////////////////////////////////////////////


  function users_newedit_loadmap(users_map_lat_start, users_map_lng_start) {

    var users_newedit_latlng = new google.maps.LatLng(users_map_lat_start, users_map_lng_start)

    var map = new google.maps.Map(document.getElementById('users_newedit_map'), {
      // zoomed right out
      zoom: 12,
      center: users_newedit_latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      streetViewControl: false,
      mapTypeControl: false
    });

    var marker = new google.maps.Marker({
      position: users_newedit_latlng,
      map: map,
      draggable: true
    });
  
    google.maps.event.addListener(marker, 'drag', function() {
      $('lat').val(users_newedit_latlng.lat());
      $('lng').val(users_newedit_latlng.lng());
    });

  }



////////////////////////////////////////////////////////////////////
////////////////////////    INDEX    ///////////////////////////////
////////////////////////////////////////////////////////////////////


  // Update the User List - submits form...
  function users_updatelist () {
    $.get($("#users_index_users_form").attr("action"), $("#users_index_users_form").serialize(), null, "script");
    return false;
  }

  // List populate on search field change
  $("#users_index_users_form input").keyup(function() {
    users_updatelist();
  });

  // List populate on change radio buttons in filter
  $("input[name=users_listtype]").change(function () {
    users_updatelist();
  });

  // Ajax pagination
  $("#users_index_users .nexus_pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });




  // Map

  var users_index_map_markers = [];

  var users_index_customMarkers = {
    Beginner: {
      icon: '/app/assets/images/markers/mark_novice.png'
    },
    Novice: {
      icon: '/app/assets/images/markers/mark_novice.png'
    },
    Intermediate: {
      icon: 'c/assets/images/markers/mark_intermediate.png'
    },
    Advanced: {
      icon: '/assets/images/markers/mark_advanced.png'
    },
    God: {
      icon: '/assets/images/markers/mark_god.png'
    },
    'Victor Cheng-like': {
      icon: '/assets/images/markers/mark_victorchenglike.png'
    }
  };



  function users_index_loadmap(users_map_lat_start, users_map_lng_start) {

    var mapOptions = {
      center: new google.maps.LatLng(users_map_lat_start, users_map_lng_start),
      zoom: 14,
      mapTypeId: 'roadmap', // option: terrain
      disableDefaultUI: true,
      zoomControl: true,
      zoomControlOptions: {
          position: google.maps.ControlPosition.LEFT_CENTER
      }
    };

    
    var map = new google.maps.Map(document.getElementById("users_index_map"), mapOptions);

    // Zoom Control Position Hack
    google.maps.event.addDomListener(map, 'tilesloaded', function(){
      // We only want to wrap once!
      if($('#users_index_map_zoomcontrol').length==0){
          $('div.gmnoprint').last().parent().wrap('<div id="users_index_map_zoomcontrol" />');
          $('div.gmnoprint').fadeIn(500);
      }
    });

    // Draw markers
    var shadow = new google.maps.MarkerImage('http://www.casenexus.com/images/markers/mark_shadow.png',
      new google.maps.Size(62.0, 62.0),
      new google.maps.Point(0, 0),
      new google.maps.Point(15.0, 62.0)
    );

    $.getJSON("users", function(json) {

      $.each(json, function(i, marker) {

        //var icon = users_index_customMarkers[json[i].level] || {};
        var marker = new google.maps.Marker({
          id: marker.id,
          map: map,
          position: new google.maps.LatLng(parseFloat(marker.lat),parseFloat(marker.lng)),
          //icon: icon.icon,
          icon: 'http://www.casenexus.com/images/markers/mark_god.png',
          shadow: shadow,
          animation: google.maps.Animation.DROP
        });

        users_index_map_marker_bind(marker, map);
        users_index_map_markers[marker.id] = marker;
          
      });

    });

    var markerCluster = new MarkerClusterer(map, users_index_map_markers);

  }

  function users_index_map_marker_bind(marker, map) {

    // google.maps.event.addListener(marker, 'mouseover', function() {
    //   //showInSmallPanel(uid);
    // });

    google.maps.event.addListener(marker, 'click', function() {

      // Pan, Zoom, Animate
      newlatlng = marker.getPosition();
      map.panTo(newlatlng);
      map.setZoom(5);

      marker.setAnimation(google.maps.Animation.BOUNCE);
      setTimeout(function(){ marker.setAnimation(null); }, 700);

      // Show User Panel

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
          $('#modal_message, #modal_feedback_req, #modal_friend_req').modal({
            backdrop: false,
            show: false
          });

          // message button click, hides other modal
          // not using TBS data-toggle etc. as doesn't let you hide others
          $('#users_index_user_button_message').click(function() {
            $('.modal').modal('hide');
            $('#modal_message').modal('show');
          });

          $('#users_index_user_button_friend_req').click(function() {
            $('.modal').modal('hide');
            $('#modal_friend_req').modal('show')
          });

          $('#users_index_user_button_feedback_req').click(function() {
            $('.modal').modal('hide');
            $('#modal_feedback_req').modal('show')
          });

          $("#modal_feedback_req_datepicker").datepicker();

        });

      });

    });

  }

////////////////////////////////////////////////////////////////////
///////////////////////////    ALL    //////////////////////////////
////////////////////////////////////////////////////////////////////

  $(".users_datepicker").datepicker();
  // Put '{dateFormat: 'dd/mm/yy'}' in brackets to anglify



  function users_getlatlng (callback) {

    $.getJSON("/getlatlng", function(json) {

      if ((!json.lat) && (!json.lng)) {
        callback(52.2100,0.1300);
      } else {
        callback(json.lat, json.lng);
      }

    });
    
  }




////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
//////////////////////////    CALLS    /////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////



  // why do I have to call the json twice?
  users_getlatlng(function(users_map_lat_start, users_map_lng_start) {
    users_index_loadmap(users_map_lat_start, users_map_lng_start);
  });

  users_getlatlng(function(users_map_lat_start, users_map_lng_start) {
    users_newedit_loadmap(users_map_lat_start, users_map_lng_start);
  });

  users_updatelist();






});