<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>restTestPage</title>
<script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
<script src="https://d3js.org/d3.v3.js"></script>
</head>
<body>
	<div id="myDiv"></div>
	<Script>
		d3.csv("${csv_url}", function(err, rows){
		  function unpack(rows, key) {
		  return rows.map(function(row) {
			  	row.time = row.time.substr(0, row.time.indexOf('U')-1)
			  	return row[key];
			  });
		}


		var trace1 = {
		  type: "scatter",
		  mode: "lines",
		  x: unpack(rows, 'time'),
		  y: unpack(rows, 'data'),
		  line: {color: '#17BECF'}
		}

		var data = [trace1];

		var layout = {
		  title: 'Basic Time Series',
		  xaxis: {
		      tickformat: '%H:%M:%S' // For more time formatting types, see: https://github.com/d3/d3-time-format/blob/master/README.md
		  }
		};

		Plotly.newPlot('myDiv', data, layout);
		})
	</Script>
</body>
</html>