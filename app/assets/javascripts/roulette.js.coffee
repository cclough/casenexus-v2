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
  roulette_index_users_local = []
  roulette_index_users_remote = []

  # Connect Button
  $("#roulette_index_button_connect").click ->
    # HTML Updates
    $("#roulette_index_button_connect").attr "disabled", true
    $("#roulette_index_button_connect_text").html "Connecting..."

    # Connect the soccekt
    #socket = io.connect("http://127.0.0.1:80", secure: false, "force_new_connection": true)
    socket = io.connect("https://cclough.nodejitsu.com", secure: true, "force new connection": true)

    # On connection to server, ask for user's name with an anonymous callback
    socket.on "connect", ->
      # Send serder addUser the id of the current user
      socket.emit "adduser", { id: roulette_index_user_id, name: roulette_index_user_name }
      # HTML
      $("#roulette_index_button_connect_text").html "Connected"
      $("#roulette_index_button_disconnect").attr "disabled", false


    # Listens for private message (roulette request)
    socket.on "private", (data) ->
      $.get "/get_request?id=" + data.from + "&msg=" + data.msg, (data_request) ->
        $("#modal_roulette_req").html data_request
        $("#modal_roulette_req").modal "show"
        $(".modal_roulette_req_skype").tooltip()

    # Whenever server fires update_log, this function update the screen
    socket.on "update_log", (username, data) ->
      $("#roulette_index_log").append "<div class=roulette_index_log_item>" + username + ": " + data + "</div>"
      $("#roulette_index_log").animate
        scrollTop: $("#roulette_index_log").prop("scrollHeight")
      , 500

    # Whenever the user list is updated, this function update the screen
    socket.on "update_users", (data) ->

      # Remove all click events
      $(".roulette_index_item_button_request").unbind "click"

      # Loop on each user to see if there is a new user, if there is a new user, update it on screen
      $.each data, (key_remote, value) ->
        if $.inArray(key_remote, roulette_index_users_local) is -1
          # The user is not on the local cache, add it
          roulette_index_users_local.push key_remote

          # Get the UI for the new user, add it on screen, attach click actions
          $.get "/get_item?id=" + key_remote, (data_item) ->
            $("#roulette_index_users").append "<div class=roulette_index_users_item data-socket_id=" + key_remote + " id=roulette_index_users_item_" + key_remote + ">" + data_item + "</div>"
            $("#roulette_index_users_item_" + key_remote).fadeIn "fast"

            # Send request button
            $("#roulette_index_users_item_" + key_remote + " .roulette_index_users_item_button_request").click ->
              target_user_id = $(this).attr("data-user_id")
              socket.emit "private",
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

      # Make an array of the remote users
      roulette_index_users_remote = $.map(data, (key, value) ->
        key
      )

      # Loop though the array of connected users to see if a user was removed
      $.each roulette_index_users_local, (index, key_local) ->
        if $.inArray(key_local, roulette_index_users_remote) is -1

          idx = $.inArray(key_local, roulette_index_users_local)
          unless idx is -1
            $("#roulette_index_users_item_" + key_local).fadeOut "fast", ->
              $("#roulette_index_users_item_" + key_local).remove()

      # Finally, the local cache is equal to the remote cache
      roulette_index_users_local = roulette_index_users_remote

    # Disconnect Button
    $("#roulette_index_button_disconnect").click ->
      # Close socket connection
      socket.disconnect()

      # Clear local cache of local and remote users
      roulette_index_users_local = []
      roulette_index_users_remote = []

      # HTML
      $("#roulette_index_users").empty()
      $("#roulette_index_log").append "<div class=roulette_index_log_item>You have disconnected.</div>"
      $("#roulette_index_button_connect_text").html "Connect"
      $("#roulette_index_button_connect").attr "disabled", false
      $("#roulette_index_button_disconnect").attr "disabled", true

