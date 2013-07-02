window.map_index_map_markers = []
window.map = null
window.infobox = null

# Option: Pan To and Zoom
window.map_index_map_pan = (latlng) ->
  #window.map.panTo latlng
  window.map.panToWithOffset latlng, 0, -100
  window.map.setZoom 9


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



window.map_index_map_marker_click = (marker_id) ->
  # Show User Panel

  # window.infowindow.close()

  marker = map_index_map_markers[marker_id]

  $.ajax
    url: "/members/" + marker.id
    success: (data) ->

      boxcontent = document.createElement "div"
      boxcontent.innerHTML = data

      window.infobox.setContent boxcontent
      window.infobox.open map, marker

      # Load in modals to div then prime buttons
      $.get "/members/" + marker.id + "/show_modals", (data) ->
        $("#map_index_container_user_modals").html data

        # Code for 'close button'
        $("#map_index_user_close").click ->
          $("#map_index_container_user").fadeOut "fast", ->
            window.infobox.close()

        # Modal Stuff!
        $("#modal_message, #modal_friendship_req, #modal_event").modal
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

          $("#header_nav_panel_browse_search_field").val "hello"

        $("#map_index_user_button_event").click ->

          if !($("#modal_event").hasClass("in"))
            $(".modal").modal("hide")

            friend_id = $(this).data("friend_id")

            $.get "/events/new?friend_id=" + friend_id, (data) ->
              $("#modal_event").html data
              window.events_modal_rebless()
              $.get "/events/user_timezone?user_id=" + friend_id, (data) ->
                $("#events_new_friend_timezone").html data
                $("#modal_event").modal("show")

      # Doesn't work!
      # $("#map_index_container_user").fadeIn "fast"


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
  
  if (filter_excep != "firm")
    $("#map_index_users_form_pulldown_firm_button").html "All Firms <span class=caret></span>"
    $("#users_filter_firm").val "" 
  
  if (filter_excep != "language")
    $("#map_index_users_form_pulldown_language_button").html "All Languages <span class=caret></span>"
    $("#users_filter_language").val ""

window.map_index_users_search = ->
    $("#map_index_users_form_search_field").val($("#header_nav_panel_browse_search_field").val())
    map_index_users_updatelist()




$(document).ready ->
  # Update the list of users
  map_index_users_updatelist()

  $("#header_nav_panel_browse_search_form").on "submit", ->
    window.map_index_users_search()

  # Update list of user when enter is pressed
  $("#map_index_users_form input").keypress (e) ->
    map_index_users_updatelist()  if e.which is 13




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

    # New infobox with offset
    window.infobox = new InfoBox
      pixelOffset: new google.maps.Size(-200, -419)

    # Zoom Control Position Hack
    google.maps.event.addDomListener map, "tilesloaded", ->
      # We only want to wrap once!
      if $("#map_index_map_zoomcontrol").length is 0
        $("div.gmnoprint").last().parent().wrap "<div id=\"map_index_map_zoomcontrol\" />"
        $("div.gmnoprint").fadeIn 500


    # Commented as now use infobox, do i still want possibly?

    # Fade out user callout when moving away
    # google.maps.event.addDomListener map, "bounds_changed", ->
    #   $("#map_index_container_user").fadeOut "fast"



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
          # map_index_map_subnav_mouseover(marker.id)
          map_index_map_marker_click(marker.id)

        google.maps.event.addListener marker, "click", ->
          map_index_map_marker_click(marker.id)


        map_index_map_markers[marker.id] = marker



      ######## PAGE LOAD:

      #Pan
      map_index_map_latlng_start = new google.maps.LatLng map_index_map_lat_start,map_index_map_lng_start
      window.map_index_map_pan map_index_map_latlng_start
      
      #Infowindow
      window.map_index_map_marker_click map_index_map_marker_id_start


  map_index_map_marker_locate = (marker) ->
    newlatlng = marker.getPosition()
    #window.map.setCenter newlatlng
    window.map.panToWithOffset newlatlng, 150, 0
    marker.setAnimation(google.maps.Animation.BOUNCE)
    setTimeout (->
      marker.setAnimation(null)
    ), 1440

  map_index_map_subnav_mouseover = (marker_id) ->
    # $.get "/members/" + marker_id + "/mouseover", (data) ->
    #   $("#map_index_map_subnav_mouseover").html data
