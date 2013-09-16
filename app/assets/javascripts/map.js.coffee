window.map_index_map_markers = []
window.map_index_map_markers_ids = []
window.map = null
window.infobox = null



map_index_posts_prime = () ->
    # New post button
  $("#map_index_posts_new_button").click ->
    window.modal_post_show()


# Option: Pan To and Zoom
window.map_index_map_pan = (latlng) ->
  # window.map.panTo latlng
  window.map.panToWithOffset latlng, -200, -30
  window.map.setZoom 10


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


window.map_index_users_item_bless = () ->

  # Prime Button
  $(".map_index_users_item_button_message").click ->
    friend_id = $(this).data "friend_id"
    window.modal_message_show(friend_id)

  $(".map_index_users_item_button_event").click ->          
    friend_id = $(this).data("friend_id")
    window.modal_event_new_show(friend_id,null)

  $(".map_index_users_item_button_add").click ->
    friend_id = $(this).data("friend_id")
    window.modal_friendship_req_show(friend_id)

  window.application_truncatables()







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
  # show the spinner briefly
  $("#map_index_container_users .application_spinner_container").fadeIn("fast")

  $.get "/members", $("#map_index_users_form").serialize(), null, "script"
  false



window.map_index_users_resetfilters = (filter_excep) ->

  if (filter_excep != "language")
    $("#map_index_users_form_pulldown_language_button").html "All Languages <span class=caret></span>"
    $("#users_filter_language").val ""


window.map_index_users_search = ->
    $("#map_index_users_form_search_field").val($("#header_nav_search_field").val())
    map_index_users_updatelist()





window.map_index_map_load_all = (target_id, latlng) ->

  # THIS CODE IS CAUSING A STACKOVERFLOW
  window.map_index_map_pan latlng


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

      # Bounce that shit up
      map_marker.setAnimation(google.maps.Animation.BOUNCE)
      setTimeout (->
        map_marker.setAnimation(null)
      ), 1440

    window.map_index_map_markers[marker.id] = map_marker
    window.map_index_map_markers_ids[i] = marker.id



window.map_index_user_profile_chart_activity_draw = (user_id) ->
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

  chart.write "map_index_users_item_activity_" + user_id

$(document).ready ->

  # Update the list of users
  map_index_users_updatelist()

  $("#header_nav_search_form").on "submit", ->
    window.map_index_users_search()

  # Update list of user when enter is pressed
  $("#map_index_users_form input").keypress (e) ->
    map_index_users_updatelist()  if e.which is 13

  # Prime posts
  $("#modal_post").modal
    backdrop: true
    show: false

  $("#map_index_users_form_button_posts_new").click ->
    if !($("#modal_post").hasClass("in"))
      $(".modal").modal("hide")
      $("#modal_post").on "shown", ->
        window.modal_spinner_prime()
      $("#modal_post").modal "show"


  # For Pull Downs
  $(".map_index_users_form_pulldown a").click ->

    category = $(this).data("category")

    # Change radio
    # radio = $(this).data("radio")
    # $("input[name=users_listtype]:eq(" + radio + ")").prop "checked", true

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

    # Remove and add active class to buttons
    $(".map_index_users_form_pulldown_button, .map_index_users_form_button").removeClass "active"
    $(this).addClass "active"

    radio = $(this).data("radio")

    # Change radio
    $("input[name=users_listtype]:eq(" + radio + ")").prop "checked", true
        
    map_index_users_updatelist()

  $(".map_index_users_form_button_degreelevel").click ->

    $(".map_index_users_form_button_degreelevel").removeClass "active"
    $(this).addClass "active"

    selection_id = $(this).data("degreelevel_id")
    $("#users_filter_degreelevel").val(selection_id)

    map_index_users_updatelist()

  # Ajax pagination
  $(".pagination a").click ->
    $.getScript @href
    false


  # Map
  if typeof map_index_map_lat_start is "string"

    #Options for the map
    mapOptions =
      zoom: 10
      minZoom: 3
      mapTypeId: "roadmap"
      center: new google.maps.LatLng(parseFloat(map_index_map_lat_start), parseFloat(map_index_map_lng_start))
      
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

    #New infobox with offset
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

    # window.map_index_load_infobox map_index_map_marker_id_start
    # 