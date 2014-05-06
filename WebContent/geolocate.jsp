<%@page import="edu.music.GeoLocate"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="edu.music.GenreByYears"%>

<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
	<link href="jvectormap/jquery-jvectormap-1.2.2.css" rel="stylesheet">
	<!-- Bootstrap core CSS -->
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet">
    
	<!-- Latest compiled and minified JavaScript -->
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
	<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	<script src="jvectormap/jquery-jvectormap-1.2.2.min.js"></script>
	<script src="jvectormap/jquery-jvectormap-world-mill-en.js"></script>

<title>Geo Locate</title>
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
                <li><a href="topArtists.jsp">Popular Artists</a></li>
                <li><a href="topSongs.jsp">Popular Songs</a></li>
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="geolocate.jsp">Geo-locate</a></li>
              </ul>
            </div>
          </div>
        </div>

		<!--  Body  -->
		<div class="panel panel-default">
		<div class="panel-heading">
		<h1>Geo Location</h1>
		</div>
		<div class="panel-body">
		<div class="row">
		  <div class="col-md-6">
			<h4></>Selected Genre:
			<%String file = request.getParameter("genre");
			if(file!=null){
				out.print(file);
			}
			%> 
			</h4>
			<form action="geolocate.jsp" method="get">
			<select class="form-control" onchange="this.form.submit()" name="genre" id="genre" >
			  <%
			  GenreByYears gen = new GenreByYears();
			  String[] allGenres = gen.getAllGenres();
			  for (String option: allGenres){
			  	out.println("<option>"+option+"</option>");
			  }
			  %>
			</select>
			</form>
		
		<br><br>

		<div id="world-map-markers" style= "width: 1000px; height: 600px; padding-left: 60px"></div>
		</div>
	</div>
	</div>
	</div>
	
	<script type="text/javascript">
	$(function(){
		  var map,
		      markers = [
				<%
				GeoLocate geo = new GeoLocate();
				String jspPath = session.getServletContext().getRealPath("/geolocationfiles");
				List<Map<String, String>> list = geo.createLists(jspPath+"/"+file);
				for(Map<String, String> entry: list){
					out.println("{ latLng: ["+entry.get("latitude")+", "
						+entry.get("longitude")+"], name: \""+entry.get("city")+"\"}," );
				}
				%>
		      ],
		      cityAreaData = [
		        <%
		        for(Map<String, String> entry: list){
					out.println(entry.get("count")+", ");
				}
		        %>
		      ]

		  map = new jvm.WorldMap({
		    container: $('#world-map-markers'),
		    map: 'world_mill_en',
		    regionsSelectable: true,
		    markersSelectable: true,
		    markers: markers,
		    markerStyle: {
		      initial: {
		        fill: '#5CD6FF'
		      },
		      selected: {
		        fill: '#FF9933'
		      }
		    },
		    regionStyle: {
		      initial: {
		        fill: '#FFFFFF'
		      },
		      selected: {
		        fill: '#B2B2B2'
		      }
		    },
		    series: {
		      markers: [{
		        attribute: 'r',
		        scale: [4, 25],
		        values: cityAreaData
		      }]
		    },
		    onRegionSelected: function(){
		      if (window.localStorage) {
		        window.localStorage.setItem(
		          'jvectormap-selected-regions',
		          JSON.stringify(map.getSelectedRegions())
		        );
		      }
		    },
		    onMarkerSelected: function(){
		      if (window.localStorage) {
		        window.localStorage.setItem(
		          'jvectormap-selected-markers',
		          JSON.stringify(map.getSelectedMarkers())
		        );
		      }
		    }
		  });
		  map.setSelectedRegions( JSON.parse( window.localStorage.getItem('jvectormap-selected-regions') || '[]' ) );
		  map.setSelectedMarkers( JSON.parse( window.localStorage.getItem('jvectormap-selected-markers') || '[]' ) );
		});
	$("#genre").prop("selectedIndex", -1);
</script>
</div>
</div>
</body>
</html>