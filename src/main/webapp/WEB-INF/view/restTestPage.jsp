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
	<div id="myDiv"></div>
	<Script>
	/* CsvToHtmlTable.init({
		csv_path: '${csv_url}', 
	    element: 'table-container', 
	    allow_download: true,
	    csv_options: {separator: ',', delimiter: '"'},
	    datatables_options: {"paging": false}
	}); */

	var n = 0;
	var count = 0;
	function draw(){
		d3.csv("${csv_url}?=" + Date.now(), function(err, rows){
			rows = rows.map(row => {
				row.time = row.time.substr(0, row.time.indexOf('U')-1)
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
				x: unpack(rows, 'time'),
				y: unpack(rows, 'data'),
				line: {color: '#17BECF'}
			}
			
			function unpack2(rows, key) {
				return rows.filter(row => row['anomaly_boolean'] == "TRUE").map(row => {
						return row[key];
					});
			}
			
			// anomaly data
			var trace2 = {
				x: unpack2(rows, 'time'),
				y: unpack2(rows, 'data'),
				mode: 'markers',
				marker: {
				    color: 'rgb(219, 64, 82)',
				    size: 12
				}
			}
			
			var data = [trace1, trace2];
	
			var layout = {
				title: 'Motor Vibration Time Series',
				xaxis: {
					tickformat: '%H:%M:%S' // For more time formatting types, see: https://github.com/d3/d3-time-format/blob/master/README.md
				}
			};
			
			n = rows.length;
			console.log("길이 : " + n);
			count = unpack2(rows, 'time').length;
			console.log("이상치 개수 : " + count);
			Plotly.newPlot('myDiv', data, layout);
		})
	}
	
	draw();

	// https://plotly.com/javascript/streaming/
	var interval = setInterval(function() {

		d3.csv("${csv_url}?=" + Date.now(), function(err, rows){
			rows = rows.slice(n);
			
			rows = rows.map(row => {
				row.time = row.time.substr(0, row.time.indexOf('U')-1)
				return row;
			});
			
			function unpack(rows, key) {
				return rows.map(function(row) {
			  			return row[key];
					});
			}

			var trace1 = {
				x: [unpack(rows, 'time')],
				y: [unpack(rows, 'data')],
			}
			
			function unpack2(rows, key) {
				return rows.filter(row => row['anomaly_boolean'] == "TRUE").map(row => {
						return row[key];
					});
			}
			
			// anomaly data
			var trace2 = {
				x: [unpack2(rows, 'time')],
				y: [unpack2(rows, 'data')],
			}
			
			n += rows.length;
			console.log("길이 : " + n);
			count += unpack2(rows, 'time').length;
			console.log("이상치 개수 : " + count);
			if(unpack2(rows, 'time').length > 0){
				alert("이상치 발견");
			}
			
			if (rows.length != 0) {
				Plotly.extendTraces('myDiv', trace1, [0]);
				Plotly.extendTraces('myDiv', trace2, [1]);
			}
		});
	
	}, 500);
		
		
		
	</Script>
</body>
</html>