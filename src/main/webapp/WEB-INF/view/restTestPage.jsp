<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>restTestPage</title>

<!-- Bootstrap core CSS -->
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css"
	integrity="sha384-GJzZqFGwb1QTTN6wy59ffF1BuGJpLSa9DkKMp0DgiMDm4iYMj70gZWKYbI706tWS"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.10.19/css/dataTables.bootstrap4.min.css">

<script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
<script src="https://d3js.org/d3.v3.js"></script>

<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.2.1/js/bootstrap.bundle.min.js"></script>
<script src="js/jquery.csv.min.js"></script>
<script
	src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
<script
	src="https://cdn.datatables.net/1.10.19/js/dataTables.bootstrap4.min.js"></script>
<script src="js/csv_to_html_table.js"></script>
</head>
<body>
	<!-- 
	<div
		style="overflow: auto; width: 500px; height: 800px; display: inline-block"
		id="table-container"></div>
	 
	<div
		style="position: absolute; left: 500px; right: 0px; display: inline-block"
		id="myDiv"></div>
	 -->
	<div id="myDiv" style="width:49%; float:left"></div>
	<div id="myDiv2" style="width:49%; float:right"></div>
	<Script>
	/* CsvToHtmlTable.init({
		csv_path: '${csv_url}', 
	    element: 'table-container', 
	    allow_download: true,
	    csv_options: {separator: ',', delimiter: '"'},
	    datatables_options: {"paging": false}
	}); */

	var base_data_length = 1780;
	var n = 0;
	var count = 0;
	function draw(){
		d3.csv("${csv_url}?=" + Date.now(), function(err, rows){
			rows = rows.slice(base_data_length)
			
			rows = rows.map(row => {
				s = row.time.split("T")
				s = s[0] + " " + s[1].slice(0, s[1].length-1)
				// row.time = row.time.substr(0, row.time.indexOf('U')-1)
				return row;
			});
			
			function unpack(rows, key) {
				return rows.map(function(row) {
			  			return row[key];
					});
			}

			var trace1 = {
				type: "scatter",
				mode: "lines",
				name: 'value',
				x: unpack(rows, 'time'),
				y: unpack(rows, 'value'),
				line: {color: '#17BECF'}
			}
			
			console.log(rows)
			function unpack2(rows, key) {
				return rows.filter(row => row['is_anomaly'] == "True").map(row => {
						return row[key];
					});
			}
			
			var trace3 = {
				type: "scatter",
				mode: "lines",
				name: 'ema',
				x: unpack(rows, 'time'),
				y: unpack(rows, 'ema'),
				line: {color: '#FF0000'}
			}
			
			// anomaly data
			var trace2 = {
				x: unpack2(rows, 'time'),
				y: unpack2(rows, 'value'),
				mode: 'markers',
				name: 'anomaly',
				marker: {
				    color: 'rgb(219, 64, 82)',
				    size: 12
				}
			}
			
			var trace4 = {
				x: unpack2(rows, 'time'),
				y: unpack2(rows, 'ema'),
				name: 'anomaly',
				mode: 'markers',
				marker: {
				    color: 'rgb(219, 64, 82)',
				    size: 12
				}
			}
			
			// var data = [trace1, trace2, trace3, trace4];
			var data = [trace1, trace2];
			var data2 = [trace3, trace4];
	
			var layout = {
				title: 'Motor Vibration Time Series',
				xaxis: {
					tickformat: '%H:%M:%S' // For more time formatting types, see: https://github.com/d3/d3-time-format/blob/master/README.md
				}
			};
			
			var layout2 = {
				title: 'Motor Vibration Time Series(EMA)',
				xaxis: {
					tickformat: '%H:%M:%S' // For more time formatting types, see: https://github.com/d3/d3-time-format/blob/master/README.md
				}
			};
			
			n = rows.length;
			console.log("길이 : " + n);
			count = unpack2(rows, 'time').length;
			console.log("이상치 개수 : " + count);
			Plotly.newPlot('myDiv', data, layout);
			Plotly.newPlot('myDiv2', data2, layout2);
		})
	}
	
	draw();

	// https://plotly.com/javascript/streaming/
	var interval = setInterval(function() {

		d3.csv("${csv_url}?=" + Date.now(), function(err, rows){
			// rows = rows.slice(n);
			rows = rows.slice(base_data_length+n);
			
			rows = rows.map(row => {
				s = row.time.split("T")
				s = s[0] + " " + s[1].slice(0, s[1].length-1)
				// row.time = row.time.substr(0, row.time.indexOf('U')-1)
				return row;
			});
			
			function unpack(rows, key) {
				return rows.map(function(row) {
			  			return row[key];
					});
			}

			var trace1 = {
				x: [unpack(rows, 'time')],
				y: [unpack(rows, 'value')],
			}
			
			var trace3 = {
				x: [unpack(rows, 'time')],
				y: [unpack(rows, 'ema')],
			}
			
			function unpack2(rows, key) {
				return rows.filter(row => row['is_anomaly'] == "True").map(row => {
						return row[key];
					});
			}
			
			// anomaly data
			var trace2 = {
				x: [unpack2(rows, 'time')],
				y: [unpack2(rows, 'value')],
			}
			var trace4 = {
				x: [unpack2(rows, 'time')],
				y: [unpack2(rows, 'ema')],
			}
			
			n += rows.length;
			console.log("길이 : " + n);
			count += unpack2(rows, 'time').length;
			console.log("이상치 개수 : " + count);
			if(unpack2(rows, 'time').length > 0){
				// alert("이상치 발견");
			}
			
			if (rows.length != 0) {
				Plotly.extendTraces('myDiv', trace1, [0]);
				Plotly.extendTraces('myDiv2', trace3, [0]);
				Plotly.extendTraces('myDiv', trace2, [1]);
				Plotly.extendTraces('myDiv2', trace4, [1]);
			}
		});
	
	}, 500);
		
		
		
	</Script>
</body>
</html>