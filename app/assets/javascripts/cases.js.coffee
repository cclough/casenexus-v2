
# Update the User List - submits form...
window.cases_index_cases_updatelist = ->
  $.get $("#cases_index_cases_form").attr("action"), $("#cases_index_cases_form").serialize(), null, "script"
  false

#////////////////////////////////////////////////////
#////////////////////  SHOW   ///////////////////////
#////////////////////////////////////////////////////

window.cases_show_chart_bar_draw = ->
  chart = undefined
  
  # SERIAL CHART
  chart = new AmCharts.AmSerialChart()
  chart.dataProvider = cases_show_chart_bar_data
  chart.autoMarginOffset = 0
  chart.marginRight = 0
  chart.categoryField = "criteria"
  
  # this single line makes the chart a bar chart,              
  chart.rotate = true
  chart.depth3D = 20
  chart.angle = 30
  
  # AXES
  # Category
  categoryAxis = chart.categoryAxis
  categoryAxis.gridPosition = "start"
  categoryAxis.axisColor = "#DADADA"
  categoryAxis.fillAlpha = 0
  categoryAxis.gridAlpha = 0
  categoryAxis.fillColor = "#FAFAFA"
  categoryAxis.labelsEnabled = false
  
  # value
  valueAxis = new AmCharts.ValueAxis()
  valueAxis.gridAlpha = 0
  valueAxis.dashLength = 1
  
  # valueAxis.minimum = 1;
  valueAxis.integersOnly = true
  valueAxis.labelsEnabled = false
  valueAxis.maximum = 5
  chart.addValueAxis valueAxis
  
  # GRAPH
  graph = new AmCharts.AmGraph()
  graph.title = "Score"
  graph.valueField = "score"
  graph.type = "column"
  graph.labelPosition = "bottom"
  graph.color = "#ffffff"
  graph.fontSize = 10
  graph.labelText = "[[category]]"
  graph.balloonText = "[[category]]: [[value]]"
  graph.lineAlpha = 0
  
  # Balloon Settings
  balloon = chart.balloon
  balloon.adjustBorderColor = true
  balloon.cornerRadius = 5
  balloon.showBullet = false
  balloon.fillColor = "#000000"
  balloon.fillAlpha = 0.7
  balloon.color = "#FFFFFF"
  graph.fillColors = "#98cdff"
  graph.fillAlphas = 0.4
  chart.addGraph graph
  chart.write "cases_show_chart_bar"


window.cases_show_category_chart_bar_draw = (category) ->
  chart = undefined
  
  # SERIAL CHART
  chart = new AmCharts.AmSerialChart()
  if category is "businessanalytics"
    chart.dataProvider = cases_show_businessanalytics_chart_bar_data
  else if category is "interpersonal"
    chart.dataProvider = cases_show_interpersonal_chart_bar_data
  else chart.dataProvider = cases_show_structure_chart_bar_data  if category is "structure"
  chart.autoMarginOffset = 0
  chart.marginRight = 0
  chart.categoryField = "criteria"
  
  # this single line makes the chart a bar chart,              
  chart.rotate = true
  chart.depth3D = 20
  chart.angle = 30
  
  # AXES
  # Category
  categoryAxis = chart.categoryAxis
  categoryAxis.gridPosition = "start"
  categoryAxis.axisColor = "#DADADA"
  categoryAxis.fillAlpha = 0
  categoryAxis.gridAlpha = 0
  categoryAxis.fillColor = "#FAFAFA"
  categoryAxis.labelsEnabled = false
  
  # value
  valueAxis = new AmCharts.ValueAxis()
  valueAxis.gridAlpha = 0
  valueAxis.dashLength = 1
  
  # valueAxis.minimum = 1;
  valueAxis.integersOnly = true
  valueAxis.labelsEnabled = false
  valueAxis.maximum = 5
  chart.addValueAxis valueAxis
  
  # GRAPH
  graph = new AmCharts.AmGraph()
  graph.title = "Score"
  graph.valueField = "score"
  graph.type = "column"
  graph.labelPosition = "bottom"
  graph.color = "#ffffff"
  graph.fontSize = 10
  graph.labelText = "[[category]]"
  graph.balloonText = "[[category]]: [[value]]"
  graph.lineAlpha = 0
  
  # Balloon Settings
  balloon = chart.balloon
  balloon.adjustBorderColor = true
  balloon.cornerRadius = 5
  balloon.showBullet = false
  balloon.fillColor = "#000000"
  balloon.fillAlpha = 0.7
  balloon.color = "#FFFFFF"
  if category is "analytics"
    graph.fillColors = "#0D8ECF"
  else if category is "interpersonal"
    graph.fillColors = "#B0DE09"
  else graph.fillColors = "#FCD202"  if category is "structure"
  graph.fillAlphas = 0.4
  chart.addGraph graph
  
  # WRITE
  if category is "businessanalytics"
    chart.write "cases_show_businessanalytics_chart_bar"
  else if category is "interpersonal"
    chart.write "cases_show_interpersonal_chart_bar"
  else chart.write "cases_show_structure_chart_bar" if category is "structure"

window.cases_show_chart_radar_draw = (radar_type) ->
  chart_show_radar = undefined
  
  # RADAR CHART
  chart_show_radar = new AmCharts.AmRadarChart()
  if radar_type is "all"
    chart_show_radar.dataProvider = cases_show_chart_radar_data_all
  else chart_show_radar.dataProvider = cases_show_chart_radar_data_combined  if radar_type is "combined"
  chart_show_radar.categoryField = "criteria"
  
  # chart_show_radar.startDuration = 1;
  # chart_show_radar.startEffect = ">";
  # chart_show_radar.sequencedAnimation = true;
  chart_show_radar.color = "#FFFFFF"
  chart_show_radar.fontSize = 9
  
  # VALUE AXIS
  valueAxis = new AmCharts.ValueAxis()
  valueAxis.gridType = "circles"
  valueAxis.fillAlpha = 0.02
  valueAxis.fillColor = "#000000"
  valueAxis.axisAlpha = 0.1
  valueAxis.gridAlpha = 0.1
  valueAxis.fontWeight = "bold"
  valueAxis.minimum = 0
  valueAxis.maximum = 5
  chart_show_radar.addValueAxis valueAxis
  
  # GUIDES
  # Blue - Business Analytics
  guide = new AmCharts.Guide()
  guide.angle = 270
  guide.toAngle = 390
  guide.value = 3
  guide.toValue = 2
  guide.fillColor = "#0D8ECF"
  guide.fillAlpha = 0.3
  valueAxis.addGuide guide
  
  # Green - Interpersonal
  guide = new AmCharts.Guide()
  guide.angle = 30
  guide.toAngle = 150
  guide.value = 3
  guide.toValue = 2
  guide.fillColor = "#B0DE09"
  guide.fillAlpha = 0.3
  valueAxis.addGuide guide
  
  # Yellow - Structure
  guide = new AmCharts.Guide()
  guide.angle = 150
  guide.toAngle = 270
  guide.value = 3
  guide.toValue = 2
  guide.fillColor = "#FCD202"
  guide.fillAlpha = 0.3
  valueAxis.addGuide guide
  
  # GRAPH
  graph = new AmCharts.AmGraph()
  graph.lineColor = "#98cdff"
  graph.fillAlphas = 0.4
  graph.bullet = "round"
  graph.valueField = "score"
  graph.balloonText = "[[category]]: [[value]]/5"
  graph.labelPosition = "right"
  chart_show_radar.addGraph graph
  
  # Balloon Settings
  balloon = chart_show_radar.balloon
  balloon.adjustBorderColor = true
  balloon.color = "#000000"
  balloon.cornerRadius = 5
  balloon.fillColor = "#000000"
  balloon.fillAlpha = 0.7
  balloon.color = "#FFFFFF"
  
  # WRITE
  chart_show_radar.write "cases_show_chart_radar"


#////////////////////////////////////////////////////
#///////////////////  ANALYSIS  /////////////////////
#////////////////////////////////////////////////////


window.cases_analysis_charts_draw = (case_count) ->
  
  #//////////////////////////////////////////
  # Progress chart javascript
  #//////////////////////////////////////////
  if case_count is 0
    $("#cases_analysis_chart_radar_empty").fadeIn "fast"
    $("#cases_analysis_chart_progress_empty").fadeIn "fast"
  else
    
    # loop through model json, construct AM compatabile array + run parseDate
    
    # load array for chart
    
    # DRAW BOTH CHARTS
    cases_analysis_chart_progress_draw = (data) ->
      
      # Fade out loading bars
      $(".cases_analysis_loading").fadeOut "slow", ->
        $(".cases_analysis_loading").remove()

      chart_analysis_progress = undefined
      
      # SERIAL CHART
      chart_analysis_progress = new AmCharts.AmSerialChart()
      chart_analysis_progress.pathToImages = "/assets/amcharts/"
      
      # below from http://www.amcharts.com/javascript/line-chart-with-date-based-data/
      chart_analysis_progress.panEventsEnabled = true
      chart_analysis_progress.zoomOutButton =
        backgroundColor: "#000000"
        backgroundAlpha: 0.15

      chart_analysis_progress.colors = ["#0D8ECF", "#B0DE09", "#FCD202"]
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
      valueAxis.maximum = 30
      valueAxis.labelsEnabled = true
      chart_analysis_progress.addValueAxis valueAxis
      
      # DONT FORGET YOU CAN USE 'GUIDES'
      
      # GRAPHS
      # first graph - Business Analytics
      graph = new AmCharts.AmGraph()
      graph.type = "line"
      graph.title = "Business Analytics"
      graph.valueField = "businessanalytics"
      graph.lineAlpha = 1
      graph.fillAlphas = 0.7 # setting fillAlphas to > 0 value makes it area graph
      graph.bullet = "round"
      addclicklistener graph
      chart_analysis_progress.addGraph graph
      
      # second graph - Interpersonal
      graph = new AmCharts.AmGraph()
      graph.type = "line"
      graph.title = "Interpersonal"
      graph.valueField = "interpersonal"
      graph.lineAlpha = 1
      graph.fillAlphas = 0.7
      graph.bullet = "round"
      addclicklistener graph
      chart_analysis_progress.addGraph graph
      
      # third graph - Structure
      graph = new AmCharts.AmGraph()
      graph.type = "line"
      graph.title = "Structure"
      graph.valueField = "structure"
      graph.lineAlpha = 1
      graph.fillAlphas = 0.7
      graph.bullet = "round"
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
      legend = new AmCharts.AmLegend()
      legend.position = "bottom"
      legend.align = "center"
      legend.rollOverGraphAlpha = "0.15"
      legend.color = "#f6f6f6"
      legend.horizontalGap = 5
      legend.switchable = true
      legend.valueWidth = 25
      chart_analysis_progress.addLegend legend
      
      # CURSOR //////////
      # http://www.amcharts.com/javascript/line-chart-with-date-based-data/
      chartCursor = new AmCharts.ChartCursor()
      chartCursor.cursorPosition = "mouse"
      chartCursor.pan = true
      chartCursor.bulletsEnabled = false
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
      chart_analysis_progress.write "cases_analysis_chart_progress"
    
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
        window.location = "/cases?id=" + event.item.dataContext.id

    $("#cases_analysis_chart_radar").fadeIn "fast"
    $("#cases_analysis_chart_progress").fadeIn "fast"
    $("#cases_analysis_chart_radar_buttongroup").fadeIn "fast"
    cases_analysis_chart_progress_data = []
    $.getJSON("/cases/analysis", (json) ->
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



#////////////////////////////////////////////////////////
# Radar // Has to be global function for buttons to work
#////////////////////////////////////////////////////////

cases_analysis_chart_radar_draw = (radar_type, case_count) ->
  chart_analysis_radar = undefined
  
  # RADAR CHART
  chart_analysis_radar = new AmCharts.AmRadarChart()
  if radar_type is "all"
    chart_analysis_radar.dataProvider = cases_analysis_chart_radar_data_all
  else chart_analysis_radar.dataProvider = cases_analysis_chart_radar_data_combined  if radar_type is "combined"
  chart_analysis_radar.categoryField = "criteria"
  chart_analysis_radar.startDuration = 0.3
  chart_analysis_radar.startEffect = ">"
  chart_analysis_radar.sequencedAnimation = true
  chart_analysis_radar.color = "#f6f6f6"
  chart_analysis_radar.colors = ["#ff00ff", "#ff7300", "#ff0000"]
  chart_analysis_radar.fontSize = 9
  
  # GRAPH - ALL
  graph = new AmCharts.AmGraph()
  graph.title = "All"
  graph.fillAlphas = 0.2
  graph.bullet = "round"
  graph.valueField = "all"
  graph.balloonText = "[[category]]: [[value]]/5"
  chart_analysis_radar.addGraph graph
  
  # GRAPH - FIRST 5
  graph = new AmCharts.AmGraph()
  graph.title = "First " + case_count
  graph.fillAlphas = 0.2
  graph.bullet = "round"
  graph.valueField = "first"
  graph.balloonText = "[[category]]: [[value]]/5"
  chart_analysis_radar.addGraph graph
  
  # GRAPH - LAST 5
  graph = new AmCharts.AmGraph()
  graph.title = "Last " + case_count
  graph.fillAlphas = 0.2
  graph.bullet = "round"
  graph.valueField = "last"
  graph.balloonText = "[[category]]: [[value]]/5"
  chart_analysis_radar.addGraph graph
  
  # VALUE AXIS
  valueAxis = new AmCharts.ValueAxis()
  valueAxis.gridType = "circles"
  valueAxis.fillAlpha = 0.02
  valueAxis.fillColor = "#000000"
  valueAxis.axisAlpha = 0.1
  valueAxis.gridAlpha = 0.1
  valueAxis.fontWeight = "bold"
  valueAxis.minimum = 0
  valueAxis.maximum = 5
  chart_analysis_radar.addValueAxis valueAxis
  
  # GUIDES
  # Blue - Business Analytics
  guide = new AmCharts.Guide()
  guide.angle = 270
  guide.toAngle = 390
  guide.value = 3
  guide.toValue = 2
  guide.fillColor = "#0D8ECF"
  guide.fillAlpha = 0.3
  valueAxis.addGuide guide
  
  # Green - Interpersonal
  guide = new AmCharts.Guide()
  guide.angle = 30
  guide.toAngle = 150
  guide.value = 3
  guide.toValue = 2
  guide.fillColor = "#B0DE09"
  guide.fillAlpha = 0.3
  valueAxis.addGuide guide
  
  # Yellow - Structure
  guide = new AmCharts.Guide()
  guide.angle = 150
  guide.toAngle = 270
  guide.value = 3
  guide.toValue = 2
  guide.fillColor = "#FCD202"
  guide.fillAlpha = 0.3
  valueAxis.addGuide guide
  
  # Balloon Settings
  balloon = chart_analysis_radar.balloon
  balloon.adjustBorderColor = true
  balloon.cornerRadius = 5
  balloon.showBullet = false
  balloon.fillColor = "#000000"
  balloon.fillAlpha = 0.7
  balloon.color = "#FFFFFF"
  
  # Legend Settings
  legend = new AmCharts.AmLegend()
  legend.position = "bottom"
  legend.align = "center"
  legend.color = "#f6f6f6"
  legend.markerType = "square"
  legend.rollOverGraphAlpha = 0
  legend.horizontalGap = 5
  legend.valueWidth = 5
  legend.switchable = true
  chart_analysis_radar.addLegend legend
  
  # WRITE
  chart_analysis_radar.write "cases_analysis_chart_radar"

#///////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////

$(document).ready ->
  
#///////////////////////////////////////////////////////////////
#////////////////////////// INDEX //////////////////////////////
#///////////////////////////////////////////////////////////////
  
  $("#cases_index_cases_form input").keypress (e) ->
    window.cases_index_cases_updatelist()  if e.which is 13


  # Ajax pagination
  $("#cases_index_cases .application_pagination a, #cases_index_cases_form_sort a").on "click", ->
    $.getScript @href
    false

#///////////////////////////////////////////////////////////////
#/////////////////////////// NEW ///////////////////////////////
#///////////////////////////////////////////////////////////////


  # $("#cases_new_datepicker").datetimepicker({ "pickSeconds": false });
  # // Put '{dateFormat: 'dd/mm/yy'}' in brackets to anglify
  $("[name=\"case[businessanalytics_comment]\"]").wysihtml5
    emphasis: false #Italics, bold, etc. Default true
    "font-styles": false #Font styling, e.g. h1, h2, etc. Default true
    link: false #Button to insert a link. Default true
    image: false #Button to insert an image. Default true

  $("[name=\"case[interpersonal_comment]\"]").wysihtml5
    emphasis: false #Italics, bold, etc. Default true
    "font-styles": false #Font styling, e.g. h1, h2, etc. Default true
    link: false #Button to insert a link. Default true
    image: false #Button to insert an image. Default true

  $("[name=\"case[structure_comment]\"]").wysihtml5
    emphasis: false #Italics, bold, etc. Default true
    "font-styles": false #Font styling, e.g. h1, h2, etc. Default true
    link: false #Button to insert a link. Default true
    image: false #Button to insert an image. Default true

  # Score selectors!
  $(".cases_new_scoreselector_button").click ->
    score = $(this).data("score")
    criteria = $(this).data("criteria")

    # change value of input
    $("#cases_new_score_input_" + criteria).val(score)

    # update category score
    cases_new_calculatecategoryscore($(this).attr("data-category"));

    # make active
    $("#cases_new_scoreselector_" + criteria + " .cases_new_scoreselector_button").removeClass("active")
    $(this).addClass("active")


  # Popovers
  $(".cases_new_criteria_popover").hover (->
    $(this).popover "show"
  ), ->
    $(this).popover "hide"


  cases_new_calculatecategoryscore = (category) ->
    if category is "businessanalytics"
      if $("#cases_new_score_input_quantitativebasics").val()
        category_score_1 = parseInt($("#cases_new_score_input_quantitativebasics").val())
      else
        category_score_1 = 0
      if $("#cases_new_score_input_problemsolving").val()
        category_score_2 = parseInt($("#cases_new_score_input_problemsolving").val())
      else
        category_score_2 = 0
      if $("#cases_new_score_input_prioritisation").val()
        category_score_3 = parseInt($("#cases_new_score_input_prioritisation").val())
      else
        category_score_3 = 0
      if $("#cases_new_score_input_sanitychecking").val()
        category_score_4 = parseInt($("#cases_new_score_input_sanitychecking").val())
      else
        category_score_4 = 0
      category_score = (category_score_1 + category_score_2 + category_score_3 + category_score_4) / 4
      $("#cases_new_block_circle_text_businessanalytics").html category_score
    else if category is "interpersonal"
      if $("#cases_new_score_input_rapport").val()
        category_score_1 = parseInt($("#cases_new_score_input_rapport").val())
      else
        category_score_1 = 0
      if $("#cases_new_score_input_articulation").val()
        category_score_2 = parseInt($("#cases_new_score_input_articulation").val())
      else
        category_score_2 = 0
      if $("#cases_new_score_input_concision").val()
        category_score_3 = parseInt($("#cases_new_score_input_concision").val())
      else
        category_score_3 = 0
      if $("#cases_new_score_input_askingforinformation").val()
        category_score_4 = parseInt($("#cases_new_score_input_askingforinformation").val())
      else
        category_score_4 = 0
      category_score = (category_score_1 + category_score_2 + category_score_3 + category_score_4) / 4
      $("#cases_new_block_circle_text_interpersonal").html category_score
    else if category is "structure"
      if $("#cases_new_score_input_approachupfront").val()
        category_score_1 = parseInt($("#cases_new_score_input_approachupfront").val())
      else
        category_score_1 = 0
      if $("#cases_new_score_input_stickingtostructure").val()
        category_score_2 = parseInt($("#cases_new_score_input_stickingtostructure").val())
      else
        category_score_2 = 0
      if $("#cases_new_score_input_announceschangedstructure").val()
        category_score_3 = parseInt($("#cases_new_score_input_announceschangedstructure").val())
      else
        category_score_3 = 0
      if $("#cases_new_score_input_pushingtoconclusion").val()
        category_score_4 = parseInt($("#cases_new_score_input_pushingtoconclusion").val())
      else
        category_score_4 = 0
      category_score = (category_score_1 + category_score_2 + category_score_3 + category_score_4) / 4
      $("#cases_new_block_circle_text_structure").html category_score


#///////////////////////////////////////////////////////////////
#///////////////////////// ANALYSIS ////////////////////////////
#///////////////////////////////////////////////////////////////

  # Subnav Buttons

  $(".cases_analysis_subnav_button").click ->
    section = $(this).data("section")

    $(".cases_analysis_section").addClass "hidden"
    $("#cases_analysis_section_" + section).removeClass "hidden"

    if section is "radar"
      cases_analysis_chart_radar_draw "all", cases_analysis_chart_case_count

    $(".cases_analysis_subnav_button").removeClass "active"
    $(this).addClass "active"

  # RADAR BUTTONS
  $("#cases_analysis_chart_radar_button_all").click ->
    $("#cases_analysis_chart_radar").empty()
    cases_analysis_chart_radar_draw "all", cases_analysis_chart_case_count
    $("#cases_analysis_chart_radar_button_all").addClass "active"
    $("#cases_analysis_chart_radar_button_combined").removeClass "active"

  $("#cases_analysis_chart_radar_button_combined").click ->
    $("#cases_analysis_chart_radar").empty()
    cases_analysis_chart_radar_draw "combined", cases_analysis_chart_case_count
    $("#cases_analysis_chart_radar_button_all").removeClass "active"
    $("#cases_analysis_chart_radar_button_combined").addClass "active"


#///////////////////////////////////////////////////////////////
#////////////////////////// SHOW ///////////////////////////////
#///////////////////////////////////////////////////////////////

  # Select Case Pull Down
  $("#cases_index_subnav_cases").change ->
    window.location = "/cases/" + $(this).val()

  # RADAR BUTTONS
  $("#cases_show_chart_radar_button_all").click ->
    $("#cases_show_chart_radar").empty()
    cases_show_chart_radar_draw "all"
    $("#cases_show_chart_radar_button_all").addClass "active"
    $("#cases_show_chart_radar_button_combined").removeClass "active"

  $("#cases_show_chart_radar_button_combined").click ->
    $("#cases_show_chart_radar").empty()
    cases_show_chart_radar_draw "combined"
    $("#cases_show_chart_radar_button_all").removeClass "active"
    $("#cases_show_chart_radar_button_combined").addClass "active"


#///////////////////////////////////////////////////////////////
#////////////////////////    CALLS    //////////////////////////
#///////////////////////////////////////////////////////////////



#///////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////
#///////////////////////////////////////////////////////////////
