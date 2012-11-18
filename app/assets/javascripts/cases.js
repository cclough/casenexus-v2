/////////////////////////////////////////////////////////////////
///////////////////// GLOBAL FUNCTIONS //////////////////////////
/////////////////////////////////////////////////////////////////


// Update the User List - submits form...
function cases_index_cases_updatelist () {
  $.get($("#cases_index_cases_form").attr("action"), $("#cases_index_cases_form").serialize(), null, "script");
  return false;
}


function cases_index_case_link () {
  var query = getQueryParams(document.location.search);
  // alert(query.foo);

  if (query.id) {
  
    $.get("/cases/" + query.id, function(data) {
      $("#cases_index_case").html(data);


      // REPEATED IN INDEX.JS.ERB NOT DRY
      // RADAR BUTTONS
      $('#cases_show_chart_radar_button_all').click(function() {
        $('#cases_show_chart_radar').empty();
        cases_show_chart_radar_draw("all");
        $('#cases_show_chart_radar_button_all').addClass('active');
        $('#cases_show_chart_radar_button_combined').removeClass('active');
      });

      $('#cases_show_chart_radar_button_combined').click(function() {
        $('#cases_show_chart_radar').empty();
        cases_show_chart_radar_draw("combined");
        $('#cases_show_chart_radar_button_all').removeClass('active');
        $('#cases_show_chart_radar_button_combined').addClass('active');
      });

      cases_show_chart_radar_draw("all");
      
      cases_show_category_chart_radar_draw("businessanalytics");
      cases_show_category_chart_radar_draw("interpersonal");
      cases_show_category_chart_radar_draw("structure");
      ////////////

    });

  }

}


function cases_show_chart_radar_draw(radar_type) {

  var chart_show_radar;

  // RADAR CHART
  chart_show_radar = new AmCharts.AmRadarChart();

  if (radar_type == "all") {
    chart_show_radar.dataProvider = cases_show_chart_radar_data_all;
  } else if (radar_type == "combined") {
    chart_show_radar.dataProvider = cases_show_chart_radar_data_combined;    
  }

  chart_show_radar.categoryField = "criteria";
  // chart_show_radar.startDuration = 1;
  // chart_show_radar.startEffect = ">";
  // chart_show_radar.sequencedAnimation = true;
  chart_show_radar.color = "#FFFFFF";
  chart_show_radar.fontSize = 9;

  // VALUE AXIS
  var valueAxis = new AmCharts.ValueAxis();
  valueAxis.gridType = "circles";
  valueAxis.fillAlpha = 0.02;
  valueAxis.fillColor = "#000000"
  valueAxis.axisAlpha = 0.1;
  valueAxis.gridAlpha = 0.1;
  valueAxis.fontWeight = "bold"
  valueAxis.minimum = 0;
  valueAxis.maximum = 10;
  chart_show_radar.addValueAxis(valueAxis);

  // GUIDES
  // Blue - Business Analytics
  var guide = new AmCharts.Guide();
  guide.angle = 270;
  guide.toAngle = 390;
  guide.value = 3;
  guide.toValue = 2;
  guide.fillColor = "#0D8ECF";
  guide.fillAlpha = 0.3;
  valueAxis.addGuide(guide);

  // Green - Interpersonal
  guide = new AmCharts.Guide();
  guide.angle = 30;
  guide.toAngle = 150;
  guide.value = 3;
  guide.toValue = 2;
  guide.fillColor = "#B0DE09";
  guide.fillAlpha = 0.3;
  valueAxis.addGuide(guide);

  // Yellow - Structure
  guide = new AmCharts.Guide();
  guide.angle = 150;
  guide.toAngle = 270;
  guide.value = 3;
  guide.toValue = 2;
  guide.fillColor = "#FCD202";
  guide.fillAlpha = 0.3;
  valueAxis.addGuide(guide);

  // GRAPH
  var graph = new AmCharts.AmGraph();
  graph.lineColor = "#98cdff";
  graph.fillAlphas = 0.4;
  graph.bullet = "round";
  graph.valueField = "score";
  graph.balloonText = "[[category]]: [[value]]/10";
  graph.labelPosition = "right";
  chart_show_radar.addGraph(graph);

  // Balloon Settings
  var balloon = chart_show_radar.balloon;
  balloon.adjustBorderColor = true;
  balloon.color = "#000000";
  balloon.cornerRadius = 5;
  balloon.fillColor = "#000000";
  balloon.fillAlpha = 0.7;
  balloon.color = "#FFFFFF";

  // WRITE
  chart_show_radar.write('cases_show_chart_radar');

}

function cases_show_category_chart_radar_draw(category) {

  var chart_show_category_radar;

  // RADAR CHART
  chart_show_category_radar = new AmCharts.AmRadarChart();

  if (category == "businessanalytics") {
    chart_show_category_radar.dataProvider = cases_show_businessanalytics_chart_radar_data;
  } else if (category == "interpersonal") {
    chart_show_category_radar.dataProvider = cases_show_interpersonal_chart_radar_data;   
  } else if (category == "structure") {
    chart_show_category_radar.dataProvider = cases_show_structure_chart_radar_data;    
  }

  chart_show_category_radar.categoryField = "criteria";
  // chart_show_category_radar.startDuration = 1;
  // chart_show_category_radar.startEffect = ">";
  // chart_show_category_radar.sequencedAnimation = true;
  chart_show_category_radar.color = "#FFFFFF";
  chart_show_category_radar.fontSize = 9;

  // VALUE AXIS
  var valueAxis = new AmCharts.ValueAxis();
  valueAxis.gridType = "circles";
  valueAxis.fillAlpha = 0.02;
  valueAxis.fillColor = "#000000"
  valueAxis.axisAlpha = 0.1;
  valueAxis.gridAlpha = 0.1;
  valueAxis.fontWeight = "bold"
  valueAxis.minimum = 0;
  valueAxis.maximum = 10;
  valueAxis.radarCategoriesEnabled = false;
  chart_show_category_radar.addValueAxis(valueAxis);


  // GRAPH
  var graph = new AmCharts.AmGraph();
  graph.lineColor = "#98cdff";
  graph.fillAlphas = 0.4;
  graph.bullet = "round";
  graph.valueField = "score";
  graph.balloonText = "[[category]]: [[value]]/10";
  chart_show_category_radar.addGraph(graph);

  // Balloon Settings
  var balloon = chart_show_category_radar.balloon;
  balloon.adjustBorderColor = true;
  balloon.color = "#000000";
  balloon.cornerRadius = 5;
  balloon.fillColor = "#000000";
  balloon.fillAlpha = 0.7;
  balloon.color = "#FFFFFF";

  // WRITE
  if (category == "businessanalytics") {
    chart_show_category_radar.write('cases_show_businessanalytics_chart_radar');
  } else if (category == "interpersonal") {
    chart_show_category_radar.write('cases_show_interpersonal_chart_radar');  
  } else if (category == "structure") {
    chart_show_category_radar.write('cases_show_structure_chart_radar');   
  }

}



function cases_analysis_charts_draw(case_count) {

  ////////////////////////////////////////////
  // Progress chart javascript
  ////////////////////////////////////////////


  if (case_count == 0) {

    $("#cases_analysis_chart_radar_empty").fadeIn("fast");
    $("#cases_analysis_chart_progress_empty").fadeIn("fast");

  } else {
    
    $("#cases_analysis_chart_radar").fadeIn("fast");
    $("#cases_analysis_chart_progress").fadeIn("fast");
    $("#cases_analysis_chart_radar_buttongroup").fadeIn("fast");

    cases_analysis_chart_progress_data = [];

    // loop through model json, construct AM compatabile array + run parseDate
    $.getJSON("/cases/analysis", function(json) {

      $.each(json, function(i, item) {
        var dataObject = {id:json[i].id, date:parseDate(json[i].date), interpersonal:json[i].interpersonal, businessanalytics:json[i].businessanalytics, structure:json[i].structure, totalscore:json[i].totalscore};
        // load array for chart
        cases_analysis_chart_progress_data.push(dataObject); 
      });

    }).complete(function() {
      // DRAW BOTH CHARTS
      cases_analysis_chart_progress_draw(cases_analysis_chart_progress_data);
      cases_analysis_chart_radar_draw("all", case_count);
    });


    function cases_analysis_chart_progress_draw(data) {

      // Fade out loading bars
      $('.cases_analysis_loading').fadeOut('slow', function() {
        $('.cases_analysis_loading').remove();
      });

      var chart_analysis_progress;

      // SERIAL CHART
      chart_analysis_progress = new AmCharts.AmSerialChart();
      chart_analysis_progress.pathToImages = "/assets/amcharts/";
      // below from http://www.amcharts.com/javascript/line-chart-with-date-based-data/
      chart_analysis_progress.panEventsEnabled = true;
      chart_analysis_progress.zoomOutButton = {
          backgroundColor: "#000000",
          backgroundAlpha: 0.15
      };
      chart_analysis_progress.colors = ["#0D8ECF","#B0DE09","#FCD202"]
      chart_analysis_progress.dataProvider = data;
      chart_analysis_progress.categoryField = "date";
      
      // neccessary ?
      chart_analysis_progress.autoMargins = false;
      chart_analysis_progress.marginRight = 15;
      chart_analysis_progress.marginLeft = 25;
      chart_analysis_progress.marginBottom = 35;
      chart_analysis_progress.marginTop = 10;

      // animations
      chart_analysis_progress.startDuration = 0.3;
      chart_analysis_progress.startEffect = ">";
      chart_analysis_progress.sequencedAnimation = true;

      // AXES
      // Category
      var categoryAxis = chart_analysis_progress.categoryAxis;
      categoryAxis.gridAlpha = 0.07;
      categoryAxis.axisColor = "#DADADA";
      categoryAxis.startOnAxis = true;
      categoryAxis.labelRotation = 45;
      categoryAxis.parseDates = true;
      //http://www.amcharts.com/javascript/line-chart-with-date-based-data/
      categoryAxis.minPeriod = "DD"; // our data is daily, so we set minPeriod to DD

      // Value
      var valueAxis = new AmCharts.ValueAxis();
      valueAxis.stackType = "regular"; // this line makes the chart "stacked"
      valueAxis.gridAlpha = 0.07;
      valueAxis.axisAlpha = 0;
      // change to 50?
      valueAxis.maximum = 30;
      valueAxis.labelsEnabled = true;
      chart_analysis_progress.addValueAxis(valueAxis);

      // DONT FORGET YOU CAN USE 'GUIDES'

      // GRAPHS
      // first graph - Business Analytics
      var graph = new AmCharts.AmGraph();
      graph.type = "line";
      graph.title = "Business Analytics";
      graph.valueField = "businessanalytics";
      graph.lineAlpha = 1;
      graph.fillAlphas = 0.7; // setting fillAlphas to > 0 value makes it area graph
      graph.bullet = "round";

      addclicklistener(graph);

      chart_analysis_progress.addGraph(graph);

      // second graph - Interpersonal
      graph = new AmCharts.AmGraph();
      graph.type = "line";
      graph.title = "Interpersonal";
      graph.valueField = "interpersonal";
      graph.lineAlpha = 1;
      graph.fillAlphas = 0.7;
      graph.bullet = "round";

      addclicklistener(graph);

      chart_analysis_progress.addGraph(graph);

      // third graph - Structure
      graph = new AmCharts.AmGraph();
      graph.type = "line";
      graph.title = "Structure";
      graph.valueField = "structure";
      graph.lineAlpha = 1;
      graph.fillAlphas = 0.7;
      graph.bullet = "round";

      addclicklistener(graph);

      chart_analysis_progress.addGraph(graph);

      // Fourth graph - FOR ZOOMER - NOT DRAWN
      graph = new AmCharts.AmGraph();
      graph.type = "line";
      graph.title = "Total Score";
      graph.valueField = "totalscore";
      graph.lineAlpha = 1;
      graph.fillAlphas = 0.6;
      graph.bullet = "none";
      //graph.hidden = true;

      graph.showBalloon = false;
      graph.visibleInLegend = false;
      graph.fillAlphas = [0];
      graph.lineAlpha = 0;
      graph.includeInMinMax = false;
      
      chart_analysis_progress.addGraph(graph);

      // LEGEND
      var legend = new AmCharts.AmLegend();
      legend.position = "bottom";
      legend.align = "center"
      legend.rollOverGraphAlpha = "0.15";
      legend.color = '#f6f6f6';
      legend.horizontalGap = 5;
      legend.switchable = true;
      legend.valueWidth = 5;
      chart_analysis_progress.addLegend(legend);

      // CURSOR //////////
      // http://www.amcharts.com/javascript/line-chart-with-date-based-data/
      chartCursor = new AmCharts.ChartCursor();
      chartCursor.cursorPosition = "mouse";
      chartCursor.pan = true;
      chartCursor.bulletsEnabled = false;
      chartCursor.zoomable = false;
      chart_analysis_progress.addChartCursor(chartCursor);


      // Balloon Settings
      var balloon = chart_analysis_progress.balloon;
      balloon.adjustBorderColor = true;
      balloon.cornerRadius = 5;
      balloon.showBullet = false;
      balloon.fillColor = "#000000";
      balloon.fillAlpha = 0.7;
      balloon.color = "#FFFFFF";


      // SCROLLBAR
      // http://www.amcharts.com/javascript/line-chart-with-date-based-data/
      var chartScrollbar = new AmCharts.ChartScrollbar();
      chartScrollbar.graph = graph; // uses 'fifth graph' above - last to use graph variable
      chartScrollbar.autoGridCount = true;
      chartScrollbar.scrollbarHeight = 25;
      chartScrollbar.color = "#000000";
      chart_analysis_progress.addChartScrollbar(chartScrollbar);

      // WRITE
      chart_analysis_progress.write("cases_analysis_chart_progress");

    }

    // method to parse sql date string into AM compataible Date Object
    function parseDate(dateString) {
       // split the string get each field
      var dateArray = dateString.split("-");
      // now lets create a new Date instance, using year, month and day as parameters
      // month count starts with 0, so we have to convert the month number
      var date = new Date(Number(dateArray[0]), Number(dateArray[1]) - 1, Number(dateArray[2]));

      return date;
    }

    function addclicklistener(graph) {
      graph.addListener("clickGraphItem", function (event) {
          window.location = '/cases?id=' + event.item.dataContext.id;
      });
    }

  }

}


//////////////////////////////////////////////////////////
// Radar // Has to be global function for buttons to work
//////////////////////////////////////////////////////////

function cases_analysis_chart_radar_draw(radar_type, case_count) {

  var chart_analysis_radar;

  // RADAR CHART
  chart_analysis_radar = new AmCharts.AmRadarChart();

  if (radar_type == "all") {
    chart_analysis_radar.dataProvider = cases_analysis_chart_radar_data_all;
  } else if (radar_type == "combined") {
    chart_analysis_radar.dataProvider = cases_analysis_chart_radar_data_combined;    
  }

  chart_analysis_radar.categoryField = "criteria";
  chart_analysis_radar.startDuration = 0.3;
  chart_analysis_radar.startEffect = ">";
  chart_analysis_radar.sequencedAnimation = true;
  chart_analysis_radar.color = "#f6f6f6";
  chart_analysis_radar.colors = ["#000000","#3e00bd","#CC0000"]
  chart_analysis_radar.fontSize = 9;

  // GRAPH - ALL
  var graph = new AmCharts.AmGraph();
  graph.title = "All";
  graph.fillAlphas = 0.2;
  graph.bullet = "round"
  graph.valueField = "all"
  graph.balloonText = "[[category]]: [[value]]/10"
  chart_analysis_radar.addGraph(graph);

  // GRAPH - FIRST 5
  var graph = new AmCharts.AmGraph();
  graph.title = "First " + case_count;
  graph.fillAlphas = 0.2;
  graph.bullet = "round"
  graph.valueField = "first"
  graph.balloonText = "[[category]]: [[value]]/10"
  chart_analysis_radar.addGraph(graph);

  // GRAPH - LAST 5
  var graph = new AmCharts.AmGraph();
  graph.title = "Last " + case_count;
  graph.fillAlphas = 0.2;
  graph.bullet = "round"
  graph.valueField = "last"
  graph.balloonText = "[[category]]: [[value]]/10"
  chart_analysis_radar.addGraph(graph);

  // VALUE AXIS
  var valueAxis = new AmCharts.ValueAxis();
  valueAxis.gridType = "circles";
  valueAxis.fillAlpha = 0.02;
  valueAxis.fillColor = "#000000"
  valueAxis.axisAlpha = 0.1;
  valueAxis.gridAlpha = 0.1;
  valueAxis.fontWeight = "bold"
  valueAxis.minimum = 0;
  valueAxis.maximum = 10;
  chart_analysis_radar.addValueAxis(valueAxis);

  // GUIDES
  // Blue - Business Analytics
  var guide = new AmCharts.Guide();
  guide.angle = 270;
  guide.toAngle = 390;
  guide.value = 3;
  guide.toValue = 2;
  guide.fillColor = "#0D8ECF";
  guide.fillAlpha = 0.3;
  valueAxis.addGuide(guide);

  // Green - Interpersonal
  guide = new AmCharts.Guide();
  guide.angle = 30;
  guide.toAngle = 150;
  guide.value = 3;
  guide.toValue = 2;
  guide.fillColor = "#B0DE09";
  guide.fillAlpha = 0.3;
  valueAxis.addGuide(guide);

  // Yellow - Structure
  guide = new AmCharts.Guide();
  guide.angle = 150;
  guide.toAngle = 270;
  guide.value = 3;
  guide.toValue = 2;
  guide.fillColor = "#FCD202";
  guide.fillAlpha = 0.3;
  valueAxis.addGuide(guide);

  // Balloon Settings
  var balloon = chart_analysis_radar.balloon;
  balloon.adjustBorderColor = true;
  balloon.cornerRadius = 5;
  balloon.showBullet = false;
  balloon.fillColor = "#000000";
  balloon.fillAlpha = 0.7;
  balloon.color = "#FFFFFF";

  // Legend Settings
  var legend = new AmCharts.AmLegend();
  legend.position = "bottom";
  legend.align = "center";
  legend.color = '#f6f6f6';
  legend.markerType = "square";
  legend.rollOverGraphAlpha = 0;
  legend.horizontalGap = 5;
  legend.valueWidth = 5;
  legend.switchable = true;
  chart_analysis_radar.addLegend(legend);

  // WRITE
  chart_analysis_radar.write("cases_analysis_chart_radar");

}


/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


$(document).ready(function(){


/////////////////////////////////////////////////////////////////
//////////////////////////// INDEX //////////////////////////////
/////////////////////////////////////////////////////////////////


  $("#cases_index_cases_form input").keypress(function(e) {
    if(e.which == 13) {
      cases_index_cases_updatelist();
    }
  });


  // Ajax pagination
  $("#cases_index_cases .application_pagination a, #cases_index_cases_form_sort a").live("click", function() {
    $.getScript(this.href);
    return false;
  });


/////////////////////////////////////////////////////////////////
///////////////////////////// NEW ///////////////////////////////
/////////////////////////////////////////////////////////////////


  $(".cases_new_slider").slider({
    range: "min",
    step: 1,
    min: 1,
    max: 10,
    value: 1,
    slide: function(event, ui) {

      var cases_new_slider_name = $(this).attr("id").split('_');
      
      $("#cases_new_slider_input_" + cases_new_slider_name[3]).val(ui.value);

      cases_new_calculatescore($(this).attr("data-category"));
    }
  });

  $("#cases_new_datepicker").datepicker({dateFormst: 'dd/mm/yy'});
  // Put '{dateFormat: 'dd/mm/yy'}' in brackets to anglify
  
  $('[name="case[businessanalytics_comment]"]').wysihtml5({
    "emphasis": false, //Italics, bold, etc. Default true
    "font-styles": false, //Font styling, e.g. h1, h2, etc. Default true
    "link": false, //Button to insert a link. Default true
    "image": false //Button to insert an image. Default true
  });

  $('[name="case[interpersonal_comment]"]').wysihtml5({
    "emphasis": false, //Italics, bold, etc. Default true
    "font-styles": false, //Font styling, e.g. h1, h2, etc. Default true
    "link": false, //Button to insert a link. Default true
    "image": false //Button to insert an image. Default true
  });

  $('[name="case[structure_comment]"]').wysihtml5({
    "emphasis": false, //Italics, bold, etc. Default true
    "font-styles": false, //Font styling, e.g. h1, h2, etc. Default true
    "link": false, //Button to insert a link. Default true
    "image": false //Button to insert an image. Default true
  });

  $(".cases_new_popover").hover(
    function() {
      $(this).popover("show"); 
    },
    function() {
      $(this).popover("hide"); 
    }
  );

  $("#cases_new_popover").click(function() {
    $("#cases_new_popover").popover("show"); 
  });


  $(".cases_new_slider_input").change(function() {

    cases_new_calculatescore(this);

  });


  function cases_new_calculatescore (category) {

    if (category == "businessanalytics") {
      
      if ($('#cases_new_slider_input_quantitativebasics').val()) { var category_score_1 = parseInt($('#cases_new_slider_input_quantitativebasics').val()); } else { var category_score_1 = 0; }
      if ($('#cases_new_slider_input_problemsolving').val()) { var category_score_2 = parseInt($('#cases_new_slider_input_problemsolving').val()); } else { var category_score_2 = 0; }
      if ($('#cases_new_slider_input_prioritisation').val()) { var category_score_3 = parseInt($('#cases_new_slider_input_prioritisation').val()); } else { var category_score_3 = 0; }
      if ($('#cases_new_slider_input_sanitychecking').val()) { var category_score_4 = parseInt($('#cases_new_slider_input_sanitychecking').val()); } else { var category_score_4 = 0; }

      var category_score = (category_score_1 + category_score_2 + category_score_3 + category_score_4)/4;

      $('#cases_new_block_circle_text_businessanalytics').html(category_score);

    } else if (category == "interpersonal") {

      if ($('#cases_new_slider_input_rapport').val()) { var category_score_1 = parseInt($('#cases_new_slider_input_rapport').val()); } else { var category_score_1 = 0; }
      if ($('#cases_new_slider_input_articulation').val()) { var category_score_2 = parseInt($('#cases_new_slider_input_articulation').val()); } else { var category_score_2 = 0; }
      if ($('#cases_new_slider_input_concision').val()) { var category_score_3 = parseInt($('#cases_new_slider_input_concision').val()); } else { var category_score_3 = 0; }
      if ($('#cases_new_slider_input_askingforinformation').val()) { var category_score_4 = parseInt($('#cases_new_slider_input_askingforinformation').val()); } else { var category_score_4 = 0; }

      var category_score = (category_score_1 + category_score_2 + category_score_3 + category_score_4)/4;

      $('#cases_new_block_circle_text_interpersonal').html(category_score);

    } else if (category == "structure") {

      if ($('#cases_new_slider_input_approachupfront').val()) { var category_score_1 = parseInt($('#cases_new_slider_input_approachupfront').val()); } else { var category_score_1 = 0; }
      if ($('#cases_new_slider_input_stickingtostructure').val()) { var category_score_2 = parseInt($('#cases_new_slider_input_stickingtostructure').val()); } else { var category_score_2 = 0; }
      if ($('#cases_new_slider_input_announceschangedstructure').val()) { var category_score_3 = parseInt($('#cases_new_slider_input_announceschangedstructure').val()); } else { var category_score_3 = 0; }
      if ($('#cases_new_slider_input_pushingtoconclusion').val()) { var category_score_4 = parseInt($('#cases_new_slider_input_pushingtoconclusion').val()); } else { var category_score_4 = 0; }

      var category_score = (category_score_1 + category_score_2 + category_score_3 + category_score_4)/4;

      $('#cases_new_block_circle_text_structure').html(category_score);

    }
  }

/////////////////////////////////////////////////////////////////
/////////////////////////// ANALYSIS ////////////////////////////
/////////////////////////////////////////////////////////////////

  // RADAR BUTTONS
  $('#cases_analysis_chart_radar_button_all').click(function() {
    
    $('#cases_analysis_chart_radar').empty();

    cases_analysis_chart_radar_draw("all",cases_analysis_chart_case_count);

    $('#cases_analysis_chart_radar_button_all').addClass('active');
    $('#cases_analysis_chart_radar_button_combined').removeClass('active');

  });

  $('#cases_analysis_chart_radar_button_combined').click(function() {
    
    $('#cases_analysis_chart_radar').empty();

    cases_analysis_chart_radar_draw("combined",cases_analysis_chart_case_count);

    $('#cases_analysis_chart_radar_button_all').removeClass('active');
    $('#cases_analysis_chart_radar_button_combined').addClass('active');

  });

/////////////////////////////////////////////////////////////////
//////////////////////////    CALLS    //////////////////////////
/////////////////////////////////////////////////////////////////

  cases_index_cases_updatelist();

  cases_index_case_link();
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

});


