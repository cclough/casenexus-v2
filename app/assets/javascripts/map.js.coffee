window.map = null



map_index_posts_prime = () ->
    # New post button
  $("#map_index_posts_new_button").click ->
    window.modal_post_show()


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









window.marker_and_popup_actions_for = (marker, persistance) ->

  if persistance == "temp"
    if window.current_active_marker
      unless window.current_active_marker == marker
        popup = generate_popup_for marker
        popup.openOn(map)
    else
      popup = generate_popup_for marker
      popup.openOn(map)

  else if persistance == "perm"

    if window.current_active_marker

      if window.current_active_marker == marker
        # marker.closePopup();
        map.removeLayer(window.current_active_popup)
        marker.setIcon L.icon(marker.feature.properties.icon)
        window.current_active_marker = null
        window.current_active_popup = null
      else
        window.current_active_marker.setIcon L.icon(current_active_marker.feature.properties.icon)
        map.removeLayer(window.current_active_popup)

        activate_perm_popup_and_icon_for(marker)
    else
      activate_perm_popup_and_icon_for(marker)


window.activate_perm_popup_and_icon_for = (marker) ->

  # Add perm popup
  popup = generate_popup_for marker
  map.addLayer(popup)

  # Change Icon
  activeIcon = L.icon(
    iconUrl: "/assets/markers/marker_new_active.png"
    iconSize: [33, 42]
    iconAnchor: [0, 0]
    popupAnchor: [17, 8]
  )
  marker.setIcon activeIcon

  # Make new current active this marker
  window.current_active_marker = marker
  window.current_active_popup = popup



window.generate_popup_for = (marker) ->

  feature = marker.feature
  popupContent =  '<div class="map_index_map_popup">' +

                      '   <div class="map_index_map_popup_user">' +
                      '     <span><img src="/assets/universities/' + feature.properties.university_image + '" class="application_userimage_medium"></span>' +
                      '     <span>' + feature.properties.username + '</span>' +
                      '   </div>' +    

                      '   <div class="map_index_map_popup_cases">' +
                      '     <div class="map_index_users_item_cases_recd">' + 
                      '         <div class="map_index_users_item_cases_text">taken</div>' +
                                feature.properties.cases_recd + 
                      '     </div>' +
                      '     <div class="map_index_users_item_cases_givn">' + 
                      '         <div class="map_index_users_item_cases_text">given</div>' +
                                feature.properties.cases_givn + 
                      '     </div>' +
                      '     <div class="map_index_users_item_cases_external">' + 
                      '         <div class="map_index_users_item_cases_text">ext</div>' +
                                feature.properties.cases_ext + 
                      '     </div>' +
                      '   </div>' +

                      '</div>'

  popup = L.popup(
    closeButton: false
    minWidth: 130
    offset: new L.Point(17, 8) # THIS IS THE IMPORTANT POPUP OFFSET
    autoPan: false
    zoomAnimation: true
  ).setLatLng(marker.getLatLng()).setContent(popupContent)

  popup





$(document).ready ->

  # Update the list of users
  map_index_users_updatelist()

  # search
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






  ######## DRAW MAP

  window.map = L.mapbox.map("map_index_map", "christianclough.map-pzcx86x2", { zoomControl: false })

  # Start at current_user, zoomed
  window.map.setView([parseFloat(map_index_map_lat_start), parseFloat(map_index_map_lng_start)], 15)


  # back to world view button (must be after map variable has been set)
  $("#map_index_map_zoomout").click ->
    window.map.setZoom(2);
    $(this).fadeOut("fast");


  # custom zoom control
  new L.Control.Zoom({ position: 'topright' }).addTo(map)
  # zoomer
  zooms = 17
  handle = document.getElementById("map_index_map_zoomer_handle")
  # Configure Dragdealer to update the map zoom
  zoom_bar = new Dragdealer("map_index_map_zoomer_zoom-bar",
    steps: zooms
    snap: true
    callback: (x, y) ->
      z = x * (zooms - 1)
      map.setZoom z
      handle.innerHTML = z
  )
  map.on "zoomend", ->
    z = Math.round(map.getZoom())
    zoom_bar.setValue z / 16
    handle.innerHTML = z
