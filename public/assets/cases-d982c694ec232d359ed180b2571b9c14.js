!function(){window.cases_new_prime=function(){return $("#application_error_explanation").click(function(){return $(this).fadeOut("fast")}),$("#cases_new_datepicker").datetimepicker({format:"dd MM yyyy - hh:ii",showMeridian:!0,pickerPosition:"bottom-left",minuteStep:15}),$('[name="case[main_comment]"]').wysihtml5({emphasis:!1,"font-styles":!1,link:!1,image:!1,autoLink:!1,composerClassName:"cases_new_maincomment_content"}),$(".cases_new_scoreselector_button").click(function(){var e,a;return a=$(this).data("score"),e=$(this).data("criteria"),$("#cases_new_score_input_"+e).val(a),$("#cases_new_scoreselector_"+e+" .cases_new_scoreselector_button").removeClass("active"),$(this).addClass("active")}),window.application_spinner_prime("#console_index_feedback_frame")},window.cases_analysis_chart_progress_init=function(e){var a,t,r,s;return r=function(t){var r,s,l,i,o,n,c,u;return o=void 0,o=new AmCharts.AmSerialChart,o.pathToImages="/assets/amcharts/",o.panEventsEnabled=!0,o.color="#697076",o.zoomOutButton={backgroundColor:"#000000",backgroundAlpha:.15},o.colors=e>1?["#72aac9","#73bf72","#f1d765"]:["#dee1e3","#dee1e3","#dee1e3"],o.dataProvider=t,o.categoryField="date",o.autoMargins=!1,o.marginRight=0,o.marginLeft=0,o.marginBottom=30,o.marginTop=0,o.startDuration=.3,o.startEffect=">",o.sequencedAnimation=!0,s=o.categoryAxis,s.gridAlpha=.07,s.axisColor="#DADADA",s.startOnAxis=!0,s.equalSpacing=!0,s.parseDates=!0,s.minPeriod="DD",u=new AmCharts.ValueAxis,u.stackType="regular",u.gridAlpha=.07,u.axisAlpha=0,u.maximum=15,u.labelsEnabled=!1,o.addValueAxis(u),n=new AmCharts.AmGraph,n.type="line",n.title="Business Analytics",n.valueField="businessanalytics",n.lineAlpha=1,n.fillAlphas=.5,n.bullet="round",n.bulletSize=5,3>e?n.showBalloon=!1:(n.bulletBorderColor="#72aac9",n.bulletColor="#ffffff",n.bulletBorderThickness=1),a(n),o.addGraph(n),n=new AmCharts.AmGraph,n.type="line",n.title="Structure",n.valueField="structure",n.lineAlpha=1,n.fillAlphas=.5,n.bullet="round",n.bulletSize=5,3>e?n.showBalloon=!1:(n.bulletBorderColor="#73bf72",n.bulletColor="#ffffff",n.bulletBorderThickness=1),a(n),o.addGraph(n),n=new AmCharts.AmGraph,n.type="line",n.title="Interpersonal",n.valueField="interpersonal",n.lineAlpha=1,n.fillAlphas=.5,n.bullet="round",n.bulletSize=5,3>e?n.showBalloon=!1:(n.bulletBorderColor="#f1d765",n.bulletColor="#ffffff",n.bulletBorderThickness=1),a(n),o.addGraph(n),n=new AmCharts.AmGraph,n.type="line",n.title="Total Score",n.valueField="totalscore",n.lineAlpha=1,n.fillAlphas=.6,n.bullet="none",n.showBalloon=!1,n.visibleInLegend=!1,n.fillAlphas=[0],n.lineAlpha=0,n.includeInMinMax=!1,o.addGraph(n),c=new AmCharts.AmLegend,c.align="center",c.rollOverGraphAlpha="0.15",c.fontSize=8,c.horizontalGap=0,c.switchable=!0,c.valueWidth=20,o.addLegend(c,"profile_index_feedback_chart_legend"),l=new AmCharts.ChartCursor,l.cursorPosition="mouse",l.pan=!1,l.cursorColor="#c18176",l.categoryBalloonDateFormat="DD MMM, YYYY",l.zoomable=!1,o.addChartCursor(l),r=o.balloon,r.adjustBorderColor=!0,r.cornerRadius=5,r.showBullet=!1,r.fillColor="#000000",r.fillAlpha=.7,r.color="#FFFFFF",i=new AmCharts.ChartScrollbar,i.graph=n,i.autoGridCount=!0,i.scrollbarHeight=25,i.color="#697076",i.backgroundColor="#f0f1f2",i.selectedBackgroundColor="#dee1e3",o.addChartScrollbar(i),o.write("profile_index_feedback_chart")},s=function(e){var a,t;return t=e.split("-"),a=new Date(Number(t[0]),Number(t[1])-1,Number(t[2]))},a=function(e){return e.addListener("clickGraphItem",function(e){return window.modal_cases_show_show(e.item.dataContext.id)})},$("#cases_analysis_chart_progress").fadeIn("fast"),t=[],$.getJSON("/cases/results",function(e){return $.each(e,function(a){var r;return r={id:e[a].id,date:s(e[a].date),interpersonal:e[a].interpersonal,businessanalytics:e[a].businessanalytics,structure:e[a].structure,totalscore:e[a].totalscore},t.push(r)})}).complete(function(){return r(t)})},window.cases_resultstable_prime=function(e){var a,t,r,s,l,i,o,n,c;for($("#cases_"+e+"_results .btn").off("click"),$("#cases_"+e+"_results .btn").click(function(){var a,t;return a=$(this).data("radio"),t=$(this).data("type"),$("#cases_"+e+"_results input[name=resultstable_"+t+"]:eq("+a+")").prop("checked",!0),$("#cases_"+e+"_results .cases_resultstable_"+t+"_container .btn").removeClass("active"),$(this).addClass("active"),$.get("/cases/results?view="+e,$("#cases_"+e+"_results .cases_resultstable_form").serialize(),null,"script"),!1}),$("#cases_"+e+"_results .application_filtergroup_choicenav li").off("click"),$("#cases_"+e+"_results .application_filtergroup_choicenav li").click(function(){return $.get("/cases/results?view="+e,$("#cases_"+e+"_results .cases_resultstable_form").serialize(),null,"script"),!1}),window.application_choiceNav(),i=0,c=[];12>i;)o=$("#cases_"+e+"_resultstable_chart_bar_"+i).attr("data-score"),t=$("#cases_"+e+"_resultstable_chart_bar_"+i).attr("data-category"),a=[{name:i,score:parseFloat(o),category:t}],s=new AmCharts.AmSerialChart,s.autoMarginOffset=0,s.autoMargins=!1,s.marginRight=0,s.marginTop=0,s.marginBottom=0,s.marginLeft=0,s.width=300,s.dataProvider=a,s.categoryField="name",s.rotate=!0,s.startDuration=1,r=s.categoryAxis,r.gridPosition="start",r.axisColor="#DADADA",r.fillAlpha=0,r.gridAlpha=0,r.labelsEnabled=!1,n=new AmCharts.ValueAxis,n.gridAlpha=0,n.axisAlpha=0,n.minimum=0,n.maximum=5,n.precsion=3,n.labelsEnabled=!1,s.addValueAxis(n),l=new AmCharts.AmGraph,l.valueField="score",l.type="column",l.lineAlpha=0,l.showBalloon=!1,"businessanalytics"===t?l.fillColors="#72aac9":"structure"===t?l.fillColors="#73bf72":"interpersonal"===t&&(l.fillColors="#f1d765"),l.fillAlphas=1,s.addGraph(l),s.write("cases_"+e+"_resultstable_chart_bar_"+i),c.push(i++);return c},$(document).ready(function(){return $("#cases_new_subnav").size()>0?window.cases_new_prime():void 0})}.call(this);