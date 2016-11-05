<html>
  <head>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
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

        var options = {
          vAxis: {minValue: 0},
          vAxis: { textPosition: 'none', baselineColor: '#fff', gridlineColor: '#fff',},
          legend: {position: 'none'},
          tooltip: {trigger: 'none'},
          annotations: {stemColor: 'none'}
        };

        var chart = new google.visualization.AreaChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      }
    </script>
  </head>
  <body>
    <div id="chart_div" style="width: 100%; height: 500px;"></div>
  </body>
</html>