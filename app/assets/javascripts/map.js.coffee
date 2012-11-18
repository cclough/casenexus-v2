window.users_index_map_markers = []
window.markerClusterer = null
window.map = null

# Option: Pan To and Zoom
window.users_index_map_pan = (latlng) ->
  window.map.panTo latlng
  window.map.setZoom 9

window.users_index_map_marker_click = (marker_id) ->
  # Show User Panel
  $("#users_index_mapcontainer_user").fadeOut "fast", ->
    $.get "/members/" + marker_id, (data) ->

      # Insert ajax data!
      $("#users_index_user").html data

      # Code for 'close button'
      $("#users_index_show_close").click ->
        $("#users_index_mapcontainer_user").fadeOut "slow"

      # Modal Stuff!
      $("#modal_message, #modal_feedback_req, #modal_friendship_req").modal
        backdrop: false
        show: false

      $("#users_index_user_partner_button_message").click ->
        if !($("#modal_message").hasClass("in"))
          $(".modal").modal("hide")
          $("#modal_message").modal("show")

      $("#users_index_user_partner_button_friend_req").click ->
        if !($("#modal_friendship_req").hasClass("in"))
          $(".modal").modal("hide")
          $("#modal_friendship_req").modal("show")

      $("#users_index_user_feedback_button_feedback_req").click ->
        if !($("#modal_feedback_req").hasClass("in"))
          $(".modal").modal("hide")
          $("#modal_feedback_req").modal("show")
          $("#modal_feedback_req_datepicker").datepicker(dateFormat: "dd/mm/yy")

      # Radar Button
      $("#users_index_user_feedback_chart_radar_button_all").click ->
        $("#users_index_user_feedback_chart_radar").empty()
        users_index_user_feedback_chart_radar_draw "all", users_index_user_feedback_chart_radar_count
        $("#users_index_user_feedback_chart_radar_button_all").addClass "active"
        $("#users_index_user_feedback_chart_radar_button_combined").removeClass "active"

      $("#users_index_user_feedback_chart_radar_button_combined").click ->
        $("#users_index_user_feedback_chart_radar").empty()
        users_index_user_feedback_chart_radar_draw "combined", users_index_user_feedback_chart_radar_count
        $("#users_index_user_feedback_chart_radar_button_all").removeClass "active"
        $("#users_index_user_feedback_chart_radar_button_combined").addClass "active"

      setTimeout (->
        users_index_user_feedback_chart_radar_draw "all", users_index_user_feedback_chart_radar_count;
      ), 100

      # Fade panel back in
      $("#users_index_mapcontainer_user").fadeIn "fast"


# Update the User List - submits form...
window.users_index_users_updatelist = ->
  $.get("/members", $("#users_index_users_form").serialize(), null, "script")
  false


users_index_user_feedback_chart_radar_draw = (radar_type, radar_count) ->
  chart_show_radar = undefined

  # RADAR CHART
  chart_show_radar = new AmCharts.AmRadarChart()
  if radar_type is "all"
    chart_show_radar.dataProvider = users_index_user_feedback_chart_radar_data_all
  else chart_show_radar.dataProvider = users_index_user_feedback_chart_radar_data_combined if radar_type is "combined"
  chart_show_radar.categoryField = "criteria"
  #chart_show_radar.startDuration = 0.3
  #chart_show_radar.startEffect = ">"
  #chart_show_radar.sequencedAnimation = true
  chart_show_radar.color = "#000000"
  chart_show_radar.colors = ["#000000", "#FF6600", "#CC0000"]
  chart_show_radar.fontSize = 9

  # GRAPH - ALL
  graph = new AmCharts.AmGraph()
  graph.title = "All"
  graph.fillAlphas = 0.2
  graph.bullet = "round"
  graph.valueField = "all"
  graph.balloonText = "[[category]]: [[value]]/10"
  chart_show_radar.addGraph graph

  # GRAPH - FIRST 5
  graph = new AmCharts.AmGraph()
  graph.title = "First " + radar_count
  graph.fillAlphas = 0.2
  graph.bullet = "round"
  graph.valueField = "first"
  graph.balloonText = "[[category]]: [[value]]/10"
  chart_show_radar.addGraph graph

  # GRAPH - LAST 5
  graph = new AmCharts.AmGraph()
  graph.title = "Last " + radar_count
  graph.fillAlphas = 0.2
  graph.bullet = "round"
  graph.valueField = "last"
  graph.balloonText = "[[category]]: [[value]]/10"
  chart_show_radar.addGraph graph

  # VALUE AXIS
  valueAxis = new AmCharts.ValueAxis()
  valueAxis.gridType = "circles"
  valueAxis.fillAlpha = 0.02
  valueAxis.fillColor = "#000000"
  valueAxis.axisAlpha = 0.1
  valueAxis.gridAlpha = 0.1
  valueAxis.fontWeight = "bold"
  valueAxis.minimum = 0
  valueAxis.maximum = 10
  chart_show_radar.addValueAxis valueAxis

  # GUIDES
  # Blue - Business Analytics
  guide = new AmCharts.Guide()
  guide.angle = 270
  guide.tickLength = 2
  guide.toAngle = 390
  guide.value = 3
  guide.toValue = 2
  guide.fillColor = "#0D8ECF"
  guide.fillAlpha = 0.3
  valueAxis.addGuide guide

  # Green - Interpersonal
  guide = new AmCharts.Guide()
  guide.angle = 30
  guide.tickLength = 3
  guide.toAngle = 150
  guide.value = 3
  guide.toValue = 2
  guide.fillColor = "#B0DE09"
  guide.fillAlpha = 0.3
  valueAxis.addGuide guide

  # Yellow - Structure
  guide = new AmCharts.Guide()
  guide.angle = 150
  guide.tickLength = 1
  guide.toAngle = 270
  guide.value = 3
  guide.toValue = 2
  guide.fillColor = "#FCD202"
  guide.fillAlpha = 0.3
  valueAxis.addGuide guide
  
  # Balloon Settings
  balloon = chart_show_radar.balloon
  balloon.adjustBorderColor = true
  balloon.cornerRadius = 5
  balloon.showBullet = false
  balloon.fillColor = "#000000"
  balloon.fillAlpha = 0.7
  balloon.color = "#FFFFFF"

  # Legend Settings
  legend = new AmCharts.AmLegend()
  legend.position = "bottom"
  legend.align = "center"
  legend.color = "#000000"
  legend.markerType = "square"
  legend.rollOverGraphAlpha = 0
  legend.horizontalGap = 5
  legend.valueWidth = 5
  legend.switchable = true
  chart_show_radar.addLegend legend

  # WRITE
  if $("#users_index_user_feedback_chart_radar").size() > 0
    chart_show_radar.write "users_index_user_feedback_chart_radar"


$(document).ready ->
  # Update the list of users
  users_index_users_updatelist()

  # Update list of user when enter is pressed
  $("#users_index_users_form input").keypress (e) ->
    users_index_users_updatelist()  if e.which is 13

  # List type Button-Radio link
  $("#users_index_users_form_button_0, #users_index_users_form_button_1, #users_index_users_form_button_2, #users_index_users_form_button_3").click ->
    # Break up id string, so can get id off the end
    listtype = @id.split("_")
    $("input[name=users_listtype]:eq(" + listtype[5] + ")").attr "checked", "checked"
    $("#users_index_users_form_button_0,#users_index_users_form_button_1,#users_index_users_form_button_2,#users_index_users_form_button_3").removeClass "active"
    $(this).addClass "active"
    users_index_users_updatelist()

  # Ajax pagination
  $("#users_index_users .application_pagination a").live "click", ->
    $.getScript @href
    false

  # Map
  if typeof users_index_map_lat_start is "string"

    # Options for the map
    mapOptions =
      center: new google.maps.LatLng(users_index_map_lat_start, users_index_map_lng_start)
      zoom: 14
      minZoom: 4
      mapTypeId: "roadmap"
      disableDefaultUI: true
      zoomControl: true
      zoomControlOptions:
        position: google.maps.ControlPosition.LEFT_CENTER

    # Create the map
    window.map = new google.maps.Map(document.getElementById("users_index_map"), mapOptions)

    # Zoom Control Position Hack
    google.maps.event.addDomListener map, "tilesloaded", ->
      # We only want to wrap once!
      if $("#users_index_map_zoomcontrol").length is 0
        $("div.gmnoprint").last().parent().wrap "<div id=\"users_index_map_zoomcontrol\" />"
        $("div.gmnoprint").fadeIn 500

    # Marker
    shadow = new google.maps.MarkerImage("/assets/markers/marker_shadow.png", new google.maps.Size(67.0, 52.0), new google.maps.Point(0, 0), new google.maps.Point(20.0, 50.0))

    # Get the members
    $.getJSON "members", (json) ->
      $.each json, (i, marker) ->

        # Draw markers
        image = new google.maps.MarkerImage("/assets/markers/marker_" + marker.level + ".png")

        marker = new google.maps.Marker(
          id: marker.id
          map: map
          position: new google.maps.LatLng(parseFloat(marker.lat), parseFloat(marker.lng))
          icon: image
          shadow: shadow
          animation: google.maps.Animation.DROP
        )
        google.maps.event.addListener marker, "mouseover", ->
          users_index_mappanel_tooltip(marker.id)

        google.maps.event.addListener marker, "click", ->
          users_index_map_marker_locate(marker)
          setTimeout (->
            users_index_map_marker_click(marker.id)
          ), 500

        # Load marker array for MarkerCluster (& User list trigger click)
        users_index_map_markers.push(marker)


      # Marker Clusterer
      styles = [
        url: "/assets/clusters/cluster_1.png"
        height: 67
        width: 67
        anchor: [24, 0]
        textColor: "#ffffff"
        textSize: 20
      ]
      markerClusterer = new MarkerClusterer(map, users_index_map_markers,
        minimumClusterSize: 2
        gridSize: 100 # 60 is default
        styles: styles
      )


  users_index_map_marker_locate = (marker) ->
    newlatlng = marker.getPosition()
    window.map.setCenter newlatlng
    marker.setAnimation(google.maps.Animation.BOUNCE)
    setTimeout (->
      marker.setAnimation(null)
    ), 1440

  users_index_mappanel_tooltip = (marker_id) ->
    $.get "/members/" + marker_id + "/tooltip", (data) ->
      $("#users_index_mappanel_tooltip").html data

      # Code for 'close button'
      $("#users_index_mappanel_tooltip_close").click ->
        $("#users_index_mappanel_tooltip").fadeOut "slow"

      $("#users_index_mappanel_tooltip").fadeIn "fast"

  $(".chzn-select").chosen().change ->
    latlng_chosen = $(this).find("option:selected").val().split("_")
    users_chosen_latlng = new google.maps.LatLng(latlng_chosen[0], latlng_chosen[1])
    users_index_map_pan(users_chosen_latlng)
