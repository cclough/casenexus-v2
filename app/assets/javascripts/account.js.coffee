
window.account_completeedit_bless = () ->

  $("#account_completeedit_skype").clickover trigger: "hover"

  # if not defined before
  account_completeedit_map_lat_start = $("#account_completeedit_lat").val()
  account_completeedit_map_lng_start = $("#account_completeedit_lng").val()

  # Draw map
  window.map = L.mapbox.map("account_completeedit_map", "christianclough.map-pzcx86x2")

  # Icon for marker
  userIcon = L.icon(
    iconUrl: "/assets/markers/marker_new.png"
    iconSize: [33, 42]
    iconAnchor: [0, 0]
    popupAnchor: [17, 8]
  )

  # Marker
  marker = L.marker(new L.LatLng(parseFloat(account_completeedit_map_lat_start), parseFloat(account_completeedit_map_lng_start)),
    icon: userIcon#L.mapbox.marker.icon("marker-color": "CC0033")
    draggable: true
  )
  marker.addTo map
  marker.on "dragend", (e) ->
    coords = e.target.getLatLng()
    $("#account_completeedit_lat").val(coords.lat)
    $("#account_completeedit_lng").val(coords.lng)

  # Start at current_user, zoomed
  window.map.setView([parseFloat(account_completeedit_map_lat_start), parseFloat(account_completeedit_map_lng_start)], 15)

  window.modal_spinner_prime()



$(document).ready ->





  #////////////////////////////////////////////////////////
  #////////////////// COMPLETE & EDIT /////////////////////
  #////////////////////////////////////////////////////////

  

  if typeof account_this_is_complete is "string"
    window.account_completeedit_bless()



  #////////////////////////////////////////////////////////
  #///////////////////////// ALL //////////////////////////
  #////////////////////////////////////////////////////////
