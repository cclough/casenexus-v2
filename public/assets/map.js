!function(){var e,n;window.map_index_map_markers=[],window.map=null,window.infobox=null,window.map_index_map_pan=function(e){return window.map.panToWithOffset(e,0,-30),window.map.setZoom(6)},google.maps.Map.prototype.panToWithOffset=function(e,n,a){var i,o;return i=this,o=new google.maps.OverlayView,o.onAdd=function(){var o,r;return r=this.getProjection(),o=r.fromLatLngToContainerPixel(e),o.x=o.x+n,o.y=o.y+a,i.panTo(r.fromContainerPixelToLatLng(o))},o.draw=function(){},o.setMap(this)},window.map_index_profile_bless=function(){return window.map_index_user_profile_chart_activity_draw(),$("#map_index_user_profile_button_message").click(function(){var e;return e=$(this).data("friend_id"),window.modal_message_show(e)}),$("#map_index_user_profile_button_event").click(function(){var e;return e=$(this).data("friend_id"),window.modal_event_new_show(e,null)}),$("#map_index_user_profile_button_friendrequest").click(function(){var e;return e=$(this).data("friend_id"),window.modal_friendship_req_show(e)}),$("#map_index_user_profile_small_showfull").click(function(){var e;return $("#map_index_container_user_profile_small").fadeOut("fast"),e=$(this).data("user_id"),$.ajax({url:"/members/"+e,success:function(e){return $("#map_index_container_user_profile").html(e),$("#map_index_container_user_profile").show("slide",{direction:"down"},"fast",function(){return map_index_profile_bless()})}})})},window.map_index_profile_toggle=function(e){return $.ajax({url:"/members/"+e,success:function(e){return $("#map_index_container_user_profile").html(e),$("#map_index_container_user_profile").show("slide",{direction:"down"},"fast",function(){return map_index_profile_bless()})}})},window.map_index_load_profile_small=function(e){var n;return n=map_index_map_markers[e],$.ajax({url:"/members/"+e+"/show_small",success:function(e){return $("#map_index_container_user_profile_small").html(e),$("#map_index_container_user_profile_small").show("fast",function(){return window.map_index_profile_bless()})}})},window.map_index_load_infobox=function(e){var n,a;return n=$("<div></div>"),n.html("<img src=/assets/markers/arrow.png></img>"),window.infobox.setContent(n.html()),$("#map_index_container_user_infobox").click(function(){return $("#map_index_container_user_infobox").fadeOut("fast",function(){return window.infobox.close()})}),a=map_index_map_markers[e],window.infobox.open(map,a)},window.map_index_users_updatelist=function(){return $.get("/members",$("#map_index_users_form").serialize(),null,"script"),!1},window.map_index_users_resetfilters=function(e){return"country"!==e&&($("#map_index_users_form_pulldown_country_button").html("All Countries <span class=caret></span>"),$("#users_filter_country").val("")),"university"!==e&&($("#map_index_users_form_pulldown_university_button").html("All Universities <span class=caret></span>"),$("#users_filter_university").val("")),"language"!==e?($("#map_index_users_form_pulldown_language_button").html("All Languages <span class=caret></span>"),$("#users_filter_language").val("")):void 0},window.map_index_users_search=function(){return $("#map_index_users_form_search_field").val($("#header_nav_search_field").val()),map_index_users_updatelist()},n=function(){var e;return e=Math.round(Math.log($("#map_index_map").width()/512))+1+1},window.map_index_map_load_all=function(e,n,a){var i;return i=new google.maps.LatLng(n,a),window.map_index_map_pan(i),window.map_index_load_profile_small(e)},e=function(){var e,n;if(e=0,n){for(;1e3>e;)void 0!==n[e]&&(n[e].setMap(null),e++);return n=[]}},window.map_index_map_markers_draw=function(){return e(),$.getJSON("members",$("#map_index_users_form").serialize(),function(e){return $.each(e,function(e,n){var a;return a=new google.maps.MarkerImage("/assets/markers/marker_"+n.level+".png"),n=new google.maps.Marker({id:n.id,map:map,position:new google.maps.LatLng(parseFloat(n.lat),parseFloat(n.lng)),icon:a,animation:google.maps.Animation.DROP}),google.maps.event.addListener(n,"mouseover",function(){return map_index_load_infobox(n.id)}),google.maps.event.addListener(n,"click",function(){return window.map_index_map_load_all(n.id,n.lat,n.lng)}),map_index_map_markers[n.id]=n})})},window.map_index_user_profile_chart_activity_draw=function(){var e,n,a,i,o;return a=void 0,a=new AmCharts.AmSerialChart,a.dataProvider=map_index_user_profile_chart_activity_data,a.categoryField="week",a.rotate=!1,n=a.categoryAxis,n.gridPosition="start",n.axisColor="#DADADA",n.fillAlpha=0,n.gridAlpha=0,n.fillColor="#FAFAFA",n.labelsEnabled=!1,o=new AmCharts.ValueAxis,o.gridAlpha=0,o.dashLength=1,o.inside=!0,o.integersOnly=!0,o.labelsEnabled=!1,o.maximum=5,o.axisAlpha=0,a.addValueAxis(o),i=new AmCharts.AmGraph,i.title="Count",i.valueField="count",i.type="column",i.labelPosition="bottom",i.color="#000000",i.fontSize=10,i.labelText="[[category]]",i.balloonText="[[category]]: [[value]]",i.lineAlpha=0,e=a.balloon,e.adjustBorderColor=!0,e.cornerRadius=5,e.showBullet=!1,e.fillColor="#000000",e.fillAlpha=.7,e.color="#FFFFFF",i.fillColors="#1ABC9C",i.fillAlphas=1,a.addGraph(i),a.write("map_index_user_profile_small_chart_activity")},$(document).ready(function(){var e,a,i;return map_index_users_updatelist(),$("#header_nav_search_form").on("submit",function(){return window.map_index_users_search()}),$("#map_index_users_form input").keypress(function(e){return 13===e.which?map_index_users_updatelist():void 0}),$("#modal_message, #modal_friendship_req, #modal_event").modal({backdrop:!1,show:!1}),$("#map_index_users_form_view_world_button").click(function(){var e;return e=new google.maps.LatLng(0,0),window.map.setCenter(e),window.map.setZoom(n())}),$("#map_index_users_form_view_local_button").click(function(){return window.map_index_map_pan(window.map_index_map_latlng_start)}),$(".map_index_users_form_pulldown a").click(function(){var e,n,a,i;return e=$(this).data("category"),n=$(this).data("radio"),$("input[name=users_listtype]:eq("+n+")").prop("checked",!0),i=$(this).data("id"),$("#users_filter_"+e).val(i),map_index_users_updatelist(),a=$(this).data("name"),$("#map_index_users_form_pulldown_"+e+"_button").html(a+"  <span class=caret></span>"),$(".map_index_users_form_pulldown_button, .map_index_users_form_button").removeClass("active"),$("#map_index_users_form_pulldown_"+e+"_button").addClass("active"),$(".map_index_users_form_pulldown a").removeClass("hovered"),$(this).addClass("hovered"),$(this).parent().parent().parent().removeClass("open"),map_index_users_resetfilters(e)}),$(".map_index_users_form_button").click(function(){var e;return e=$(this).data("radio"),$("input[name=users_listtype]:eq("+e+")").attr("checked","checked"),$(".map_index_users_form_pulldown_button, .map_index_users_form_button").removeClass("active"),$(this).addClass("active"),map_index_users_updatelist()}),$(".pagination a").click(function(){return $.getScript(this.href),!1}),"string"==typeof map_index_map_lat_start&&(window.map_index_map_latlng_start=new google.maps.LatLng(map_index_map_lat_start,map_index_map_lng_start),i=n(),e={center:new google.maps.LatLng(0,0),zoom:i,minZoom:i,mapTypeId:"roadmap",disableDefaultUI:!0,zoomControl:!0,zoomControlOptions:{position:google.maps.ControlPosition.LEFT_CENTER},styles:[{featureType:"water",stylers:[{color:"#abe2ff"}]},{featureType:"landscape.natural",elementType:"all",stylers:[{color:"#88ff90"},{lightness:3}]}]},window.map=new google.maps.Map(document.getElementById("map_index_map"),e),window.infobox=new InfoBox({pixelOffset:new google.maps.Size(-50,-200)}),google.maps.event.addDomListener(map,"tilesloaded",function(){return 0===$("#map_index_map_zoomcontrol").length?($("div.gmnoprint").last().parent().wrap('<div id="map_index_map_zoomcontrol" />'),$("div.gmnoprint").fadeIn(500)):void 0}),window.map_index_map_markers_draw(),window.map_index_load_profile_small(2),window.map_index_load_infobox(map_index_map_marker_id_start)),a=function(e){var n;return n=e.getPosition(),window.map.panToWithOffset(n,150,0),e.setAnimation(google.maps.Animation.BOUNCE),setTimeout(function(){return e.setAnimation(null)},1440)}})}.call(this);