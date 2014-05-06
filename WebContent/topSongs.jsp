<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="edu.music.HBaseApi"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="edu.music.JsonHelper"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
	
	<!-- Latest compiled and minified JavaScript -->
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
	
	<title>Popular Songs</title>
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
		<h1>Popular Songs</h1>
		</div>
		<div class="panel-body">
		
<%!private static final String API_KEY = "EX6P8AWPX20EYYEAD";%>
<% 

out.println("<table class='table-hover table table-bordered' >");
out.println("<thead><th>Rank</th><th>Song</th></thead><tbody>");


List<String> songIds = HBaseApi.getTopSongs(200);
int count =0;
for (String id : songIds){
	String respBuff="";
	String resp;
	try {
	URL jsonPage = new URL("http://developer.echonest.com/api/v4/song/profile?api_key="+API_KEY+"&format=json&id="+id.trim());
	URLConnection urIcon = jsonPage.openConnection();
	BufferedReader br = new BufferedReader(new InputStreamReader(urIcon.getInputStream()));
	
	while((resp = br.readLine()) != null){
		respBuff += resp;
	}
	br.close();
	
	if(respBuff!=""){
		String temp2="";
		Map bw = (Map) JsonHelper.getMessageObject(respBuff);
		Map songBw = (Map)((List)((Map)bw.get("response")).get("songs")).get(0);

		jsonPage= new URL("http://developer.echonest.com/api/v4/song/search?api_key=EX6P8AWPX20EYYEAD&format=json&results=1&artist="
				+songBw.get("artist_name").toString().toLowerCase().replace(" ", "%20")+"&title="+songBw.get("title").toString().toLowerCase().replace(" ", "%20")+"&bucket=id:7digital-US&bucket=audio_summary&bucket=tracks");
		urIcon = jsonPage.openConnection();
		br = new BufferedReader(new InputStreamReader(urIcon.getInputStream()));
		while((resp = br.readLine()) != null){
			temp2 += resp;
		}
		br.close();
		
		bw = (Map) JsonHelper.getMessageObject(temp2);
		Map tracks = (Map)((List)((Map)((List) ((Map)bw.get("response")).get("songs")).get(0)).get("tracks")).get(0);
		
		out.println("<td>"+(count+1)+"</td><td><a href=\"displayTrackData.jsp?id="
	            +tracks.get("id")+"&songId="
				+id+"\"><img src=\""
	            +tracks.get("release_image")+"\" class=\"img-responsive\" height=200 width=200></a></br>"
			    +"</br> Title: "+songBw.get("title")+"<br>Artist Name: "
	            +songBw.get("artist_name")+"</td></tr>");
		count++;
		if(count>100){
			break;
		}
	}
	}catch(Exception e){
	}
}
out.println("</tbody>");
out.println("</thead>");

%>
</div>
</div>
</div>
</div>
</body>
</html>