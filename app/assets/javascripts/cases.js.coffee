window.chart_analysis_progress = undefined

# method to parse sql date string into AM compataible Date Object
window.parseDate = (dateString) ->

  # split the string get each field
  dateArray = dateString.split("-")

  # now lets create a new Date instance, using year, month and day as parameters
  # month count starts with 0, so we have to convert the month number
  date = new Date(Number(dateArray[0]), Number(dateArray[1]) - 1, Number(dateArray[2]), Number(dateArray[3]), Number(dateArray[4]), Number(dateArray[5]))
  date

#///////////////////////////////////////////////////////////////
#/////////////////////////// NEW ///////////////////////////////
#///////////////////////////////////////////////////////////////

window.cases_new_prime = () ->

  $("#application_error_explanation").click ->
    $(this).fadeOut "fast"

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

  window.application_spinner_prime "#console_index_feedback_frame"



#////////////////////////////////////////////////////
#////////////////////  SHOW   ///////////////////////
#////////////////////////////////////////////////////



#////////////////////////////////////////////////////
#///////////////////  ANALYSIS  /////////////////////
#////////////////////////////////////////////////////


#//////////////////////////////////////////
# Progress chart //////////////////////////
#//////////////////////////////////////////

window.cases_analysis_chart_progress_init = (case_count, progress_type, criteria_id) ->
  
  #### loop through model json, construct AM compatabile array + run parseDate
  
  # load array for chart
  
  # DRAW BOTH CHARTS
  cases_analysis_chart_progress_draw = (data) ->
    
    # SERIAL CHART
    window.chart_analysis_progress = new AmCharts.AmSerialChart()
    window.chart_analysis_progress.pathToImages = "/assets/amcharts/"
    
    # below from http://www.amcharts.com/javascript/line-chart-with-date-based-data/
    # window.chart_analysis_progress.panEventsEnabled = true
    window.chart_analysis_progress.color = "#697076"
    # window.chart_analysis_progress.zoomOutButton =
    #   backgroundColor: "#000000"
    #   backgroundAlpha: 0.15

    if case_count > 1
      window.chart_analysis_progress.colors = ["#72aac9", "#73bf72", "#f1d765"]
    else
      window.chart_analysis_progress.colors = ["#dee1e3", "#dee1e3", "#dee1e3"]
    window.chart_analysis_progress.dataProvider = data
    window.chart_analysis_progress.categoryField = "date"
  
    window.chart_analysis_progress.autoMargins = false
    window.chart_analysis_progress.marginRight = 0
    window.chart_analysis_progress.marginLeft = 0
    window.chart_analysis_progress.marginBottom = 30
    window.chart_analysis_progress.marginTop = 0
    
    # animations
    window.chart_analysis_progress.startDuration = 0.3
    window.chart_analysis_progress.startEffect = ">"
    window.chart_analysis_progress.sequencedAnimation = true
    
    # AXES
    # Category
    categoryAxis = window.chart_analysis_progress.categoryAxis
    categoryAxis.gridAlpha = 0.07
    categoryAxis.axisColor = "#f0f1f2"
    categoryAxis.startOnAxis = true
    categoryAxis.equalSpacing = true
    # categoryAxis.labelRotation = 45
    # categoryAxis.fillColor = "#dee1e3"
    # categoryAxis.fillAlpha = 100
    categoryAxis.parseDates = true
    categoryAxis.dateFormats = [
                                  period: "fff"
                                  format: "JJ:NN:SS"
                                ,
                                  period: "ss"
                                  format: "DD MMM"
                                ,
                                  period: "mm"
                                  format: "JJ:NN"
                                ,
                                  period: "hh"
                                  format: "JJ:NN"
                                ,
                                  period: "DD"
                                  format: "MMM DD"
                                ,
                                  period: "WW"
                                  format: "MMM DD"
                                ,
                                  period: "MM"
                                  format: "MMM"
                                ,
                                  period: "YYYY"
                                  format: "YYYY"
                                ]
    #http://www.amcharts.com/javascript/line-chart-with-date-based-data/
    categoryAxis.minPeriod = "ss" # our data is daily, so we set minPeriod to DD
    
    # Value
    valueAxis = new AmCharts.ValueAxis()
    valueAxis.stackType = "regular" # this line makes the chart "stacked"
    valueAxis.gridAlpha = 0.2
    valueAxis.axisAlpha = 0
    valueAxis.axisColor = "#f0f1f2"
    valueAxis.gridColor = "#f0f1f2"
    if progress_type == "categories"
      valueAxis.maximum = 15
    else if progress_type == "criteria"
      valueAxis.maximum = 5
    valueAxis.gridCount = 15
    valueAxis.autoGridCount = false
    valueAxis.labelsEnabled = false

    window.chart_analysis_progress.addValueAxis valueAxis
    
    # GRAPHS

    if progress_type == "categories"

      # first graph - Business Analytics
      graph = new AmCharts.AmGraph()
      graph.type = "line"
      graph.title = "Business Analytics"
      graph.valueField = "businessanalytics"
      graph.lineAlpha = 1
      graph.fillAlphas = 0.5 # setting fillAlphas to > 0 value makes it area graph
      graph.bullet = "round"
      graph.bulletSize = 5
      if case_count < 3
        graph.showBalloon = false
      else
        graph.bulletBorderAlpha = 1
        graph.bulletBorderColor = "#72aac9"
        graph.bulletColor = "#ffffff"
        graph.bulletBorderThickness = 2
      addclicklistener graph
      window.chart_analysis_progress.addGraph graph

      
      # second graph - Structure
      graph = new AmCharts.AmGraph()
      graph.type = "line"
      graph.title = "Structure"
      graph.valueField = "structure"
      graph.lineAlpha = 1
      graph.fillAlphas = 0.5
      graph.bullet = "round"
      graph.bulletSize = 5
      if case_count < 3
        graph.showBalloon = false
      else
        graph.bulletBorderAlpha = 1
        graph.bulletBorderColor = "#73bf72"
        graph.bulletColor = "#ffffff"
        graph.bulletBorderThickness = 2
      addclicklistener graph
      window.chart_analysis_progress.addGraph graph

      # third graph - Interpersonal
      graph = new AmCharts.AmGraph()
      graph.type = "line"
      graph.title = "Interpersonal"
      graph.valueField = "interpersonal"
      graph.lineAlpha = 1
      graph.fillAlphas = 0.5
      graph.bullet = "round"
      graph.bulletSize = 5
      if case_count < 3
        graph.showBalloon = false
      else
        graph.bulletBorderAlpha = 1
        graph.bulletBorderColor = "#f1d765"
        graph.bulletColor = "#ffffff"
        graph.bulletBorderThickness = 2
      addclicklistener graph
      window.chart_analysis_progress.addGraph graph
    

    else if progress_type == "criteria"

      # first graph - Business Analytics
      graph = new AmCharts.AmGraph()
      graph.type = "line"
      graph.title = "Criteria"
      graph.valueField = "score"
      graph.lineAlpha = 1
      graph.fillAlphas = 0.5 # setting fillAlphas to > 0 value makes it area graph
      graph.bullet = "round"
      graph.bulletSize = 5
      graph.bulletBorderAlpha = 1
      graph.bulletBorderColor = "#72aac9"
      graph.bulletColor = "#ffffff"
      graph.bulletBorderThickness = 2

      addclicklistener graph

      window.chart_analysis_progress.addGraph graph

    # # Fourth graph - FOR ZOOMER - NOT DRAWN
    # graph = new AmCharts.AmGraph()
    # graph.type = "line"
    # graph.title = "Total Score"
    # graph.valueField = "totalscore"
    # graph.lineAlpha = 1
    # graph.fillAlphas = 0.6
    # graph.bullet = "none"
    # #graph.hidden = true;
    # graph.showBalloon = false
    # graph.visibleInLegend = false
    # graph.fillAlphas = [0]
    # graph.lineAlpha = 0
    # graph.includeInMinMax = false
    # window.chart_analysis_progress.addGraph graph
    
    # LEGEND
    legend = new AmCharts.AmLegend()
    # legend.position = "bottom"
    legend.align = "center"
    # legend.rollOverGraphAlpha = "0.15"
    legend.fontSize = 10
    legend.color = "#697076"
    # legend.color = "#f6f6f6"
    legend.horizontalGap = 0
    legend.switchable = true
    legend.valueWidth = 10
    legend.markerLabelGap = 10
    legend.spacing = 10
    legend.switchType = "v"
    legend.horizontalGap = 0 #this is a good one to vary to adjust horizontal position
    legend.markerType = "circle"
    legend.valueText = ""
    window.chart_analysis_progress.addLegend(legend)

    # CURSOR
    # http://www.amcharts.com/javascript/line-chart-with-date-based-data/
    if case_count > 2
      chartCursor = new AmCharts.ChartCursor()
      chartCursor.cursorPosition = "mouse"
      chartCursor.pan = false
      chartCursor.cursorColor = "#313c44"#"#c18176"
      chartCursor.categoryBalloonDateFormat = "DD MMM, YYYY"
      chartCursor.zoomable = false

      window.chart_analysis_progress.addChartCursor chartCursor
    
    # Balloon Settings
    balloon = window.chart_analysis_progress.balloon
    balloon.adjustBorderColor = true
    balloon.cornerRadius = 5
    balloon.showBullet = false
    balloon.fillColor = "#000000"
    balloon.fillAlpha = 0.7
    balloon.color = "#FFFFFF"

    # # SCROLLBAR
    # # http://www.amcharts.com/javascript/line-chart-with-date-based-data/
    # chartScrollbar = new AmCharts.ChartScrollbar()
    # chartScrollbar.graph = graph # uses 'fifth graph' above - last to use graph variable
    # chartScrollbar.autoGridCount = true
    # chartScrollbar.scrollbarHeight = 25
    # chartScrollbar.color = "#697076"
    # chartScrollbar.backgroundColor = "#f0f1f2"
    # chartScrollbar.selectedBackgroundColor = "#dee1e3"
    # window.chart_analysis_progress.addChartScrollbar chartScrollbar
    
    # WRITE
    window.chart_analysis_progress.write "profile_index_feedback_chart"
    
    window.chart_analysis_progress.validateData()

  addclicklistener = (graph) ->
    graph.addListener "clickGraphItem", (event) ->
      window.modal_cases_show_show(event.item.dataContext.id)


  # DRAW THE CHART
  $("#cases_analysis_chart_progress").fadeIn "fast"

  cases_analysis_chart_progress_data = []

  if (progress_type == "categories")
    $.getJSON("/cases/results?progress_type=categories&criteria_id=0", (json) ->
      $.each json, (i, item) ->

        dataObject =
          id: json[i].id
          date: window.parseDate(json[i].date)
          interpersonal: json[i].interpersonal
          businessanalytics: json[i].businessanalytics
          structure: json[i].structure
          totalscore: json[i].totalscore

        cases_analysis_chart_progress_data.push dataObject

    ).complete ->
          cases_analysis_chart_progress_draw cases_analysis_chart_progress_data
          # used to call other chart draw functions here, but now in navigation button click

  else if progress_type == "criteria"
    $.getJSON("/cases/results?progress_type=criteria&criteria_id="+criteria_id, (json) ->
      $.each json, (i, item) ->

        dataObject =
          id: json[i].id
          date: window.parseDate(json[i].date)
          score: json[i].score

        cases_analysis_chart_progress_data.push dataObject    

    ).complete ->
      cases_analysis_chart_progress_draw cases_analysis_chart_progress_data
      # used to call other chart draw functions here, but now in navigation button click






#////////////////////////////////////////////////////////
# Table - Bars //////////////////////////////////////////
#////////////////////////////////////////////////////////



window.cases_resultstable_prime = (view) ->

  # For type radio
  $(".cases_resultstable_form .btn").off 'click'
  $(".cases_resultstable_form .btn").click ->

    radio = $(this).data("radio")
    type = $(this).data("type")

    # Change radio
    $(".cases_resultstable_form input[name=resultstable_"+type+"]:eq(" + radio + ")").prop "checked", true
    
    # Remove and add active class to buttons
    $(".cases_resultstable_"+type+"_container .btn").removeClass "active"
    $(this).addClass "active"
    
    # Submit form
    $.get("/cases/results?view=" + view, $(".cases_resultstable_form").serialize(), null, "script")
    false

  # For period slider
  $(".modal.in .application_filtergroup_choicenav li").off 'click'
  $(".modal.in .application_filtergroup_choicenav li").click ->
    # Submit form
    $.get("/cases/results?view=" + view, $(".cases_resultstable_form").serialize(), null, "script")
    false

  window.application_choiceNav()


  i = 0

  while i < 12

    score = $("#cases_"+view+"_resultstable_chart_bar_" + i).attr "data-score"
    category = $("#cases_"+view+"_resultstable_chart_bar_" + i).attr "data-category"

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
    # chart.depth3D = 3
    # chart.angle = 10
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
      graph.fillColors = "#72aac9"
    else if (category == "structure")
      graph.fillColors = "#73bf72"
    else if (category == "interpersonal")
      graph.fillColors = "#f1d765"

    graph.fillAlphas = 1
    chart.addGraph graph

    # WRITE
    chart.write("cases_"+view+"_resultstable_chart_bar_" + i)

    i++



#///////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////

$(document).ready ->

#///////////////////////////////////////////////////////////////
#/////////////////////////// NEW ///////////////////////////////
#///////////////////////////////////////////////////////////////
  
  # For console, when friend_id set in params
  if $("#cases_new_subnav").size() > 0
    window.cases_new_prime()

#///////////////////////////////////////////////////////////////
#///////////////////////// ANALYSIS ////////////////////////////
#///////////////////////////////////////////////////////////////

#///////////////////////////////////////////////////////////////
#////////////////////////// SHOW ///////////////////////////////
#///////////////////////////////////////////////////////////////



