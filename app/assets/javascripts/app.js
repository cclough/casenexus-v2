/////////////////////////////////////////////////////////////////
///////////////////// GLOBAL FUNCTIONS //////////////////////////
/////////////////////////////////////////////////////////////////


function getQueryParams(qs) {
    qs = qs.split("+").join(" ");

    var params = {}, tokens,
        re = /[?&]?([^=]+)=([^&]*)/g;

    while (tokens = re.exec(qs)) {
        params[decodeURIComponent(tokens[1])]
            = decodeURIComponent(tokens[2]);
    }

    return params;
}


/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////



$(document).ready(function(){

	$("input:checkbox").uniform();

	$('input, textarea').placeholder();

  $('#modal_help').modal({
    backdrop: false,
    show: false
  });

  $('#header_link_help').click(function() {
  	$('.modal').modal('hide');
    $('#modal_help').modal('show');
  });




  var ArrowNav = {
    init: function() {
      $("a[href*=#]").click(function(e) {

        e.preventDefault();
        if($(this).attr("href").split("#")[1]) {
          ArrowNav.goTo($(this).attr("href").split("#")[1]);
        }

      });
      this.goTo("1");
    },
    goTo: function(page) {
      var next_page = $("#application_arrownav_page_"+page);
      var nav_item = $('nav ul li a[href=#'+page+']');

      $("nav ul li").removeClass("current");
      nav_item.parent().addClass("current");

      $(".arrownav_page").hide();

      $(".arrownav_page").removeClass("current");
      next_page.addClass("current");
      next_page.fadeIn(500);

      ArrowNav.centerArrow(nav_item);
      
    },
    centerArrow: function(nav_item, animate) {
      var left_margin = (nav_item.parent().position().left + nav_item.parent().width()) + 24 - (nav_item.parent().width() / 2);
      if(animate != false) {
        $("nav .arrow").animate({
          left: left_margin - 8
        }, 500, function() { $(this).show(); });
      } else {
        $("nav .arrow").css({ left: left_margin - 8 });
      }
    }

  };

  ArrowNav.init();

});