$(document).ready ->

  # Submit form
  $("#roulette_index_token_form").submit (e) ->
    result = false
    $.ajax "/members/check_roulette?roulette_token=" + $("#roulette_index_token_form_field").val(),
      type: "GET"
      async: false
      success: (data, textStatus, jqXHR) ->
        if parseInt(data) > 0
          result = true
        else
          alert "Please enter a valid token."
          result = false

    result

  # Roulette modal
  $("#modal_roulette_req").modal
    backdrop: false
    show: false

  # Enable connect button by default
  $("#roulette_index_button_connect").attr "disabled", false
  $("#roulette_index_button_disconnect").attr "disabled", true

  # User array cache
  window.local_users = []
  window.remote_users = []

  add_user_to_list_view = (user_id) ->
    # Get the UI for the new user, add it on screen, attach click actions
    $.get "/get_item?id=" + user_id, (data_item) ->
      $("#roulette_index_users").append "<div class=roulette_index_users_item data-socket_id=" + user_id + " id=roulette_index_users_item_" + user_id + ">" + data_item + "</div>"
      $("#roulette_index_users_item_" + user_id).fadeIn "fast"

      # Send request button
      $("#roulette_index_users_item_" + user_id + " .roulette_index_users_item_button_request").click ->
        target_user_id = $(this).attr("data-user_id")
        window.socket.emit "private",
          to: target_user_id
          msg: "Request to skype"

      # Show profile button
      $(".roulette_index_users_item_button_expand").click ->
        item_id = $(this).attr("data-id")
        roulette_item_status = $("#roulette_index_users_item_status_" + item_id)
        if roulette_item_status.hasClass("slid")
          roulette_item_status.slideUp "fast", ->
            roulette_item_status.removeClass "slid"

        else unless roulette_item_status.hasClass("slid")
          roulette_item_status.slideDown "fast", ->
            roulette_item_status.addClass "slid"

  # Connect Button
  $("#roulette_index_button_connect").click ->
    # HTML Updates
    $("#roulette_index_button_connect").attr "disabled", true
    $("#roulette_index_button_connect_text").html "Connecting..."

    # Connect the socket
    #window.socket = io.connect("http://127.0.0.1:80", secure: false, "force_new_connection": true)
    window.socket = io.connect("https://cclough.nodejitsu.com", secure: true, "force new connection": true)

    # On connection to server, ask for user's name with an anonymous callback
    window.socket.on "connect", ->
      # Send serder addUser the id of the current user
      window.socket.emit "add_user", { id: roulette_index_user_id, name: roulette_index_user_name }
      # HTML
      $("#roulette_index_button_connect_text").html "Connected"
      $("#roulette_index_button_disconnect").attr "disabled", false


    # Listens for private message (roulette request)
    window.socket.on "private", (data) ->
      $.get "/get_request?id=" + data.from + "&msg=" + data.msg, (data_request) ->
        $("#modal_roulette_req").html data_request
        $("#modal_roulette_req").modal "show"
        $(".modal_roulette_req_skype").tooltip()

    # Whenever server fires update_log, this function update the screen
    window.socket.on "update_log", (username, data) ->
      $("#roulette_index_log").append "<div class=roulette_index_log_item>" + username + ": " + data + "</div>"
      $("#roulette_index_log").animate
        scrollTop: $("#roulette_index_log").prop("scrollHeight")
      , 500

    # Whenever the user list is updated, this function update the screen
    window.socket.on "update_users", (data) ->
      # Make an array of the remote users
      window.remote_users = $.map(data, (key, value) ->
        value
      )

      # Remove all click events
      $(".roulette_index_item_button_request").unbind "click"

      # Loop on each user to see if there is a new user, if there is a new user, update it on screen
      $.each data, (user_id, value) ->

        if $.inArray(user_id, window.local_users) is -1
          # The user is not on the local cache, add it
          window.local_users.push user_id
          # Add the user to the list view
          add_user_to_list_view(user_id)

      # Loop though the array of connected users to see if a user was removed
      $.each window.local_users, (index, user_id) ->
        if $.inArray(user_id, window.remote_users) is -1
          idx = $.inArray(user_id, window.local_users)
          unless idx is -1
            $("#roulette_index_users_item_" + user_id).fadeOut "fast", ->
              $("#roulette_index_users_item_" + user_id).remove()

      # Finally, the local cache is equal to the remote cache
      window.local_users = window.remote_users

    # Disconnect Button
    $("#roulette_index_button_disconnect").click ->
      # Close socket connection
      window.socket.disconnect()

      # Clear local cache of local and remote users
      window.local_users = []
      window.remote_users = []

      # HTML
      $("#roulette_index_users").empty()
      $("#roulette_index_log").append "<div class=roulette_index_log_item>You have disconnected.</div>"
      $("#roulette_index_button_connect_text").html "Connect"
      $("#roulette_index_button_connect").attr "disabled", false
      $("#roulette_index_button_disconnect").attr "disabled", true

