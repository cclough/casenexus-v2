!function(){var e;e=function(){return $("#map_index_users_form_button_posts_new").click(function(){return window.modal_post_show()})},window.map_index_users_item_bless=function(){return $(".map_index_users_item_button_message").click(function(){var e;return e=$(this).data("friend_id"),window.modal_message_show(e)}),$(".map_index_users_item_button_event").click(function(){var e;return e=$(this).data("friend_id"),window.modal_event_new_show(e,null)}),$(".map_index_users_item_button_add").click(function(){var e;return e=$(this).data("friend_id"),window.modal_friendship_req_show(e)}),window.application_truncatables()},window.map_index_users_updatelist=function(){return $("#map_index_guide_text").fadeOut("fast"),$("#map_index_users_empty").fadeOut(100),$("#map_index_users_spinner_container").fadeIn("fast"),$.get("/members",$("#map_index_users_form").serialize(),null,"script"),$("#map_index_map_guide").fadeOut("fast")},window.map_index_users_search=function(){return $("#map_index_users_form_search_field").val($("#header_nav_search_field").val()),map_index_users_updatelist()},window.map_index_marker_and_popup_actions_for=function(e,i){var a;if("temp"===i){if(!window.current_active_marker)return a=map_index_generate_popup_for(e),a.openOn(map);if(window.current_active_marker!==e)return a=map_index_generate_popup_for(e),a.openOn(map)}else if("perm"===i)return window.current_active_marker?window.current_active_marker===e?(map.removeLayer(window.current_active_popup),e.setIcon(L.icon(e.feature.properties.icon)),window.current_active_marker=null,window.current_active_popup=null):(window.current_active_marker.setIcon(L.icon(current_active_marker.feature.properties.icon)),map.removeLayer(window.current_active_popup),map_index_activate_perm_popup_and_icon_for(e)):map_index_activate_perm_popup_and_icon_for(e)},window.map_index_activate_perm_popup_and_icon_for=function(e){var i,a;return a=map_index_generate_popup_for(e),map.addLayer(a),i=L.icon({iconUrl:"/assets/markers/marker_active_"+e.feature.properties.university_image,iconSize:[35,51],iconAnchor:[17,51]}),e.setIcon(i),window.current_active_marker=e,window.current_active_popup=a},window.map_index_generate_popup_for=function(e){var i,a,_;return i=e.feature,_='<div class="map_index_map_popup">   <div class="map_index_map_popup_avatar">     <img src="/assets/universities/'+i.properties.university_image+'" class="application_userimage_medium">'+"   </div>"+'   <div class="map_index_map_popup_info">'+'     <div class="map_index_map_popup_username">'+i.properties.username+"</div>"+'     <div class="map_index_map_popup_university">'+i.properties.university_name+"</div>"+"   </div>"+'   <div class="map_index_map_popup_cases">'+'     <div class="map_index_users_item_cases_recd">'+'         <div class="map_index_users_item_cases_text">taken</div>'+i.properties.cases_recd+"     </div>"+'     <div class="map_index_users_item_cases_givn">'+'         <div class="map_index_users_item_cases_text">given</div>'+i.properties.cases_givn+"     </div>"+'     <div class="map_index_users_item_cases_external">'+'         <div class="map_index_users_item_cases_text">ext</div>'+i.properties.cases_ext+"     </div>"+"   </div>"+"</div>",a=L.popup({closeButton:!1,minWidth:130,offset:new L.Point(0,-49),autoPan:!1,zoomAnimation:!0}).setLatLng(e.getLatLng()).setContent(_)},$(document).ready(function(){var e,i,a,_;return $("#map_index_users_form input").keypress(function(e){return 13===e.which?map_index_users_updatelist():void 0}),$("#map_index_users_form_button_posts_new").click(function(){return $("#modal_post").hasClass("in")?void 0:($(".modal").modal("hide"),$("#modal_post").on("shown",function(){return window.application_spinner_prime(".modal.in")}),$("#modal_post").modal("show"))}),$(".map_index_users_form_button").click(function(){var e;return $(".map_index_users_form_pulldown_button, .map_index_users_form_button").removeClass("active"),$(this).addClass("active"),e=$(this).data("radio"),$("input[name=users_listtype]:eq("+e+")").prop("checked",!0),map_index_users_updatelist()}),$(".map_index_users_form_button_switch").click(function(){var e,i;return $(this).parent().find(".map_index_users_form_button_switch").removeClass("active"),i=$(this).data("switch_name"),$(".map_index_users_form_button_"+i).removeClass("active"),$(this).addClass("active"),e=$(this).data("choice_id"),$("#users_filter_"+i).val(e),map_index_users_updatelist()}),$("#map_index_users_container .pagination a").click(function(){return $.getScript(this.href),!1}),"string"==typeof map_index_map_lat_start?(map_index_users_updatelist(),window.map=L.mapbox.map("map_index_map","christianclough.map-pzcx86x2"),i=parseFloat(map_index_map_lat_start),a=parseFloat(map_index_map_lng_start),window.map.setView([i-.005,a+.03],15),$("#map_index_map_zoomout").click(function(){return window.map.setZoom(2),$(this).fadeOut("fast")}),_=L.mapbox.markerLayer(),e=[{type:"Feature",geometry:{type:"Point",coordinates:[parseFloat(map_index_map_lng_start),parseFloat(map_index_map_lat_start)]},properties:{title:"self user",icon:{iconUrl:"/assets/markers/user_location.png",iconSize:[78,78],iconAnchor:[39,39],popupAnchor:[0,-25]}}}],_.on("layeradd",function(e){var i,a;return a=e.layer,i=a.feature,a.setIcon(L.icon(i.properties.icon))}),_.addTo(map),_.setGeoJSON(e)):void 0})}.call(this);