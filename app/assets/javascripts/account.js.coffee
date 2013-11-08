
window.account_completeedit_bless = () ->

  $("#account_completeedit_skype").clickover 
    trigger: "hover"
    html: true

  $(".chzn-select").chosen()

  # if not defined before
  account_completeedit_map_lat_start = $("#account_completeedit_lat").val()
  account_completeedit_map_lng_start = $("#account_completeedit_lng").val()

  # Draw map
  window.map = L.mapbox.map("account_completeedit_map", "christianclough.map-pzcx86x2")

  # Plot other members
  $.getJSON "/members", null, (json) ->
    markerLayer = L.mapbox.markerLayer()
    markerLayer.on "layeradd", (e) ->
      marker = e.layer
      marker.setIcon L.icon(marker.feature.properties.icon)
    markerLayer.addTo map
    markerLayer.setGeoJSON json

    # DRAW USER MARKER AFTER OTHERS TO ENSURE ITS ON TOP
    # Icon for user marker
    userIcon = L.icon(
      # iconUrl: "/assets/markers/marker_" + account_completeedit_currentuser_university_image
      # iconSize: [35, 57]
      # iconAnchor: [17, 51] # high is left, high is up + THINK IN TERMS OF HALVES OF THE ICON SIZE
      # popupAnchor: [17, 57]
      iconUrl: "/assets/markers/user_location.png"
      iconSize: [30, 30] # size of the icon
      iconAnchor: [15, 15] # point of the icon which will correspond to marker's location
      popupAnchor: [0, -25] # point from which the popup should open relative to the iconAnchor
    )

    # User Marker
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

    window.application_spinner_prime(".modal.in")





$(document).ready ->


  #////////////////////////////////////////////////////////
  #////////////////////// COMPLETE ////////////////////////
  #////////////////////////////////////////////////////////
  
  window.application_disablesubmit_prime "#account_editpassword_panel"
  window.application_disablesubmit_prime "#account_complete_panel"

  if $("#account_complete_panel").length > 0
    window.account_completeedit_bless()