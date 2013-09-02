!function(t){"use strict";t.fn.bootstrapSwitch=function(e){var a={init:function(){return this.each(function(){var e,a,i,n,s,o,c=t(this),d="",r=c.attr("class"),h="ON",l="OFF",u=!1;t.each(["switch-mini","switch-small","switch-large"],function(t,e){r.indexOf(e)>=0&&(d=e)}),c.addClass("has-switch"),void 0!==c.data("on")&&(s="switch-"+c.data("on")),void 0!==c.data("on-label")&&(h=c.data("on-label")),void 0!==c.data("off-label")&&(l=c.data("off-label")),void 0!==c.data("icon")&&(u=c.data("icon")),a=t("<span>").addClass("switch-left").addClass(d).addClass(s).html(h),s="",void 0!==c.data("off")&&(s="switch-"+c.data("off")),i=t("<span>").addClass("switch-right").addClass(d).addClass(s).html(l),n=t("<label>").html("&nbsp;").addClass(d).attr("for",c.find("input").attr("id")),u&&n.html('<i class="'+u+'"></i>'),e=c.find(":checkbox").wrap(t("<div>")).parent().data("animated",!1),c.data("animated")!==!1&&e.addClass("switch-animate").data("animated",!0),e.append(a).append(n).append(i),c.find(">div").addClass(c.find("input").is(":checked")?"switch-on":"switch-off"),c.find("input").is(":disabled")&&t(this).addClass("deactivate");var f=function(t){t.siblings("label").trigger("mousedown").trigger("mouseup").trigger("click")};c.on("keydown",function(e){32===e.keyCode&&(e.stopImmediatePropagation(),e.preventDefault(),f(t(e.target).find("span:first")))}),a.on("click",function(){f(t(this))}),i.on("click",function(){f(t(this))}),c.find("input").on("change",function(e){var a=t(this),i=a.parent(),n=a.is(":checked"),s=i.is(".switch-off");e.preventDefault(),i.css("left",""),s===n&&(n?i.removeClass("switch-off").addClass("switch-on"):i.removeClass("switch-on").addClass("switch-off"),i.data("animated")!==!1&&i.addClass("switch-animate"),i.parent().trigger("switch-change",{el:a,value:n}))}),c.find("label").on("mousedown touchstart",function(e){var a=t(this);o=!1,e.preventDefault(),e.stopImmediatePropagation(),a.closest("div").removeClass("switch-animate"),a.closest(".has-switch").is(".deactivate")?a.unbind("click"):(a.on("mousemove touchmove",function(e){var a=t(this).closest(".switch"),i=(e.pageX||e.originalEvent.targetTouches[0].pageX)-a.offset().left,n=100*(i/a.width()),s=25,c=75;o=!0,s>n?n=s:n>c&&(n=c),a.find(">div").css("left",n-c+"%")}),a.on("click touchend",function(e){var a=t(this),i=t(e.target),n=i.siblings("input");e.stopImmediatePropagation(),e.preventDefault(),a.unbind("mouseleave"),o?n.prop("checked",!(parseInt(a.parent().css("left"))<-25)):n.prop("checked",!n.is(":checked")),o=!1,n.trigger("change")}),a.on("mouseleave",function(e){var a=t(this),i=a.siblings("input");e.preventDefault(),e.stopImmediatePropagation(),a.unbind("mouseleave"),a.trigger("mouseup"),i.prop("checked",!(parseInt(a.parent().css("left"))<-25)).trigger("change")}),a.on("mouseup",function(e){e.stopImmediatePropagation(),e.preventDefault(),t(this).unbind("mousemove")}))})})},toggleActivation:function(){t(this).toggleClass("deactivate")},isActive:function(){return!t(this).hasClass("deactivate")},setActive:function(e){e?t(this).removeClass("deactivate"):t(this).addClass("deactivate")},toggleState:function(e){var a=t(this).find("input:checkbox");a.prop("checked",!a.is(":checked")).trigger("change",e)},setState:function(e,a){t(this).find("input:checkbox").prop("checked",e).trigger("change",a)},status:function(){return t(this).find("input:checkbox").is(":checked")},destroy:function(){var e,a=t(this).find("div");return a.find(":not(input:checkbox)").remove(),e=a.children(),e.unwrap().unwrap(),e.unbind("change"),e}};return a[e]?a[e].apply(this,Array.prototype.slice.call(arguments,1)):"object"!=typeof e&&e?(t.error("Method "+e+" does not exist!"),void 0):a.init.apply(this,arguments)}}(jQuery),$(function(){$(".switch").bootstrapSwitch()});