<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="edu.music.HBaseApi"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet"
	href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">

<!-- Optional theme -->
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">

	<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	
	<!-- Latest compiled and minified JavaScript -->
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
	<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
	<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>

<title>Popular Artists</title>
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
		<h1>Popular Artists</h1>
		</div>
		<div class="panel-body">
	<% 

out.println("<table class='table-hover table table-bordered' >");
out.println("<thead><th>Rank</th><th>Artist Name</th></thead><tbody>");

List<Map.Entry<String,String>> artistId = HBaseApi.getTopArtists(100);
int count = 0;
while(count < 100){
   Map.Entry<String, String> map = artistId.get(count);
   String name = map.getValue();
   String[] topName = name.split("/");
   out.println("<tr class='clickableRow' href=\"displayArtist.jsp?id="+map.getKey()+"\"><td>"+(count+1)+"</td><td>"+topName[0]+"</td></tr>");
   count++;
}
out.println("</tbody>");
out.println("</thead>");

%>
</div>
</div>
</div>
</div>
<script>
jQuery(document).ready(function($) {
    $(".clickableRow").click(function() {
          window.document.location = $(this).attr("href");
    });
});
</script>
</body>
</html>