$(document).ready(function(){

  $("#roulette_index_button_connect").attr("disabled", false);
  $("#roulette_index_button_disconnect").attr("disabled", true);

  var roulette_index_users_local = [];


  // Connect Button
  $("#roulette_index_button_connect").click(function() {

    $("#roulette_index_button_connect").attr("disabled", true);
    $("#roulette_index_button_connect_text").html("Connecting...");

    var socket = io.connect('https://cclough.nodejitsu.com', {secure: true});

    // on connection to server, ask for user's name with an anonymous callback
    socket.on('connect', function(){
    	
      // call the server-side function 'adduser' and send one parameter (value of prompt)
    	socket.emit('adduser', roulette_index_user_id);

      $("#roulette_index_button_connect_text").html("Connected");
      $("#roulette_index_button_disconnect").attr("disabled", false);

    });

    // listener, whenever the server emits 'updatechat', this updates the chat body
    socket.on('updatelog', function (username, data) {
    	$('#roulette_index_log').append('<div class=roulette_index_log_item>'+username + ': ' + data + '</div>');
    });

    // listener, whenever the server emits 'updateusers', this updates the username list
    socket.on('updateusers', function(data) {


      $.each(data, function(key_remote, value) {

        if ($.inArray(key_remote, roulette_index_users_local) === -1) {

          roulette_index_users_local.push(key_remote);

          $.get('/get_item?id=' + key_remote, function(data_item) {
            $('#roulette_index_users').append('<div class=roulette_index_users_item id=roulette_index_users_item_'+key_remote+'>' + data_item + '</div>');
            $('#roulette_index_users_item_' + key_remote).fadeIn('fast');
          });

        }

      });


      var roulette_index_users_remote = $.map(data, function(key, value) { return key; });


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

        // to enable reconnect https://github.com/LearnBoost/socket.io-client/issues/251
        delete io.sockets['https://cclough.nodejitsu.com'];
        io.j = [];
        
        $('#roulette_index_users').empty();
        $('#roulette_index_log').append('<div class=roulette_index_log_item>You have disconnected.</div>');

        $("#roulette_index_button_connect_text").html("Connect");
        $("#roulette_index_button_connect").attr("disabled", false);
        $("#roulette_index_button_disconnect").attr("disabled", true);

    });




  });

});