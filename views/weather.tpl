%import weather as w
<html>
  <head>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load('current', {'packages':['corechart']});
      google.charts.setOnLoadCallback(drawChart);

      function drawChart() {
      	var jsonData = $.ajax({
          url: "weather_json",
          dataType: "json",
          async: false
          }).responseText;

      	var data = new google.visualization.DataTable(jsonData);

      	var columnRange = data.getColumnRange(1);
      	var yMin = columnRange.min - 3;

        var options = {
          hAxis: {textPosition: 'out'},
          vAxis: {textPosition: 'none', baselineColor: '#fff', gridlineColor: '#fff', viewWindow: { min: yMin}},
          legend: {position: 'none'},
          tooltip: {trigger: 'none'},
          annotations: {stemColor: 'none'},
          chartArea: {left: 10, right: 10, top: 10, width: '100%', height: 80}
        };

        var chart = new google.visualization.AreaChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      }
    </script>
    
    <link rel="stylesheet" href="css/material.css?v=1.0">
  	<link rel="stylesheet" href="css/style.css?v=1.0">
  	<script src="js/material.js"></script>

  </head>
  <body>
  	% currentWeather = w.getWeatherInfo()
  	% weatherList, dateList = w.getExtendedWeatherInfo()
  	<div class="weather-container mdl-card mdl-shadow--2dp">
		  <h4 class="location">{{currentWeather['location']}}</h4>
		  <div class="desc">{{currentWeather['desc']}}</div>
 		  <div class="currentWeather-container">
	  		<!--<div class="icon"><img src="/images/ic_weather/{{currentWeather['icon']}}.png"></div>-->
	  		<div class="curr_temp">{{currentWeather['temp']}}C</div>
	  	</div>
		  <div id="chart_div" style="width: 100%; height: 130px;"></div>
	  	<div class="days_container">
  			%for date in dateList:
  				<div class="weather-day">
  					<div class="date" style="text-align: center;">{{date}}</div>
  					<div class="icon"><img src="/images/ic_weather/{{weatherList[date]['icon']}}.png"></div>
  					<div class="max_min">{{weatherList[date]['temp_max']}}°C</div>
  					<div class="max_min" style="text-align: center;">{{weatherList[date]['temp_min']}}°C</div>
  				</div>
  			%end
 		  </div>
  	</div>
  </body>
</html>