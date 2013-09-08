window.map_index_map_markers = []
window.map_index_map_markers_ids = []
window.map = null
window.infobox = null



# Option: Pan To and Zoom
window.map_index_map_pan = (latlng) ->
  # window.map.panTo latlng
  # window.map.panToWithOffset latlng, 0, -30
  # latlng = new google.maps.LatLng lat, lng
  window.map.panTo latlng
  window.map.setZoom 6


# From http://stackoverflow.com/questions/8146676/google-maps-api-v3-offset-panto-by-x-pixels
google.maps.Map::panToWithOffset = (latlng, offsetX, offsetY) ->
  map = this
  ov = new google.maps.OverlayView()
  ov.onAdd = ->
    proj = @getProjection()
    aPoint = proj.fromLatLngToContainerPixel(latlng)
    aPoint.x = aPoint.x + offsetX
    aPoint.y = aPoint.y + offsetY
    map.panTo proj.fromContainerPixelToLatLng(aPoint)

  ov.draw = ->

  ov.setMap this


window.map_index_profile_bless = () ->


  # Toggle button
  $(".map_index_user_profile_toggle").click ->
    marker_id = $(this).attr('data-user_id')
    window.map_index_profile_toggle(marker_id)
    
  # Prime Button
  $(".map_index_user_profile_button_message").click ->
    friend_id = $(this).data "friend_id"
    window.modal_message_show(friend_id)

  $(".map_index_user_profile_button_event").click ->          
    friend_id = $(this).data("friend_id")
    window.modal_event_new_show(friend_id,null)

  $(".map_index_user_profile_button_friendrequest").click ->
    friend_id = $(this).data("friend_id")
    window.modal_friendship_req_show(friend_id)


  window.application_truncatables()

window.map_index_profile_toggle = (marker_id) ->

  if $("#map_index_container_user_profile").hasClass "in"
    window.map_index_load_profile_small(marker_id)
  else
    window.map_index_load_profile(marker_id)






window.map_index_load_profile_small = (marker_id) ->

  $("#map_index_container_user_profile").hide "slide", direction: "down", "fast"
  # marker = map_index_map_markers[marker_id]

  $.ajax
    url: "/members/" + marker_id + "/show_small"
    success: (data) ->

      $("#map_index_container_user_profile_small").html data
      $("#map_index_container_user_profile_small").show "slide", direction: "down", "fast", ->
        window.map_index_profile_bless()
        $("#map_index_container_user_profile").removeClass "in"




window.map_index_load_profile = (marker_id) ->



  $("#map_index_container_user_profile_small").hide "slide", direction: "down", "fast", ->
  # marker = map_index_map_markers[marker_id]

  $.ajax
    url: "/members/" + marker_id
    success: (data) ->

      $("#map_index_container_user_profile").html data
      $("#map_index_container_user_profile").show "slide", direction: "down", "fast", ->
        window.map_index_profile_bless()
        # Draw chart
        window.map_index_user_profile_chart_activity_draw()
        $("#map_index_container_user_profile").addClass "in"





window.map_index_load_infobox = (marker_id) ->

  b = $("<div></div>")
  b.html "<img src=/assets/markers/arrow.png></img>"
  window.infobox.setContent b.html()
  
  # Click to close
  # $("#map_index_container_user_infobox").click ->
  #   $("#map_index_container_user_infobox").fadeOut "fast", ->
  #     window.infobox.close()

  marker = map_index_map_markers[marker_id]
  window.infobox.open map, marker



# Update the User List - submits form...
window.map_index_users_updatelist = ->
  $.get("/members", $("#map_index_users_form").serialize(), null, "script")
  false


window.map_index_users_resetfilters = (filter_excep) ->

  if (filter_excep != "country")
    $("#map_index_users_form_pulldown_country_button").html "All Countries <span class=caret></span>"
    $("#users_filter_country").val ""
  
  if (filter_excep != "university")
    $("#map_index_users_form_pulldown_university_button").html "All Universities <span class=caret></span>"
    $("#users_filter_university").val ""
  
  if (filter_excep != "language")
    $("#map_index_users_form_pulldown_language_button").html "All Languages <span class=caret></span>"
    $("#users_filter_language").val ""


window.map_index_users_search = ->
    $("#map_index_users_form_search_field").val($("#header_nav_search_field").val())
    map_index_users_updatelist()

map_index_map_zoomcalc = ->
  # Zoom according to div size: http://stackoverflow.com/questions/17412397/zoom-google-map-to-fit-the-world-on-any-screen
  zl = Math.round(Math.log($("#map_index_map").width() / 512)) + 1 + 1 # extra 1 added by cc
  return zl




window.map_index_map_load_all = (target_id, latlng) ->

  # THIS CODE IS CAUSING A STACKOVERFLOW
  window.map_index_map_pan latlng

  if $("map_index_container_user_profile").hasClass "in"
    window.map_index_load_profile target_id
  else
    window.map_index_load_profile_small target_id



map_index_map_markers_clear = ->

  i = 0

  # if map_index_map_markers
  while i < map_index_map_markers_ids.length
    # alert "deleting item in marker array #" + String map_index_map_markers_ids[i]
    window.map_index_map_markers[map_index_map_markers_ids[i]].setMap null
    i++

  map_index_map_markers = []


window.map_index_map_markers_draw = () ->

  # Marker
  # shadow = new google.maps.MarkerImage("/assets/markers/marker_shadow.png", new google.maps.Size(67.0, 52.0), new google.maps.Point(0, 0), new google.maps.Point(20.0, 50.0))

  map_index_map_markers_clear()

  json = $.parseJSON map_index_map_markers_json

  $.each json, (i, marker) ->
    marker = json[i]

    # Draw markers
    image = new google.maps.MarkerImage("/assets/markers/marker_" + marker.level + ".png")

    map_marker = new google.maps.Marker(
      id: marker.id
      map: map
      position: new google.maps.LatLng(parseFloat(marker.lat), parseFloat(marker.lng))
      icon: image
      # shadow: shadow
      animation: google.maps.Animation.DROP
    )

    google.maps.event.addListener map_marker, "mouseover", ->
      map_index_load_infobox(map_marker.id)
    
    google.maps.event.addListener map_marker, "click", ->
      latlng = new google.maps.LatLng(parseFloat(marker.lat), parseFloat(marker.lng))
      window.map_index_map_load_all map_marker.id, latlng

    window.map_index_map_markers[marker.id] = map_marker
    window.map_index_map_markers_ids[i] = marker.id



window.map_index_user_profile_chart_activity_draw = () ->
  chart = undefined
  
  # SERIAL CHART
  chart = new AmCharts.AmSerialChart()

  chart.dataProvider = map_index_user_profile_chart_activity_data

  chart.categoryField = "week"
  
  # this single line makes the chart a bar chart,              
  chart.rotate = false
  # chart.depth3D = 20
  # chart.angle = 30
  
  # AXES
  # Category
  categoryAxis = chart.categoryAxis
  categoryAxis.gridPosition = "start"
  categoryAxis.axisColor = "#DADADA"
  categoryAxis.fillAlpha = 0
  categoryAxis.gridAlpha = 0
  categoryAxis.fillColor = "#FAFAFA"
  categoryAxis.labelsEnabled = false
  
  # value
  valueAxis = new AmCharts.ValueAxis()
  valueAxis.gridAlpha = 0
  valueAxis.dashLength = 1
  valueAxis.inside = true
  
  # valueAxis.minimum = 1;
  valueAxis.integersOnly = true
  valueAxis.labelsEnabled = false
  valueAxis.maximum = 5
  valueAxis.axisAlpha = 0;
  chart.addValueAxis valueAxis
  
  # GRAPH
  graph = new AmCharts.AmGraph()
  graph.title = "Count"
  graph.valueField = "count"
  graph.type = "column"
  graph.labelPosition = "bottom"
  graph.color = "#000000"
  graph.fontSize = 10
  graph.labelText = "[[category]]"
  graph.balloonText = "[[category]]: [[value]]"
  graph.lineAlpha = 0
  
  # Balloon Settings
  balloon = chart.balloon
  balloon.adjustBorderColor = true
  balloon.cornerRadius = 5
  balloon.showBullet = false
  balloon.fillColor = "#000000"
  balloon.fillAlpha = 0.7
  balloon.color = "#FFFFFF"
  
  graph.fillColors = "#1ABC9C"
  graph.fillAlphas = 1
  chart.addGraph graph

  chart.write "map_index_user_profile_chart_activity"

$(document).ready ->

  # Update the list of users
  map_index_users_updatelist()

  $("#header_nav_search_form").on "submit", ->
    window.map_index_users_search()

  # Update list of user when enter is pressed
  $("#map_index_users_form input").keypress (e) ->
    map_index_users_updatelist()  if e.which is 13


  # Modal Stuff!
  $("#modal_message, #modal_friendship_req, #modal_event").modal
    backdrop: false
    show: false

  # Switch view button - world vs local
  $("#map_index_users_form_view_world_button").click ->
    LatLng = new google.maps.LatLng(0, 0)
    window.map.setCenter LatLng
    window.map.setZoom map_index_map_zoomcalc()

    # map_index_map_markers_clear()

  $("#map_index_users_form_view_local_button").click ->
    window.map_index_map_pan window.map_index_map_latlng_start



  # For Pull Downs
  $(".map_index_users_form_pulldown a").click ->

    category = $(this).data("category")

    # Change radio
    radio = $(this).data("radio")
    $("input[name=users_listtype]:eq(" + radio + ")").prop "checked", true

    # Change text field to language name
    selection_id = $(this).data("id")
    $("#users_filter_"+category).val(selection_id)

    map_index_users_updatelist()

    # Change filter button caption
    selection = $(this).data("name")
    $("#map_index_users_form_pulldown_"+category+"_button").html(selection + "  <span class=caret></span>")

    # Remove and add active class to buttons
    $(".map_index_users_form_pulldown_button, .map_index_users_form_button").removeClass "active"
    $("#map_index_users_form_pulldown_"+category+"_button").addClass "active"

    # Menu item select and remove others
    $(".map_index_users_form_pulldown a").removeClass "hovered"
    $(this).addClass "hovered"
    $(this).parent().parent().parent().removeClass 'open'

    # Reset all other menues to 'all'
    map_index_users_resetfilters category


  # List type Button-Radio link
  $(".map_index_users_form_button").click ->

    radio = $(this).data("radio")

    # Change radio
    $("input[name=users_listtype]:eq(" + radio + ")").attr "checked", "checked"
    
    # Remove and add active class to buttons
    $(".map_index_users_form_pulldown_button, .map_index_users_form_button").removeClass "active"
    $(this).addClass "active"
    
    map_index_users_updatelist()


  # Ajax pagination
  $(".pagination a").click ->
    $.getScript @href
    false


  # Map
  if typeof map_index_map_lat_start is "string"

    # Set start latlng var (used in several places in this file)
    window.map_index_map_latlng_start = new google.maps.LatLng map_index_map_lat_start,map_index_map_lng_start

    zl = map_index_map_zoomcalc()
    # Options for the map
    mapOptions =
      # center: window.map_index_map_latlng_start
      center: new google.maps.LatLng(0, 0)
      zoom: zl
      minZoom: zl
      mapTypeId: "roadmap"
      disableDefaultUI: true
      zoomControl: true
      zoomControlOptions:
        position: google.maps.ControlPosition.LEFT_CENTER
      styles: [
        featureType: "water"
        stylers: [color: "#abe2ff"]
      ,
        featureType: "landscape.natural"
        elementType: "all"
        stylers: [
          color: "#a2ff9d"
        ,
          lightness: 3
        ]
      ]


    # Create the map
    window.map = new google.maps.Map(document.getElementById("map_index_map"), mapOptions)

    # New infobox with offset
    window.infobox = new InfoBox
      # (h,v), (minus is left ,minus is up)
      pixelOffset: new google.maps.Size(-39, -150)

    # Zoom Control Position Hack
    google.maps.event.addDomListener map, "tilesloaded", ->
      # We only want to wrap once!
      if $("#map_index_map_zoomcontrol").length is 0
        $("div.gmnoprint").last().parent().wrap "<div id=\"map_index_map_zoomcontrol\" />"
        $("div.gmnoprint").fadeIn 500


    ######## PAGE LOAD:

    # Load profile and infowindow
    window.map_index_load_profile_small map_index_map_marker_id_start
    window.map_index_load_infobox map_index_map_marker_id_start






  map_index_map_marker_locate = (marker) ->
    newlatlng = marker.getPosition()
    #window.map.setCenter newlatlng
    window.map.panToWithOffset newlatlng, 150, 0
    marker.setAnimation(google.maps.Animation.BOUNCE)
    setTimeout (->
      marker.setAnimation(null)
    ), 1440