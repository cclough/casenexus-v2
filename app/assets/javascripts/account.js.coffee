$(document).ready ->

  #////////////////////////////////////////////////////////
  #////////////////// COMPLETE & EDIT /////////////////////
  #////////////////////////////////////////////////////////

  $("#account_complete_button_random_name").click (e) ->
    e.preventDefault()
    $.ajax("/account/random_name", type: "get", dataType: "script")

  if typeof account_completeedit_map_lat_start is "string"
    account_completeedit_latlng = new google.maps.LatLng(account_completeedit_map_lat_start, account_completeedit_map_lng_start)

    $("#account_completeedit_lat").val(account_completeedit_latlng.lat())
    $("#account_completeedit_lng").val(account_completeedit_latlng.lng())

    window.map = new google.maps.Map(document.getElementById("account_completeedit_map"),
      # zoomed right out
      zoom: 13
      center: account_completeedit_latlng
      mapTypeId: google.maps.MapTypeId.ROADMAP
      streetViewControl: false
      mapTypeControl: false
    )

    shadow = new google.maps.MarkerImage("/assets/markers/marker_shadow.png", new google.maps.Size(67.0, 52.0), new google.maps.Point(0, 0), new google.maps.Point(20.0, 50.0))

    window.marker = new google.maps.Marker(
      position: account_completeedit_latlng
      map: window.map
      icon: new google.maps.MarkerImage("/assets/markers/marker_0.png")
      shadow: shadow
      draggable: true
    )

    google.maps.event.addListener(window.marker, "drag", (event) ->
      $("#account_completeedit_lat").val(event.latLng.lat())
      $("#account_completeedit_lng").val(event.latLng.lng())
    )

  #////////////////////////////////////////////////////////
  #///////////////////////// ALL //////////////////////////
  #////////////////////////////////////////////////////////
