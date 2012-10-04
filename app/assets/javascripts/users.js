// Marker array var needs to be declared here, so that users list item click works

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
/////////////////////////    GLOBALS    ////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////


var users_index_map_markers = [];

var markerClusterer = null;

var map = null;


function users_index_map_marker_click (marker_id) {

  // Show User Panel
  $("#users_index_mapcontainer_user").fadeOut('fast', function() {

    $.get('/users/' + marker_id, function(data) {

      // Insert ajax data!
      $('#users_index_user').html(data);

      // Code for 'close button'
      $("#users_show_close").click(function() {
        $('#users_index_mapcontainer_user').fadeOut('slow');
      });

      // Modal Stuff!
      $('#modal_message, #modal_feedback_req, #modal_friendship_req').modal({
        backdrop: false,
        show: false
      });

      $('#users_index_user_button_message').click(function() {
        $('.modal').modal('hide');
        $('#modal_message').modal('show');
      });

      $('#users_index_user_button_friend_req').click(function() {
        $('.modal').modal('hide');
        $('#modal_friendship_req').modal('show');
      });

      $('#users_index_user_button_feedback_req').click(function() {
        $('.modal').modal('hide');
        $('#modal_feedback_req').modal('show');
        $("#modal_feedback_req_datepicker").datepicker();
      });

      // Fade panel back in
      $("#users_index_mapcontainer_user").fadeIn('fast');

    });

  });

}


// Update the User List - submits form...
function users_index_users_updatelist () {
  $.get($("#users_index_users_form").attr("action"), $("#users_index_users_form").serialize(), null, "script");
  return false;
}



////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
/////////////////////////    ON LOAD    ////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////



$(document).ready(function(){




////////////////////////////////////////////////////////////////////
/////////////////////////    NEW     ///////////////////////////////
////////////////////////////////////////////////////////////////////

  $("#users_new_button_submit").attr("disabled",true);
  $('#user_accepts_tandc').attr('checked', false);

  // reset form here?

  $("#users_new_step2").css({ opacity: 0.3 });
  
  // Step 2 is made opaque in map code!
  
  $("#users_new_status").keyup(function(){

    if (($("#users_new_status").val().length > 50) && ($.users_new_step1_complete == true)) { // check entire form is complete
      $("#users_new_button_submit").attr("disabled",false);
    } else {
      $("#users_new_button_submit").attr("disabled",true);
    };

  });

////////////////////////////////////////////////////////////////////
/////////////////////////// NEW & EDIT /////////////////////////////
////////////////////////////////////////////////////////////////////


  if ( typeof users_newedit_map_lat_start == 'string' ) {

    var users_newedit_latlng = new google.maps.LatLng(users_newedit_map_lat_start, users_newedit_map_lng_start)

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
  
    google.maps.event.addListener(marker, 'drag', function(event) {

      document.getElementById("users_newedit_lat").value = event.latLng.lat();
      document.getElementById("users_newedit_lng").value = event.latLng.lng();

      if (!$.users_new_step1_complete) {

        $("#users_new_step2").css({
          opacity: 1
        });

        $.users_new_step1_complete = true;

      }

    });


  }



////////////////////////////////////////////////////////////////////
////////////////////////    INDEX    ///////////////////////////////
////////////////////////////////////////////////////////////////////



  //// USER LIST

  // Function users_updatelist is at top of file

  $("#users_index_users_form input").keypress(function(e) {
    if(e.which == 13) {
      users_index_users_updatelist();
    }
  });

  // Listtype Button-Radio link
  $('#users_index_users_form_button_0,#users_index_users_form_button_1,#users_index_users_form_button_2,#users_index_users_form_button_3').click(function() {

    // Break up id string, so can get id off the end
    var listtype = this.id.split('_');

    $('input[name=users_listtype]:eq('+listtype[5]+')').attr('checked', 'checked');

    $('#users_index_users_form_button_0,#users_index_users_form_button_1,#users_index_users_form_button_2,#users_index_users_form_button_3').removeClass('active');

    $(this).addClass('active');

    users_index_users_updatelist();

  });

  // Ajax pagination
  $("#users_index_users .application_pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });



  //// MAP

  if ( typeof users_index_map_lat_start == 'string' ) {

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


    var mapOptions = {
      center: new google.maps.LatLng(users_index_map_lat_start, users_index_map_lng_start),
      zoom: 14,
      minZoom: 4,
      mapTypeId: 'roadmap', // option: terrain
      disableDefaultUI: true,
      zoomControl: true,
      zoomControlOptions: {
          position: google.maps.ControlPosition.LEFT_CENTER
      }
    };

    map = new google.maps.Map(document.getElementById("users_index_map"), mapOptions);


    // Zoom Control Position Hack
    google.maps.event.addDomListener(map, 'tilesloaded', function(){
      // We only want to wrap once!
      if($('#users_index_map_zoomcontrol').length==0){
          $('div.gmnoprint').last().parent().wrap('<div id="users_index_map_zoomcontrol" />');
          $('div.gmnoprint').fadeIn(500);
      }
    });

    // Draw markers
    var image = new google.maps.MarkerImage("/assets/markers/marker_orange.png",
        new google.maps.Size(40.0, 52.0),
        new google.maps.Point(0, 0),
        new google.maps.Point(20.0, 26.0)
    );

    var shadow = new google.maps.MarkerImage("/assets/markers/marker_shadow.png",
        new google.maps.Size(67.0, 52.0),
        new google.maps.Point(0, 0),
        new google.maps.Point(20.0, 26.0)
    );



    ////////////////////////////////////////////////////////////////////////////
    ////////////////////// PLOTS ONLY MARKERS IN VIEWPORT //////////////////////
    ////////////////////////////////////////////////////////////////////////////

    // google.maps.event.addListener(map, 'idle', function() {

    //   for (var i = 0; i < users_index_map_markers.length; i++ ) {
    //     users_index_map_markers[i].setMap(null);
    //   }

    //   if (markerClusterer) {
    //     markerClusterer.clearMarkers();
    //   }

    //   var bounds = map.getBounds().toUrlValue();

    //   $.getJSON("/get_markers_within_viewport?bounds=" + bounds, function(json) {

    //     $.each(json, function(i, marker) {

    //       //var icon = users_index_customMarkers[json[i].level] || {};
    //       var marker = new google.maps.Marker({
    //         id: marker.id,
    //         map: map,
    //         position: new google.maps.LatLng(parseFloat(marker.lat),parseFloat(marker.lng)),
    //         //icon: icon.icon,
    //         icon: image,
    //         shadow: shadow,
    //         animation: google.maps.Animation.DROP
    //       });

    //       users_index_map_marker_bind(marker, map);
    //       //users_index_map_markers[marker.id] = marker;
    //       users_index_map_markers.push(marker);

    //     });

    //     // Marker Clusterer
    //     var styles = [[{
    //       url: '/assets/markers/cluster.png',
    //       height: 35,
    //       width: 35,
    //       anchor: [16, 0],
    //       textColor: '#ff00ff',
    //       textSize: 10
    //     }]];

    //     markerClusterer = new MarkerClusterer(map, users_index_map_markers, {
    //       minimumClusterSize: 10,
    //       gridSize: 100 // 60 is default
    //       //styles: styles[style]
    //     });


    //   });

    // });


    ////////////////////////////////////////////////////////////////////////////
    /////////////////////////// PLOTS ALL MARKERS //////////////////////////////
    ////////////////////////////////////////////////////////////////////////////


    $.getJSON("users", function(json) {

      $.each(json, function(i, marker) {

        //var icon = users_index_customMarkers[json[i].level] || {};
        var marker = new google.maps.Marker({
          id: marker.id,
          map: map,
          position: new google.maps.LatLng(parseFloat(marker.lat),parseFloat(marker.lng)),
          //icon: icon.icon,
          icon: image,
          shadow: shadow,
          animation: google.maps.Animation.DROP
        });

        google.maps.event.addListener(marker, 'mouseover', function() {
          users_index_mappanel_tooltip(marker.id);
        });

        google.maps.event.addListener(marker, 'click', function() {
          users_index_map_marker_locate(marker);
          setTimeout(function(){ users_index_map_marker_click(marker.id); }, 500);        
        });

        // Load marker array for MarkerCluster (& User list trigger click)
        users_index_map_markers.push(marker);
        //users_index_map_markers[marker.id] = marker;

      });

      // Marker Clusterer
      var styles = [{
        url: '/assets/clusters/cluster_4.png',
        height: 67,
        width: 67,
        anchor: [24, 0],
        textColor: '#ffffff',
        textSize: 20
      }];

      var markerClusterer = new MarkerClusterer(map, users_index_map_markers, {
        minimumClusterSize: 2,
        gridSize: 100, // 60 is default
        styles: styles
      });


    });

  }


  function users_index_map_marker_locate (marker) {

    newlatlng = marker.getPosition();

    //map.setZoom(5);
    //map.panTo(newlatlng);
    map.setCenter(newlatlng);
    
    marker.setAnimation(google.maps.Animation.BOUNCE);
    setTimeout(function(){ marker.setAnimation(null); }, 1440);

  }



  function users_index_mappanel_tooltip(marker_id) {

    $.get('/tooltip?id=' + marker_id, function(data) {

      $('#users_index_mappanel_tooltip').html(data);

      // Code for 'close button'
      $("#users_index_mappanel_tooltip_close").click(function() {
        $('#users_index_mappanel_tooltip').fadeOut('slow');
      });

      $('#users_index_mappanel_tooltip').fadeIn('fast');
    
    });

  }




////////////////////////////////////////////////////////////////////
///////////////////////////    ALL    //////////////////////////////
////////////////////////////////////////////////////////////////////

  $(".chzn-select").chosen();

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
//////////////////////////    CALLS    /////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

  users_index_users_updatelist();


////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

});