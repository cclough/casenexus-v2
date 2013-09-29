
#///////////////////////////////////////////////////////////////
#/////////////////////////// NEW ///////////////////////////////
#///////////////////////////////////////////////////////////////

window.cases_new_prime = () ->

  $("#application_error_explanation").click ->
    $(this).fadeOut "fast"

  $("#cases_new_datepicker").datetimepicker
    format: "dd MM yyyy - hh:ii"
    showMeridian: true
    pickerPosition: 'bottom-left'
    minuteStep: 15
  # $("#cases_new_datepicker").datepicker({ dateFormat: 'dd/mm/yy' });
   # // Put '{dateFormat: 'dd/mm/yy'}' in brackets to anglify

  $("[name=\"case[main_comment]\"]").wysihtml5
    emphasis: false #Italics, bold, etc. Default true
    "font-styles": false #Font styling, e.g. h1, h2, etc. Default true
    link: false #Button to insert a link. Default true
    image: false #Button to insert an image. Default true
    autoLink: false
    composerClassName: "cases_new_maincomment_content"  

      
  # Score selectors!
  $(".cases_new_scoreselector_button").click ->
    score = $(this).data("score")
    criteria = $(this).data("criteria")

    # change value of input
    $("#cases_new_score_input_" + criteria).val(score)


    # make active
    $("#cases_new_scoreselector_" + criteria + " .cases_new_scoreselector_button").removeClass("active")
    $(this).addClass("active")


  # Submit form and show spinner
  $(".application_submit_button_with_spinner").click ->
    $(".application_spinner_container").show()
    $(this).closest("form").submit()

    
  # Char counters
  $('.application_countchar').keyup ->
    window.application_countChar(this)


#////////////////////////////////////////////////////
#////////////////////  SHOW   ///////////////////////
#////////////////////////////////////////////////////



#////////////////////////////////////////////////////
#///////////////////  ANALYSIS  /////////////////////
#////////////////////////////////////////////////////


#//////////////////////////////////////////
# Progress chart //////////////////////////
#//////////////////////////////////////////

window.cases_analysis_chart_progress_init = (case_count, site_average, top_quart, bottom_quart) ->
  
  # loop through model json, construct AM compatabile array + run parseDate
  
  # load array for chart
  
  # DRAW BOTH CHARTS
  cases_analysis_chart_progress_draw = (data) ->
    
    chart_analysis_progress = undefined
    
    # SERIAL CHART
    chart_analysis_progress = new AmCharts.AmSerialChart()
    chart_analysis_progress.pathToImages = "/assets/amcharts/"
    
    # below from http://www.amcharts.com/javascript/line-chart-with-date-based-data/
    chart_analysis_progress.panEventsEnabled = true
    chart_analysis_progress.zoomOutButton =
      backgroundColor: "#000000"
      backgroundAlpha: 0.15

    if case_count > 2
      chart_analysis_progress.colors = ["#0D8ECF", "#B0DE09", "#FCD202"]
    else
      chart_analysis_progress.colors = ["#1f1f1f", "#1f1f1f", "#1f1f1f"]
    chart_analysis_progress.dataProvider = data
    chart_analysis_progress.categoryField = "date"
    
    # neccessary ?
    chart_analysis_progress.autoMargins = false
    chart_analysis_progress.marginRight = 15
    chart_analysis_progress.marginLeft = 25
    chart_analysis_progress.marginBottom = 35
    chart_analysis_progress.marginTop = 10
    
    # animations
    chart_analysis_progress.startDuration = 0.3
    chart_analysis_progress.startEffect = ">"
    chart_analysis_progress.sequencedAnimation = true
    
    # AXES
    # Category
    categoryAxis = chart_analysis_progress.categoryAxis
    categoryAxis.gridAlpha = 0.07
    categoryAxis.axisColor = "#DADADA"
    categoryAxis.startOnAxis = true
    categoryAxis.labelRotation = 45
    categoryAxis.parseDates = true
    
    #http://www.amcharts.com/javascript/line-chart-with-date-based-data/
    categoryAxis.minPeriod = "DD" # our data is daily, so we set minPeriod to DD
    
    # Value
    valueAxis = new AmCharts.ValueAxis()
    valueAxis.stackType = "regular" # this line makes the chart "stacked"
    valueAxis.gridAlpha = 0.07
    valueAxis.axisAlpha = 0
    
    # change to 50?
    valueAxis.maximum = 15
    valueAxis.labelsEnabled = false

    # # HORIZONTAL Guide Quartiles
    # guide = new AmCharts.Guide()
    # guide.value = bottom_quart
    # guide.toValue = top_quart
    # guide.fillColor = "#000"
    # guide.inside = true
    # guide.fillAlpha = 0.3
    # guide.lineAlpha = 0
    # valueAxis.addGuide guide

    # # GUIDE for average
    # guide = new AmCharts.Guide()
    # guide.value = site_average
    # guide.lineColor = "#CC0000"
    # guide.dashLength = 4
    # guide.label = "average for all users"
    # guide.inside = true
    # guide.lineAlpha = 1
    # valueAxis.addGuide guide

    chart_analysis_progress.addValueAxis valueAxis
    
    # GRAPHS
    # first graph - Business Analytics
    graph = new AmCharts.AmGraph()
    graph.type = "line"
    graph.title = "Business Analytics"
    graph.valueField = "businessanalytics"
    graph.lineAlpha = 1
    graph.fillAlphas = 0.7 # setting fillAlphas to > 0 value makes it area graph
    graph.bullet = "round"
    if case_count < 3
      graph.showBalloon = false
    addclicklistener graph
    chart_analysis_progress.addGraph graph

    
    # second graph - Structure
    graph = new AmCharts.AmGraph()
    graph.type = "line"
    graph.title = "Structure"
    graph.valueField = "structure"
    graph.lineAlpha = 1
    graph.fillAlphas = 0.7
    graph.bullet = "round"
    if case_count < 3
      graph.showBalloon = false
    addclicklistener graph
    chart_analysis_progress.addGraph graph

    # third graph - Interpersonal
    graph = new AmCharts.AmGraph()
    graph.type = "line"
    graph.title = "Interpersonal"
    graph.valueField = "interpersonal"
    graph.lineAlpha = 1
    graph.fillAlphas = 0.7
    graph.bullet = "round"
    if case_count < 3
      graph.showBalloon = false
    addclicklistener graph
    chart_analysis_progress.addGraph graph
    
    # Fourth graph - FOR ZOOMER - NOT DRAWN
    graph = new AmCharts.AmGraph()
    graph.type = "line"
    graph.title = "Total Score"
    graph.valueField = "totalscore"
    graph.lineAlpha = 1
    graph.fillAlphas = 0.6
    graph.bullet = "none"
    #graph.hidden = true;
    graph.showBalloon = false
    graph.visibleInLegend = false
    graph.fillAlphas = [0]
    graph.lineAlpha = 0
    graph.includeInMinMax = false
    chart_analysis_progress.addGraph graph
    
    # LEGEND
    # legend = new AmCharts.AmLegend()
    # # legend.position = "bottom"
    # # legend.align = "center"
    # legend.rollOverGraphAlpha = "0.15"
    # # legned.fontSize = 8
    # # legend.color = "#f6f6f6"
    # legend.horizontalGap = 0
    # legend.switchable = true
    # legend.valueWidth = 10
    # chart_analysis_progress.addLegend(legend, "profile_index_feedback_chart_legend")

    # CURSOR //////////
    # http://www.amcharts.com/javascript/line-chart-with-date-based-data/
    chartCursor = new AmCharts.ChartCursor()
    chartCursor.cursorPosition = "mouse"
    chartCursor.pan = false
    chartCursor.bulletsEnabled = false
    chartCursor.categoryBalloonDateFormat = "DD MMM, YYYY"
    chartCursor.zoomable = false

    chart_analysis_progress.addChartCursor chartCursor
    

    # Balloon Settings

    balloon = chart_analysis_progress.balloon
    balloon.adjustBorderColor = true
    balloon.cornerRadius = 5
    balloon.showBullet = false
    balloon.fillColor = "#000000"
    balloon.fillAlpha = 0.7
    balloon.color = "#FFFFFF"


    # SCROLLBAR
    # http://www.amcharts.com/javascript/line-chart-with-date-based-data/
    chartScrollbar = new AmCharts.ChartScrollbar()
    chartScrollbar.graph = graph # uses 'fifth graph' above - last to use graph variable
    chartScrollbar.autoGridCount = true
    chartScrollbar.scrollbarHeight = 25
    chartScrollbar.color = "#000000"
    chart_analysis_progress.addChartScrollbar chartScrollbar
    
    # WRITE
    chart_analysis_progress.write "profile_index_feedback_chart"
  
  # method to parse sql date string into AM compataible Date Object
  parseDate = (dateString) ->
    
    # split the string get each field
    dateArray = dateString.split("-")
    
    # now lets create a new Date instance, using year, month and day as parameters
    # month count starts with 0, so we have to convert the month number
    date = new Date(Number(dateArray[0]), Number(dateArray[1]) - 1, Number(dateArray[2]))
    date
  addclicklistener = (graph) ->
    graph.addListener "clickGraphItem", (event) ->
      window.location = "/cases/" + event.item.dataContext.id


  # DRAW THE CHART
  $("#cases_analysis_chart_progress").fadeIn "fast"

  cases_analysis_chart_progress_data = []
  $.getJSON("/cases/results", (json) ->
    $.each json, (i, item) ->
      dataObject =
        id: json[i].id
        date: parseDate(json[i].date)
        interpersonal: json[i].interpersonal
        businessanalytics: json[i].businessanalytics
        structure: json[i].structure
        totalscore: json[i].totalscore

      cases_analysis_chart_progress_data.push dataObject

  ).complete ->
    cases_analysis_chart_progress_draw cases_analysis_chart_progress_data
    # used to call other chart draw functions here, but now in navigation button click


#////////////////////////////////////////////////////////
# Table - Bars //////////////////////////////////////////
#////////////////////////////////////////////////////////



window.cases_resultstable_prime = (view) ->

  $("#cases_resultstable_form .btn").off 'click'

  $("#cases_resultstable_form .btn").click ->

    radio = $(this).data("radio")
    type = $(this).data("type")

    # Change radio
    $("input[name=resultstable_"+type+"]:eq(" + radio + ")").prop "checked", true
    
    # Remove and add active class to buttons
    $("#cases_resultstable_"+type+"_container .btn").removeClass "active"
    $(this).addClass "active"
    
    # Submit form
    $.get("/cases/results?view=" + view, $("#cases_resultstable_form").serialize(), null, "script")
    false


  i = 0

  while i < 12

    score = $("#cases_resultstable_chart_bar_" + i).data "score"
    category = $("#cases_resultstable_chart_bar_" + i).data "category"

    Data = [{ name: i, score: parseFloat(score), category: category }]

    chart = new AmCharts.AmSerialChart()
    chart.autoMarginOffset = 0
    chart.autoMargins = false
    chart.marginRight = 0  
    chart.marginTop = 0  
    chart.marginBottom = 0  
    chart.marginLeft = 0  
    chart.width = 300
    chart.dataProvider = Data
    chart.categoryField = "name"         
    chart.rotate = true
    chart.depth3D = 3
    chart.angle = 10
    chart.startDuration = 1
    # chart.valueAxesSettings.inside = false

    # AXES
    # Category
    categoryAxis = chart.categoryAxis
    categoryAxis.gridPosition = "start"
    categoryAxis.axisColor = "#DADADA"
    categoryAxis.fillAlpha = 0
    categoryAxis.gridAlpha = 0
    categoryAxis.labelsEnabled = false

    # value
    valueAxis = new AmCharts.ValueAxis()
    valueAxis.gridAlpha = 0
    valueAxis.axisAlpha = 0
    valueAxis.minimum = 0
    valueAxis.maximum = 5
    valueAxis.precsion = 3
    valueAxis.labelsEnabled = false
    chart.addValueAxis valueAxis

    # GRAPH
    graph = new AmCharts.AmGraph()
    graph.valueField = "score"
    graph.type = "column"
    graph.lineAlpha = 0
    graph.showBalloon = false

    if (category == "businessanalytics")
      graph.fillColors = "#0D8ECF"
    else if (category == "structure")
      graph.fillColors = "#B0DE09"
    else if (category == "interpersonal")
      graph.fillColors = "#FCD202"

    graph.fillAlphas = 1
    chart.addGraph graph

    # WRITE
    chart.write("cases_resultstable_chart_bar_" + i)

    i++



#///////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////

$(document).ready ->

#///////////////////////////////////////////////////////////////
#/////////////////////////// NEW ///////////////////////////////
#///////////////////////////////////////////////////////////////




#///////////////////////////////////////////////////////////////
#///////////////////////// ANALYSIS ////////////////////////////
#///////////////////////////////////////////////////////////////


  # # Order and Period buttons
  # $("#cases_analysis_section_table .btn").click ->

  #   radio = $(this).data("radio")
  #   type = $(this).data("type")

  #   # Change radio
  #   $("input[name=resultstable_"+type+"]:eq(" + radio + ")").prop "checked", true
    
  #   # Remove and add active class to buttons
  #   $("#cases_resultstable_"+type+"_container .btn").removeClass "active"
  #   $(this).addClass "active"
    
  #   # Submit form
  #   $.get("/cases/analysis", $("#cases_resultstable_form").serialize(), null, "script")
  #   false




#///////////////////////////////////////////////////////////////
#////////////////////////// SHOW ///////////////////////////////
#///////////////////////////////////////////////////////////////



  # # Order and Period buttons
  # $("#cases_show_charts_view_table .btn").click ->

  #   radio = $(this).data("radio")
  #   type = $(this).data("type")

  #   # Change radio
  #   $("input[name=resultstable_"+type+"]:eq(" + radio + ")").prop "checked", true
    
  #   # Remove and add active class to buttons
  #   $("#cases_resultstable_"+type+"_container .btn").removeClass "active"
  #   $(this).addClass "active"
    
  #   case_id = $("#cases_resultstable_caseid").val()
  #   # Submit form
  #   $.get("/cases/"+case_id, $("#cases_resultstable_form").serialize(), null, "script")
  #   false


  # Select Case Pull Down
  $("#cases_show_subnav_select").change ->
    window.location = "/cases/" + $(this).val()

