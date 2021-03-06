<%@page import="edu.music.JsonHelper"%>
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
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
	<!-- Latest compiled and minified CSS -->
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">

	<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
	
	<!-- Latest compiled and minified JavaScript -->
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>

	<!-- Custom styles for this template -->
	<link href="dashboard.css" rel="stylesheet">

<%!private static final String API_KEY = "EX6P8AWPX20EYYEAD";%>

<title>Big Data Analytics</title>
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
	<%
	String trackID = request.getParameter("id");
	String songID = request.getParameter("songId");
	String resp;
	String respBuff = "";
	
	if(songID != null && songID.length()>0 && trackID !=null && trackID.length()>0 ){
		URL jsonPage = new URL("http://developer.echonest.com/api/v4/track/profile?api_key="
			+ API_KEY + "&format=json&id=" + trackID + "&bucket=audio_summary");
		URLConnection urIcon = jsonPage.openConnection();
		BufferedReader br = new BufferedReader(new InputStreamReader(
				urIcon.getInputStream()));

		while ((resp = br.readLine()) != null) {
			respBuff += resp;
		}
		
		br.close();
		if (respBuff != null) {
			Map trackDetails = (Map) JsonHelper
					.getMessageObject(respBuff);
			out.println("<h1>Track Data</h1>");
			out.println("<table class='table-hover table table-bordered' >");
			out.println("<thead><th>Release Image</th><th>Artist</th><th>Title</th><th>Danceability</th><th>Energy</th><th>Loudness</th><th>Liveness</th><th>Tempo</th></thead><tbody>");
			Map map = (Map) ((Map) trackDetails.get("response"))
					.get("track");
			Map list = (Map) map.get("audio_summary");
			out.println("<tr><td><img src=\""
					+ map.get("release_image")
					+ "\" class=\"img-responsive\"></td><td>"
					+ map.get("artist") + "</td><td>"
					+ map.get("title") + "</td><td>"
					+ list.get("danceability") + "</td><td>"
					+ list.get("energy") + "</td><td>"
					+ list.get("loudness") + "</td><td>"
					+ list.get("liveness") + "</td><td>"
					+ list.get("tempo") + "</td></tr>");
			out.println("</tbody></table>");
		}
		respBuff = "";
	}
	
	if(songID != null && songID.length()>0){
		out.println("<h1>Similar Songs</h1>");
		out.println("<h3>Recommendations</h3><table class='table-hover table table-bordered' >");
		out.println("<tbody>");
		out.println("<tr>");
		int count=0;
		Map<String, Double> map= HBaseApi.getOneRecord("song_similarity_large",songID);
		
		for(String key : map.keySet()){
			try{
			respBuff="";
			URL jsonPage = new URL("http://developer.echonest.com/api/v4/song/profile?api_key="+API_KEY+"&format=json&id="+key);
			URLConnection urIcon = jsonPage.openConnection();
			BufferedReader br = new BufferedReader(new InputStreamReader(urIcon.getInputStream()));
			
			while((resp = br.readLine()) != null){
				respBuff += resp;
			}
			br.close();
			
			if(respBuff!=""){
				String temp="";
				
				Map bw = (Map) JsonHelper.getMessageObject(respBuff);
				Map songBw = (Map)((List)((Map)bw.get("response")).get("songs")).get(0);
				
				jsonPage= new URL("http://developer.echonest.com/api/v4/song/search?api_key=EX6P8AWPX20EYYEAD&format=json&results=1&artist="
						+songBw.get("artist_name").toString().toLowerCase().replace(" ", "%20")+"&title="+songBw.get("title").toString().toLowerCase().replace(" ", "%20")+"&bucket=id:7digital-US&bucket=audio_summary&bucket=tracks");
				urIcon = jsonPage.openConnection();
				br = new BufferedReader(new InputStreamReader(urIcon.getInputStream()));
				while((resp = br.readLine()) != null){
					temp += resp;
				}
				br.close();
					
				bw = (Map) JsonHelper.getMessageObject(temp);
				Map tracks = (Map)((List)((Map)((List) ((Map)bw.get("response")).get("songs")).get(0)).get("tracks")).get(0);
				
				out.println("<td><a href=\"displayTrackData.jsp?id="
				             +tracks.get("id")+"&songId="
							 +key+"\"><img src=\""
				             +tracks.get("release_image")+"\" class=\"img-responsive\" height=200 width=200></a></br>"
						     +"</br> Title: "+songBw.get("title")+"<br>Artist Name: "
				             +songBw.get("artist_name")+"</td>");
				count++;
				if(count==10){
					break;
				}
				respBuff="";
			}
			}catch (Exception e){
				e.printStackTrace();
			}
		}
		out.println("</tr>");
		out.println("</tbody></table>");
	}
	
	%>
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script
		src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.1.1/js/bootstrap.min.js"></script>
		</div>
		</div>
</body>
</html>