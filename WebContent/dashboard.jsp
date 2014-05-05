<%@ page language="java" contentType="text/html; charset=US-ASCII"
	pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">

	<!-- Bootstrap core CSS -->
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet">
    <link href="dashboard.css" rel="stylesheet">

	<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	
	<!-- Latest compiled and minified JavaScript -->
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
	
	<script src="http://code.highcharts.com/highcharts.js"></script>
	<script src="http://code.highcharts.com/highcharts-3d.js"></script>
	<script src="http://code.highcharts.com/modules/exporting.js"></script>	

<title>Dashboard</title>
</head>
<body>

<div class="navbar-wrapper">
      <div class="container" >

        <div class="navbar navbar-inverse" role="navigation">
          <div class="container">
            <div class="navbar-header">
              <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
              </button>
              <a class="navbar-brand" href="index.jsp">Million Songs Data Analytics</a>
            </div>
            <div class="navbar-collapse collapse">
              <ul class="nav navbar-nav">
              	<li><a href="data.jsp">Data Overview</a></li>
              	<li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="topArtists.jsp">Popular Artists</a></li>
                <li><a href="topSongs.jsp">Popular Songs</a></li>
              </ul>
            </div>
          </div>
        </div>

		<!--  Body  -->
		<div class="panel panel-default">
		<div class="panel-heading">
		<h1>Dashboard</h1>
		</div>
		<div class="panel-body">
		<div class="row">
		  
		<div id="container"></div>
			<div id="sliders">
			<table>
				<tr><td>Alpha Angle</td><td><input id="R0" type="range" min="0" max="45" value="15"/> <span id="R0-value" class="value"></span></td></tr>
			    <tr><td>Beta Angle</td><td><input id="R1" type="range" min="0" max="45" value="15"/> <span id="R1-value" class="value"></span></td></tr>
			</table>
			</div>
		</div>
	</div>
	</div>
	</div>
    </div>

	<!-- Bootstrap core JavaScript
    ================================================== -->
	<!-- Placed at the end of the document so the pages load faster -->
	
	<script type="text/javascript">
	$(function () {
	    // Set up the chart
	    var chart = new Highcharts.Chart({
	        chart: {
	            renderTo: 'container',
	            type: 'column',
	            margin: 75,
	            options3d: {
	                enabled: true,
	                alpha: 15,
	                beta: 15,
	                depth: 50,
	                viewDistance: 25
	            }
	        },
	        xAxis: {
	        	labels:{
	        		style:{
	        			fontSize:'12px',
	        		}
	        	},
	        	categories: ['rock', 'electronic', 'pop', 'alternative rock', 'jazz', 'hip-hop', 'united states', 'alternative', 'pop-rock', 'indie']
	        },
	        title: {
	            text: 'Artist Tag Distribution'
	        },
	        plotOptions: {
	            column: {
	                depth: 25
	            }
	        },
	        series: [{
	        	name: 'Tags',
	            data: [{y:710380, color:'#50B432'},
	                   {y:561726, color:'#ED561B'},
	                   {y:552218, color:'#DDDF00'},
	                   {y:372316, color:'#24CBE5'},
	                   {y:349815, color:'#64E572'},
	                   {y:342988, color:'#FF9655'},
	                   {y:332237, color:'#FFF263'},
	                   {y:308743, color:'#6AF9C4'},
	                   286271, 
	                   {y:282390, color:'#248687'}
	                   ]
	        }]
	    });
	    

	    // Activate the sliders
	    $('#R0').on('change', function(){
	        chart.options.chart.options3d.alpha = this.value;
	        showValues();
	        chart.redraw(false);
	    });
	    $('#R1').on('change', function(){
	        chart.options.chart.options3d.beta = this.value;
	        showValues();
	        chart.redraw(false);
	    });

	    function showValues() {
	        $('#R0-value').html(chart.options.chart.options3d.alpha);
	        $('#R1-value').html(chart.options.chart.options3d.beta);
	    }
	    showValues();
	});
	</script>

</body>
</html>
