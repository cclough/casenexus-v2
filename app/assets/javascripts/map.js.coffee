window.map_index_map_markers = []
window.markerClusterer = null
window.map = null

# Option: Pan To and Zoom
window.map_index_map_pan = (latlng) ->
  window.map.panTo latlng
  window.map.setZoom 9


window.map_index_map_marker_click = (marker_id) ->
  # Show User Panel
  # $('#map_index_mapcontainer_user').hide "slide", { direction: "right" }, 200, ->
  # #$("#map_index_mapcontainer_user").fadeOut "fast", ->

    $.get "/members/" + marker_id, (data) ->

      # Insert ajax data!
      $("#map_index_container_user").html data

      #Code for 'close button'
      $("#map_index_show_close").click ->
        $("#map_index_container_user").fadeOut "slow"

      # Modal Stuff!
      $("#modal_message, #modal_feedback_req, #modal_friendship_req").modal
        backdrop: false
        show: false


      $("#map_index_user_button_message").click ->
        if !($("#modal_message").hasClass("in"))
          $(".modal").modal("hide")
          $("#modal_message").modal("show")


      $("#map_index_user_button_friendrequest").click ->
        if !($("#modal_friendship_req").hasClass("in"))
          $(".modal").modal("hide")
          $("#modal_friendship_req").modal("show")


      $("#map_index_user_button_feedbackrequest").click ->
        if !($("#modal_feedback_req").hasClass("in"))
          $(".modal").modal("hide")
          $("#modal_feedback_req").modal("show")
          $("#modal_feedback_req_datetimepicker").datepicker()


      #Fade panel back in
      $("#map_index_container_user").fadeIn "fast"
      $('#map_index_container_user').show "slide", { direction: "right" }, 200

# Update the User List - submits form...
window.map_index_users_updatelist = ->
  $.get("/members", $("#map_index_users_form").serialize(), null, "script")
  false



$(document).ready ->
  # Update the list of users
  map_index_users_updatelist()

  # Update list of user when enter is pressed
  $("#map_index_users_form input").keypress (e) ->
    map_index_users_updatelist()  if e.which is 13

  # List type Button-Radio link
  $("#map_index_users_form_button_0, #map_index_users_form_button_1, #map_index_users_form_button_2, #map_index_users_form_button_3").click ->
    # Break up id string, so can get id off the end
    listtype = @id.split("_")
    $("input[name=users_listtype]:eq(" + listtype[5] + ")").attr "checked", "checked"
    $("#map_index_users_form_button_0,#map_index_users_form_button_1,#map_index_users_form_button_2,#map_index_users_form_button_3").removeClass "active"
    $(this).addClass "active"
    map_index_users_updatelist()

  # Ajax pagination
  $("#map_index_users .application_pagination a").on "click", ->
    $.getScript @href
    false

  # Map
  if typeof map_index_map_lat_start is "string"

    # Options for the map
    mapOptions =
      center: new google.maps.LatLng(map_index_map_lat_start, map_index_map_lng_start)
      zoom: 14
      minZoom: 4
      mapTypeId: "roadmap"
      disableDefaultUI: true
      zoomControl: true
      zoomControlOptions:
        position: google.maps.ControlPosition.LEFT_CENTER

    # Create the map
    window.map = new google.maps.Map(document.getElementById("map_index_container_map"), mapOptions)

    # Zoom Control Position Hack
    google.maps.event.addDomListener map, "tilesloaded", ->
      # We only want to wrap once!
      if $("#map_index_map_zoomcontrol").length is 0
        $("div.gmnoprint").last().parent().wrap "<div id=\"map_index_map_zoomcontrol\" />"
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
          map_index_map_subnav_mouseover(marker.id)

        google.maps.event.addListener marker, "click", ->
          map_index_map_marker_locate(marker)
          setTimeout (->
            map_index_map_marker_click(marker.id)
          ), 300

        # Load marker array for MarkerCluster (& User list trigger click)
        map_index_map_markers.push(marker)


      # Marker Clusterer
      styles = [
        url: "/assets/clusters/cluster_1.png"
        height: 67
        width: 67
        anchor: [24, 0]
        textColor: "#ffffff"
        textSize: 20
      ]
      markerClusterer = new MarkerClusterer(map, map_index_map_markers,
        minimumClusterSize: 2
        gridSize: 100 # 60 is default
        styles: styles
      )


  map_index_map_marker_locate = (marker) ->
    newlatlng = marker.getPosition()
    window.map.setCenter newlatlng
    marker.setAnimation(google.maps.Animation.BOUNCE)
    setTimeout (->
      marker.setAnimation(null)
    ), 1440

  map_index_map_subnav_mouseover = (marker_id) ->
    $.get "/members/" + marker_id + "/mouseover", (data) ->
      $("#map_index_map_subnav_mouseover").html data





  # $(".chzn-select").chosen().change ->
  #   latlng_chosen = $(this).find("option:selected").val().split("_")
  #   users_chosen_latlng = new google.maps.LatLng(latlng_chosen[0], latlng_chosen[1])
  #   map_index_map_pan(users_chosen_latlng)
