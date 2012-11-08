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

      $("#users_index_user_button_message").click ->
        $(".modal").modal("hide")
        $("#modal_message").modal("show")

      $("#users_index_user_button_friend_req").click ->
        $(".modal").modal("hide")
        $("#modal_friendship_req").modal("show")

      $("#users_index_user_button_feedback_req").click ->
        $(".modal").modal("hide")
        $("#modal_feedback_req").modal("show")
        $("#modal_feedback_req_datepicker").datepicker(dateFormat: "dd/mm/yy")

      # Fade panel back in
      $("#users_index_mapcontainer_user").fadeIn "fast"


# Update the User List - submits form...
window.users_index_users_updatelist = ->
  $.get("/members", $("#users_index_users_form").serialize(), null, "script")
  false

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
