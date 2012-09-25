$(document).ready(function(){


  $("#roulette_index_button_connect").click(function() {

    var socket = io.connect('https://cclough.nodejitsu.com', {secure: true});

    // on connection to server, ask for user's name with an anonymous callback
    socket.on('connect', function(){
    	// call the server-side function 'adduser' and send one parameter (value of prompt)
    	socket.emit('adduser', roulette_index_user_id);

      // $("#roulette_index_button_connect").attr("disabled", true);
      // $("#roulette_index_button_disconnect").attr("disabled", false);
    });

    // listener, whenever the server emits 'updatechat', this updates the chat body
    socket.on('updatelog', function (username, data) {
    	$('#roulette_index_log').append('<div class=roulette_index_log_item>'+username + ': ' + data + '</div>');
    });

    // listener, whenever the server emits 'updateusers', this updates the username list
    socket.on('updateusers', function(data) {

    	$('#roulette_index_users').empty();

    	$.each(data, function(key, value) {

        $.get('/get_item?id=' + key, function(data) {

          $('#roulette_index_users').append('<div class=roulette_index_users_item id=roulette_index_users_item_'+key+'>' + data + '</div>');
          
          $('#roulette_index_users_item_' + key).fadeIn('fast');

        });

    	});
      
    });


  });

  $("#roulette_index_button_disconnect").click(function() {
    
    var socket = io.connect('https://cclough.nodejitsu.com', {secure: true});

    socket.on('connect', function () {
      socket.disconnect();

      // $("#roulette_index_button_connect").attr("disabled", false);
      // $("#roulette_index_button_disconnect").attr("disabled", true);
    });

  });



});