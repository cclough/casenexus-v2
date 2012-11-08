$(document).ready ->
  $("#users_new_step3").css opacity: 0.3

  if typeof users_newedit_map_lat_start is "string"
    users_newedit_latlng = new google.maps.LatLng(users_newedit_map_lat_start, users_newedit_map_lng_start)
    if users_newedit_map_lat_start == "" && navigator.geolocation
      navigator.geolocation.getCurrentPosition (position) ->
        users_newedit_latlng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
        window.marker.setPosition(users_newedit_latlng)
        window.map.setCenter(users_newedit_latlng)
        $("#users_newedit_lat").val(users_newedit_latlng.lat())
        $("#users_newedit_lng").val(users_newedit_latlng.lng())
        $("#users_new_step3").css opacity: 1
        $.users_new_step2_complete = true

    window.map = new google.maps.Map(document.getElementById("users_newedit_map"),
      # zoomed right out
      zoom: 12
      center: users_newedit_latlng
      mapTypeId: google.maps.MapTypeId.ROADMAP
      streetViewControl: false
      mapTypeControl: false
    )

    shadow = new google.maps.MarkerImage("/assets/markers/marker_shadow.png", new google.maps.Size(67.0, 52.0), new google.maps.Point(0, 0), new google.maps.Point(20.0, 50.0))

    window.marker = new google.maps.Marker(
      position: users_newedit_latlng
      map: window.map
      icon: new google.maps.MarkerImage("/assets/markers/marker_0.png")
      shadow: shadow
      draggable: true
    )

    google.maps.event.addListener(window.marker, "drag", (event) ->
      $("#users_newedit_lat").val(event.latLng.lat())
      $("#users_newedit_lng").val(event.latLng.lng())
      unless $.users_new_step2_complete
        $("#users_new_step3").css opacity: 1
        $.users_new_step2_complete = true
    )
