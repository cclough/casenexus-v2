$(document).ready(function(){

/////////////////////////////////////////////////////////////////
/////////////////////////// SHARED //////////////////////////////
/////////////////////////////////////////////////////////////////

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


/////////////////////////////////////////////////////////////////
/////////////////////////// INDEX ///////////////////////////////
/////////////////////////////////////////////////////////////////


  //var users_index_markerArray = [];

  // Map Load
  $('#users_index_map').gmap({

    'center': new google.maps.LatLng(lat_start, lng_start),
    'zoom': 14,
    'mapTypeId': 'roadmap',
    'streetViewControl': false,
    'mapTypeControl': false,
    'panControlOptions': {
        //style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
        position: google.maps.ControlPosition.LEFT_CENTER
    },
    'zoomControlOptions': {
        //style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
        position: google.maps.ControlPosition.LEFT_CENTER
    }

    }).bind('init', function() { 

    var shadow = new google.maps.MarkerImage('http://www.casenexus.com/images/markers/mark_shadow.png',
        new google.maps.Size(62.0, 62.0),
        new google.maps.Point(0, 0),
        new google.maps.Point(15.0, 62.0)
        );
    
    $.getJSON('users', function(json) { 
      //for (var i = 0; i < json.length; i++) {

      $.each( json, function(i, marker) {

        $('#users_index_map').gmap('addMarker', { 
          'id': '99',
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

            $('#users_index_user').load('/users/' + marker.id, function() {
              $("#users_index_mapcontainer_user").fadeIn('slow');
            });

          });


        });
        
        //users_index_markerArray[marker.id] = this;

      });

    });
  });


  // Marker Click Trigger Function
  $("#triggermarkerbutton").click(function() {

    $('#users_index_map').gmap('find', 'markers', { 'property': 'id', 'value': '1' }, function(marker, found) {
        marker.triggerEvent('click');
    });

    //google.maps.event.trigger(users_index_markerArray[51],'click');

  });

/////////////////////////////////////////////////////////////////
///////////////////////////// NEW ///////////////////////////////
/////////////////////////////////////////////////////////////////




/////////////////////////////////////////////////////////////////
///////////////////////////// EDIT //////////////////////////////
/////////////////////////////////////////////////////////////////


  // $(".datepicker").datepicker();


/////////////////////////////////////////////////////////////////
///////////////////////////// SHOW //////////////////////////////
/////////////////////////////////////////////////////////////////


  // why won't this work?
  $("#users_show_close").click(function() {
    $('#users_index_mapcontainer_user').fadeOut('slow');
  });


/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


});


