// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


/////////////////////////////////////////////////////////////////
///////////////////////////// SHOW //////////////////////////////
/////////////////////////////////////////////////////////////////


  var chart;

  // var chartData is set in view

  AmCharts.ready(function () {
    // RADAR CHART
    chart = new AmCharts.AmRadarChart();
    chart.dataProvider = chartData_show_radar;
    chart.categoryField = "criteria";
    chart.startDuration = 1;
    chart.startEffect = ">";
    chart.sequencedAnimation = true;

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
    graph.lineColor = "#98cdff"
    graph.fillAlphas = 0.4;
    graph.bullet = "round"
    graph.valueField = "score"
    graph.balloonText = "[[category]]: [[value]]/10"
    chart.addGraph(graph);

    // Balloon Settings
    var balloon = chart.balloon;
    balloon.adjustBorderColor = true;
    balloon.color = "#000000";
    balloon.cornerRadius = 5;
    balloon.fillColor = "#000000";
    balloon.fillAlpha = 0.7
    balloon.color = "#FFFFFF"

    // WRITE
    chart.write("chartdiv");
  });



