<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
</head>
<style>
	.column .columns {
		margin:0 !important;
	}
	.statisticsArea {
		width: 100%;
		height: 100%;
	}
	#myChart {
		width: 100%;
		height: 100%;
	}
</style>
<body>
	<jsp:include page="../../common/adminMainNav.jsp"/>
	
	<div class="columns is-mobile">
		<div class="column">
			<section class="section" id="headerSection">
				<jsp:include page="adminStatisticsNav.jsp" />
			</section>
			<section class="section" id="bredcrumbSection" style="padding-top:0; padding-bottom:0">
				<div class="column">
					<div class="tabs is-boxed">
						<ul class="travelStaNav">
							<li>
								<a href="travelCountryStatisticsView.sta">
									<span style="color:#ccccff;"><i class="fas fa-venus-mars"></i>&nbsp;나라별</span>
								</a>
							</li>
							<li>
								<a href="travelTagStatisticsView.sta">
									<span style="color:#ccccff;"><i class="fas fa-user-clock"></i>&nbsp;여행스타일별</span>
								</a>
							</li>
						</ul>
					</div>
				</div>
			</section>
			<section class="section" id="cardSection">
				<div class="columns">
					
					<div class="statisticsArea" align="center">
						<div class="field has-addons" style="justify-content: flex-end; margin-top: 1em;" align="right">
							<p class="control">
								<span class="select">
									<select id="monthSelect">
										<option value="1">1월</option>
										<option value="2">2월</option>
										<option value="3">3월</option>
										<option value="4">4월</option>
										<option value="5">5월</option>
										<option value="6">6월</option>
										<option value="7">7월</option>
										<option value="8">8월</option>
										<option value="9">9월</option>
										<option value="10">10월</option>
										<option value="11">11월</option>
										<option value="12">12월</option>
									</select>
								</span>
							</p>
						</div>
						<p class="title is-4" style="color: #424242;">월별 인기 여행나라 10</p>
						<div id="regions_div" style="width: 900px; height: 500px;"></div>
					</div>
					
				</div>
			</section>
		</div>
	</div>
	
<script>
var today;
var year;
var month;
var day = "";

$(function(){
	
	var menu = $(".statisticsNav li").eq(1);
    menu.addClass('is-active');
    menu.siblings().removeClass('is-active');
    
    var sub = $(".travelStaNav li").eq(0);
    sub.addClass('is-active');
    sub.find('span').css("color", "#209cee");
    sub.siblings().removeClass('is-active');
    
  	//현재 월 기준 인기 태그 10위 조회
    today = new Date();
    year = today.getFullYear();
    month = today.getMonth() + 1;
    
    $("#monthSelect option").each(function() {
    	if($(this).val() == month) {
    		$(this).attr("selected", "selected");
    	}
    });
    
    var day = "";
    if(month < 10) {
    	month = '0' + month;
    }
    
    day = year + '-' + month;
    
    
    google.charts.load('current', {
   	  'packages':['geochart'],
   	  // Note: you will need to get a mapsApiKey for your project.
   	  // See: https://developers.google.com/chart/interactive/docs/basic_load_libs#load-settings
   	  'mapsApiKey': 'AIzaSyD-9tSrke72PouQMnMX-a7eZSW0jkFMBWY'
   	});
    
	//현재 월 기준 인기 나라 10위 조회
    today = new Date();
    year = today.getFullYear();
    month = today.getMonth() + 1;
    
    day = "";
    if(month < 10) {
    	day = year + '-0' + month;
    }else {
    	day = year + '-' + month;
    }
    
    $.ajax({
    	url : "travelCountryMonthStatistics.sta",
    	data : {month : day},
    	type : "post",
    	success : function(list) {
    		
    		console.log(list);
    		
    		google.charts.setOnLoadCallback(drawRegionsMap);
    		
    		function drawRegionsMap() {
	    		
   			  var data = google.visualization.arrayToDataTable([
   			    ['Country', '인기도'],
   			    [list[0].countryNameEn, list[0].countryCount],
	   			[list[1].countryNameEn, list[1].countryCount],
	   			[list[2].countryNameEn, list[2].countryCount],
	   			[list[3].countryNameEn, list[3].countryCount],
	   			[list[4].countryNameEn, list[4].countryCount],
	   			[list[5].countryNameEn, list[5].countryCount],
	   			[list[6].countryNameEn, list[6].countryCount],
	   			[list[7].countryNameEn, list[7].countryCount],
	   			[list[8].countryNameEn, list[8].countryCount],
	   			[list[9].countryNameEn, list[9].countryCount]
   			  ]);

   			  var options = {};

   			  var chart = new google.visualization.GeoChart(document.getElementById('regions_div'));

   			  chart.draw(data, options);
   			}
    		
    		
    	},
    	error : function(data) {
    		alert("접속에러");
    	}
    });
    
});

var selection_array = [];
selection_array.push(['Country', '인기도']);

$("#monthSelect").change(function() {
	month = $(this).val();
	if(month < 10) {
    	month = '0' + month;
    }
	day = year + '-' + month;
	
	console.log(day);
	
	$.ajax({
    	url : "travelCountryMonthStatistics.sta",
    	data : {month : day},
    	type : "post",
    	success : function(list) {
    		
			if(list.length > 0) {
				google.charts.setOnLoadCallback(drawRegionsMap);
	    		
	    		function drawRegionsMap() {
		    		
	   			  var data = google.visualization.arrayToDataTable([
	   			    ['Country', '인기도'],
	   			    [list[0].countryNameEn, list[0].countryCount],
		   			[list[1].countryNameEn, list[1].countryCount],
		   			[list[2].countryNameEn, list[2].countryCount],
		   			[list[3].countryNameEn, list[3].countryCount],
		   			[list[4].countryNameEn, list[4].countryCount],
		   			[list[5].countryNameEn, list[5].countryCount],
		   			[list[6].countryNameEn, list[6].countryCount],
		   			[list[7].countryNameEn, list[7].countryCount],
		   			[list[8].countryNameEn, list[8].countryCount],
		   			[list[9].countryNameEn, list[9].countryCount]
	   			  ]);

	   			  var options = {};

	   			  var chart = new google.visualization.GeoChart(document.getElementById('regions_div'));

	   			  chart.draw(data, options);
	   			}
			}else {
				google.charts.setOnLoadCallback(drawRegionsMap);
	    		
	    		function drawRegionsMap() {
		    		
	   			  var data = google.visualization.arrayToDataTable([
	   			    ['Country', '인기도']
	   			  ]);

	   			  var options = {};

	   			  var chart = new google.visualization.GeoChart(document.getElementById('regions_div'));

	   			  chart.draw(data, options);
	   			}
				
			}
    		
    		
    	},
    	error : function(data) {
    		alert("접속에러");
    	}
    });
});


</script>
	
</body>
</html>