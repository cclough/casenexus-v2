$(document).ready(function(){

  $("#roulette_index_button_connect").attr("disabled", false);
  $("#roulette_index_button_disconnect").attr("disabled", true);

  var roulette_index_users_local = [];

  // Connect Button
  $("#roulette_index_button_connect").click(function() {

    $("#roulette_index_button_connect").attr("disabled", true);
    $("#roulette_index_button_connect_text").html("Connecting...");

    // force new connection to enable reconnect - might be messy - https://github.com/LearnBoost/socket.io-client/issues/251
    var socket = io.connect('https://cclough.nodejitsu.com', {secure: true, 'force new connection': true});



    // on connection to server, ask for user's name with an anonymous callback
    socket.on('connect', function(){
    	
      // call the server-side function 'adduser' and send one parameter (value of prompt)
    	socket.emit('adduser', roulette_index_user_id);

      $("#roulette_index_button_connect_text").html("Connected");
      $("#roulette_index_button_disconnect").attr("disabled", false);

    });


    // listener for private message (roulette request)
    socket.on("private", function(data) {  

      // $('#modal_roulette_req_from').html(data.from);
      // $('#modal_roulette_req_to').html(data.to);
      // $('#modal_roulette_req_msg').html(data.msg);

      // $('#modal_roulette_req').modal('show');
      
      //$('#roulette_index_log').append('<div class=roulette_index_log_item>' + data.from + ' sent a message to ' + data.to + ': ' + data.msg + '</div>');
      
      //alert('hello');
    });

    // listener, whenever the server emits 'updatechat', this updates the chat body
    socket.on('updatelog', function (username, data) {
    	$('#roulette_index_log').append('<div class=roulette_index_log_item>'+username + ': ' + data + '</div>');
    });




    // listener, whenever the server emits 'updateusers', this updates the username list
    socket.on('updateusers', function(data) {

      // loop through remote to see if any new users, if so, add them
      $.each(data, function(key_remote, value) {

        if ($.inArray(key_remote, roulette_index_users_local) === -1) {

          roulette_index_users_local.push(key_remote);

          $.get('/get_item?id=' + key_remote, function(data_item) {
            $('#roulette_index_users').append('<div class=roulette_index_users_item data-socket_id='+key_remote+' id=roulette_index_users_item_'+key_remote+'>' + data_item + '</div>');
            $('#roulette_index_users_item_' + key_remote).fadeIn('fast');


            // Request send (private message)
            $(".roulette_index_item_button_request").click(function() {
          
              var target_user_id = $(this).attr('data-user_id');

              $('#testing123').html(target_user_id)

              //socket.emit("private", { msg: "Request to skype", to: target_user_id });

            });


          });

        }

      });

      // make array of remote users
      var roulette_index_users_remote = $.map(data, function(key, value) { return key; });

      // loop through local to see if any missing users, if so, remove them
      $.each(roulette_index_users_local, function(index, key_local) {

        if ($.inArray(key_local, roulette_index_users_remote) === -1) {

          //var idx = roulette_index_users_local.indexOf(key_local); // Find the index

          var idx = $.inArray(key_local, roulette_index_users_local);

          if(idx!=-1) {
            
            roulette_index_users_local.splice(idx, 1);

            $('#roulette_index_users_item_' + key_local).fadeOut('fast', function() {
              $('#roulette_index_users_item_' + key_local).remove();
            });

          };

        };

      });


    });




    // Disconnect Button
    $("#roulette_index_button_disconnect").click(function() {
      
        socket.disconnect();

        roulette_index_users_local = [];
        roulette_index_users_remote = [];

        // to enable reconnect https://github.com/LearnBoost/socket.io-client/issues/251
        // delete io.sockets['https://cclough.nodejitsu.com'];
        // io.j = [];
        
        $('#roulette_index_users').empty();
        $('#roulette_index_log').append('<div class=roulette_index_log_item>You have disconnected.</div>');

        $("#roulette_index_button_connect_text").html("Connect");
        $("#roulette_index_button_connect").attr("disabled", false);
        $("#roulette_index_button_disconnect").attr("disabled", true);

    });




  });

});