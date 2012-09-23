// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


/////////////////////////////////////////////////////////////////
///////////////////////////// NEW ///////////////////////////////
/////////////////////////////////////////////////////////////////


$(document).ready(function(){

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
  
});






/////////////////////////////////////////////////////////////////
///////////////////////// ANALYSIS //////////////////////////////
/////////////////////////////////////////////////////////////////




////////////////////////////////////////////
// Radar
////////////////////////////////////////////




cases_get_radar_analysis(function(data) {
  drawchart_radar_analysis(data);
});




function cases_get_radar_analysis (callback) {

    $.get("/get_radar_analysis", function(data) {

      callback(data);

    });
    
}


function drawchart_radar_analysis(data) {

  var chart;

  // Draw AM Radar Chart
  AmCharts.ready(function () {
    // RADAR CHART
    chart = new AmCharts.AmRadarChart();
    chart.dataProvider = data;
    chart.categoryField = "criteria";
    chart.startDuration = 0.3;
    chart.startEffect = ">";
    chart.sequencedAnimation = true;
    chart.color = "#FFFFFF";

    // GRAPH - FIRST 5
    var graph = new AmCharts.AmGraph();
    graph.title = "First 5";
    graph.lineColor = "#bdd523"
    graph.fillAlphas = 0.2;
    graph.bullet = "round"
    graph.valueField = "first5"
    graph.balloonText = "[[category]]: [[value]]/10"
    chart.addGraph(graph);

    // GRAPH - LAST 5
    var graph = new AmCharts.AmGraph();
    graph.title = "Last 5";
    graph.lineColor = "#98cdff"
    graph.fillAlphas = 0.2;
    graph.bullet = "round"
    graph.valueField = "last5"
    graph.balloonText = "[[category]]: [[value]]/10"
    chart.addGraph(graph);

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
    legend.markerType = "square";
    legend.rollOverGraphAlpha = 0;
    legend.horizontalGap = 5;
    legend.valueWidth = 5;
    legend.switchable = false;
    chart.addLegend(legend);

    // WRITE
    chart.write("cases_analysis_chart_radar");
  });

}


////////////////////////////////////////////
// Progress chart javascript
////////////////////////////////////////////


var chart_area;

// loop through model json, construct AM compatabile array + run parseDate
chartData_progress = [];

$.getJSON("/cases/analysis", function(json) {

  for (var i = 0; i < json.length; i++) {

    var dataObject = {id:json[i].id, date:parseDate(json[i].date), structure:json[i].structure, analytical:json[i].analytical, commercial:json[i].commercial, conclusion:json[i].conclusion};
    // load array for chart
    chartData_progress.push(dataObject); 
  }

});

// draw AM Progress Chart
AmCharts.ready(function () {
  // SERIAL CHART
  chart = new AmCharts.AmSerialChart();
  // still not yet sure if below line is working?
  // add curly brackets below
  // chart.pathToImages = ' asset_path 'amcharts/'';
  // below from http://www.amcharts.com/javascript/line-chart-with-date-based-data/
  chart.panEventsEnabled = true;
  chart.zoomOutButton = {
      backgroundColor: "#000000",
      backgroundAlpha: 0.15
  };
  chart.dataProvider = chartData_progress;
  chart.categoryField = "date";
  
  // neccessary ?
  chart.autoMargins = false;
  chart.marginRight = 15;
  chart.marginLeft = 15;
  chart.marginBottom = 35;
  chart.marginTop = 10;

  // animations
  chart.startDuration = 0.3;
  chart.startEffect = ">";
  chart.sequencedAnimation = true;

  // scroll bar stuff from: http://www.amcharts.com/javascript/line-chart-with-date-based-data/
  // listen for "dataUpdated" event (fired when chart is rendered) and call zoomChart method when it happens
  chart.addListener("dataUpdated", zoomChart);
  
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
  valueAxis.labelsEnabled = false
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

  // LEGEND
  var legend = new AmCharts.AmLegend();
  legend.position = "bottom";
  legend.align = "center"
  legend.rollOverGraphAlpha = "0.15";
  legend.horizontalGap = 5;
  legend.switchable = false;
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
  chartScrollbar.graph = graph;
  chartScrollbar.autoGridCount = true;
  chartScrollbar.scrollbarHeight = 25;
  chartScrollbar.color = "#000000";
  chart.addChartScrollbar(chartScrollbar);

  // WRITE
  chart.write("cases_analysis_chart_progress");
  
});

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
function zoomChart() {
    // different zoom methods can be used - zoomToIndexes, zoomToDates, zoomToCategoryValues
    chart.zoomToIndexes(chartData_progress.length - 40, chartData_progress.length - 1);
}


function addclicklistener(graph) {
  graph.addListener("clickGraphItem", function (event) {
      window.location = '/cases/' + event.item.dataContext.id;
  });
}

function addrolloverlistener(graph) {
  graph.addListener("rollOverGraphItem", function (event) {
      window.location = '/cases/' + event.item.dataContext.id;
      //addGraph(graph)

      var radargraph = new AmCharts.AmGraph();
      radargraph.title = "Last 5";
      radargraph.lineColor = "#98cdff"
      radargraph.fillAlphas = 0.2;
      radargraph.bullet = "round"
      radargraph.valueField = "last5"
      radargraph.balloonText = "[[category]]: [[value]]/10"
      chart.addGraph(graph);

  });


}





/////////////////////////////////////////////////////////////////
///////////////////////////// SHOW //////////////////////////////
/////////////////////////////////////////////////////////////////

var chart;

// var chartData_show_radar is set in view

AmCharts.ready(function () {

  // RADAR CHART
  chart = new AmCharts.AmRadarChart();
  chart.dataProvider = chartData_show_radar;
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
  chart.write("cases_show_chart_radar");
});













