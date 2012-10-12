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
    });

  }

}


function cases_show_chart_radar_draw(data) {

  $("#testing123").html(data);

  var chart;

  AmCharts.ready(function () {

    // RADAR CHART
    chart = new AmCharts.AmRadarChart();
    chart.dataProvider = data;
    chart.categoryField = "criteria";
    chart.startDuration = 1;
    chart.startEffect = ">";
    chart.sequencedAnimation = true;
    chart.color = "#FFFFFF";

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
    chart.addValueAxis(valueAxis);

    // GRAPH
    var graph = new AmCharts.AmGraph();
    graph.lineColor = "#98cdff";
    graph.fillAlphas = 0.4;
    graph.bullet = "round";
    graph.valueField = "score";
    graph.balloonText = "[[category]]: [[value]]/10";
    chart.addGraph(graph);

    // Balloon Settings
    var balloon = chart.balloon;
    balloon.adjustBorderColor = true;
    balloon.color = "#000000";
    balloon.cornerRadius = 5;
    balloon.fillColor = "#000000";
    balloon.fillAlpha = 0.7;
    balloon.color = "#FFFFFF";

    // WRITE
    chart.write('cases_show_chart_radar');
  });

}


function cases_analysis_charts_draw(radar_data) {

  ////////////////////////////////////////////
  // Progress chart javascript
  ////////////////////////////////////////////

  var chart_area;

  // loop through model json, construct AM compatabile array + run parseDate
  cases_analysis_chart_progress_data = [];

  $.getJSON("/cases/analysis", function(json) {

    $.each(json, function(i, item) {
      var dataObject = {id:json[i].id, date:parseDate(json[i].date), structure:json[i].structure, analytical:json[i].analytical, commercial:json[i].commercial, conclusion:json[i].conclusion, totalscore:json[i].totalscore};
      // load array for chart
      cases_analysis_chart_progress_data.push(dataObject); 
    });

  }).complete(function() { 
    cases_analysis_chart_progress_draw(cases_analysis_chart_progress_data);
    cases_analysis_chart_radar_draw();
  });


  function cases_analysis_chart_progress_draw(data) {

    // draw AM Progress Chart
    AmCharts.ready(function () {

      // SERIAL CHART
      chart = new AmCharts.AmSerialChart();
      chart.pathToImages = "/assets/amcharts/";
      // below from http://www.amcharts.com/javascript/line-chart-with-date-based-data/
      chart.panEventsEnabled = true;
      chart.zoomOutButton = {
          backgroundColor: "#000000",
          backgroundAlpha: 0.15
      };
      chart.dataProvider = data;
      chart.categoryField = "date";
      
      // neccessary ?
      chart.autoMargins = false;
      chart.marginRight = 15;
      chart.marginLeft = 25;
      chart.marginBottom = 35;
      chart.marginTop = 10;

      // animations
      chart.startDuration = 0.3;
      chart.startEffect = ">";
      chart.sequencedAnimation = true;

      // scroll bar stuff from: http://www.amcharts.com/javascript/line-chart-with-date-based-data/
      // listen for "dataUpdated" event (fired when chart is rendered) and call zoomChart method when it happens
      // chart.addListener("dataUpdated", zoomChart(data));
      
      // AXES
      // Category
      var categoryAxis = chart.categoryAxis;
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
      valueAxis.maximum = 40;
      valueAxis.labelsEnabled = true;
      chart.addValueAxis(valueAxis);

      // DONT FORGET YOU CAN USE 'GUIDES'

      // GRAPHS
      // first graph - STRUCTURE
      var graph = new AmCharts.AmGraph();
      graph.type = "line";
      graph.title = "Structure";
      graph.valueField = "structure";
      graph.lineAlpha = 1;
      graph.fillAlphas = 0.6; // setting fillAlphas to > 0 value makes it area graph
      graph.bullet = "round";

      addclicklistener(graph);
      //addrolloverlistener(graph);

      chart.addGraph(graph);

      // second graph - ANALYTICAL
      graph = new AmCharts.AmGraph();
      graph.type = "line";
      graph.title = "Analytical";
      graph.valueField = "analytical";
      graph.lineAlpha = 1;
      graph.fillAlphas = 0.6;
      graph.bullet = "round";

      addclicklistener(graph);
      //addrolloverlistener(graph);

      chart.addGraph(graph);

      // third graph - COMMERCIAL
      graph = new AmCharts.AmGraph();
      graph.type = "line";
      graph.title = "Commercial";
      graph.valueField = "commercial";
      graph.lineAlpha = 1;
      graph.fillAlphas = 0.6;
      graph.bullet = "round";

      addclicklistener(graph);
      //addrolloverlistener(graph);

      chart.addGraph(graph);
      
      // fourth graph - CONCLUSION
      graph = new AmCharts.AmGraph();
      graph.type = "line";
      graph.title = "Conclusion";
      graph.valueField = "conclusion";
      graph.lineAlpha = 1;
      graph.fillAlphas = 0.6;
      graph.bullet = "round";

      addclicklistener(graph);
      //addrolloverlistener(graph);

      chart.addGraph(graph);

      // Fifth graph - FOR ZOOMER - NOT DRAWN
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
      
      chart.addGraph(graph);

      // LEGEND
      var legend = new AmCharts.AmLegend();
      legend.position = "bottom";
      legend.align = "center"
      legend.rollOverGraphAlpha = "0.15";
      legend.color = '#f6f6f6';
      legend.horizontalGap = 5;
      legend.switchable = true;
      legend.valueWidth = 5;
      chart.addLegend(legend);

      // CURSOR //////////
      // http://www.amcharts.com/javascript/line-chart-with-date-based-data/
      chartCursor = new AmCharts.ChartCursor();
      chartCursor.cursorPosition = "mouse";
      chartCursor.pan = true;
      chartCursor.bulletsEnabled = false;
      chartCursor.zoomable = false;
      chart.addChartCursor(chartCursor);


      // Balloon Settings
      var balloon = chart.balloon;
      balloon.adjustBorderColor = true;
      balloon.color = "#000000";
      balloon.cornerRadius = 5;
      balloon.showBullet = false;
      balloon.fillColor = "#000000";
      balloon.fillAlpha = 0.7
      balloon.color = "#FFFFFF"


      // SCROLLBAR
      // http://www.amcharts.com/javascript/line-chart-with-date-based-data/
      var chartScrollbar = new AmCharts.ChartScrollbar();
      chartScrollbar.graph = graph; // uses 'fifth graph' above - last to use graph variable
      chartScrollbar.autoGridCount = true;
      chartScrollbar.scrollbarHeight = 25;
      chartScrollbar.color = "#000000";
      chart.addChartScrollbar(chartScrollbar);

      // WRITE
      chart.write("cases_analysis_chart_progress");

    });

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

  // lifted from http://www.amcharts.com/javascript/line-chart-with-date-based-data/
  // this method is called when chart is first inited as we listen for "dataUpdated" event
  // function zoomChart(data1) {
  //     // different zoom methods can be used - zoomToIndexes, zoomToDates, zoomToCategoryValues
  //     chart.zoomToIndexes(data1.length - 40, data1.length - 1);
  // }

  function addclicklistener(graph) {
    graph.addListener("clickGraphItem", function (event) {
        window.location = '/cases?id=' + event.item.dataContext.id;
    });
  }

  function addrolloverlistener(graph) {
    graph.addListener("rollOverGraphItem", function (event) {

        //need to load in new chart data with ajax...ugghh
        
        var radargraph = new AmCharts.AmGraph();
        radargraph.title = "Last 5";
        radargraph.lineColor = "#98cdff"
        radargraph.fillAlphas = 0.2;
        radargraph.bullet = "round"
        radargraph.valueField = "last5"
        radargraph.balloonText = "[[category]]: [[value]]/10"
        chart_analysis_radar.addGraph(radargraph);
        chart_analysis_radar.validateData();

        
    });


  }


  ////////////////////////////////////////////
  // Radar
  ////////////////////////////////////////////


  function cases_analysis_chart_radar_draw() {

    var chart_analysis_radar;

    // Draw AM Radar Chart
    AmCharts.ready(function () {
      // RADAR CHART
      chart_analysis_radar = new AmCharts.AmRadarChart();
      chart_analysis_radar.dataProvider = radar_data;
      chart_analysis_radar.categoryField = "criteria";
      chart_analysis_radar.startDuration = 0.3;
      chart_analysis_radar.startEffect = ">";
      chart_analysis_radar.sequencedAnimation = true;
      chart_analysis_radar.color = "#f6f6f6";

      // GRAPH - FIRST 5
      var graph = new AmCharts.AmGraph();
      graph.title = "First 5";
      graph.lineColor = "#bdd523"
      graph.fillAlphas = 0.2;
      graph.bullet = "round"
      graph.valueField = "first5"
      graph.balloonText = "[[category]]: [[value]]/10"
      chart_analysis_radar.addGraph(graph);

      // GRAPH - LAST 5
      var graph = new AmCharts.AmGraph();
      graph.title = "Last 5";
      graph.lineColor = "#98cdff"
      graph.fillAlphas = 0.2;
      graph.bullet = "round"
      graph.valueField = "last5"
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

      // Balloon Settings
      var balloon = chart.balloon;
      balloon.adjustBorderColor = true;
      balloon.color = "#000000";
      balloon.cornerRadius = 5;
      balloon.fillColor = "#000000";
      balloon.fillAlpha = 0.7
      balloon.color = "#FFFFFF"

      // Legend Settings
      var legend = new AmCharts.AmLegend();
      legend.position = "bottom";
      legend.align = "center";
      legend.color = '#f6f6f6';
      legend.markerType = "square";
      legend.rollOverGraphAlpha = 0;
      legend.horizontalGap = 5;
      legend.valueWidth = 5;
      legend.switchable = false;
      chart_analysis_radar.addLegend(legend);

      // WRITE
      chart_analysis_radar.write("cases_analysis_chart_radar");
    });

  }

} // end charts draw function









/////////////////////////////////////////////////////////////////
//////////////////////////    CALLS    //////////////////////////
/////////////////////////////////////////////////////////////////


  cases_index_cases_updatelist();

  cases_index_case_link();


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
      var cases_new_slider_name = $(this).attr("id").split('_')
      $("#case_" + cases_new_slider_name[3]).val(ui.value);
      $("#case_" + cases_new_slider_name[3]).css( 'color', '#6db9ff' )
    }
  });

  $("#cases_new_datepicker").datepicker();
  // Put '{dateFormat: 'dd/mm/yy'}' in brackets to anglify
  
  $('.cases_new_comment').wysihtml5({
    "emphasis": false, //Italics, bold, etc. Default true
    "font-styles": false, //Font styling, e.g. h1, h2, etc. Default true
    "link": false, //Button to insert a link. Default true
    "image": false //Button to insert an image. Default true
  });

/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


});


