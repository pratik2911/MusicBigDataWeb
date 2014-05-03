<%@page import="edu.music.Song"%>
<%@page import="edu.music.JsonHelper"%>
<%@page import="edu.music.HBaseApi"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet"
	href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">

<!-- Optional theme -->
<link rel="stylesheet"
	href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">

<!-- Latest compiled and minified JavaScript -->
<script
	src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>

<!-- Custom styles for this template -->
<link href="dashboard.css" rel="stylesheet">

<%!private static final String API_KEY = "EX6P8AWPX20EYYEAD";%>

<title>Big Data Analytics</title>
</head>
<body>
	<%
	String trackID = request.getParameter("id");
	String songID = request.getParameter("songId");
	String resp;
	String respBuff = "";
	
	if(request.getParameter("songId") != null){
		if (trackID != null) {
			
			URL jsonPage = new URL("http://developer.echonest.com/api/v4/track/profile?api_key="
							+ API_KEY + "&format=json&id=" + trackID
							+ "&bucket=audio_summary");
			URLConnection urIcon = jsonPage.openConnection();
			BufferedReader br = new BufferedReader(new InputStreamReader(
					urIcon.getInputStream()));

			while ((resp = br.readLine()) != null) {
				respBuff += resp;
			}
			br.close();
			out.println(respBuff);
			if (respBuff != null) {
				Map trackDetails = (Map) JsonHelper
						.getMessageObject(respBuff);
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
	}
	
	out.println("<h1>Similar Songs</h1>");
	
	Song currentSong = new Song();
	Map<String, Double> map= HBaseApi.getOneRecord("song_similarity",songID);
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
		
		
		//out.println(respBuff+"<br><br>");
		if(respBuff!=""){
			String arr[] = respBuff.split(",");
			String temp="";
			String json = respBuff.substring(respBuff.indexOf(arr[3]));
			json=json.substring(json.indexOf('[')+1 , json.lastIndexOf(']'));
			
			
			if(json.length()>0){
				currentSong=currentSong.fromJson(json);
				jsonPage= new URL("http://developer.echonest.com/api/v4/song/search?api_key=EX6P8AWPX20EYYEAD&format=json&results=1&artist="
					+currentSong.getArtist_name().toLowerCase().replace(" ", "%20")+"&title="+currentSong.getTitle().toLowerCase().replace(" ", "%20")+"&bucket=id:7digital-US&bucket=audio_summary&bucket=tracks");
				
				
				urIcon = jsonPage.openConnection();
				br = new BufferedReader(new InputStreamReader(urIcon.getInputStream()));
				while((resp = br.readLine()) != null){
					temp += resp;
				}
				br.close();
				
				Map bw = (Map) JsonHelper.getMessageObject(temp);
				Map tracks = (Map)((List)((Map)((List) ((Map)bw.get("response")).get("songs")).get(0)).get("tracks")).get(0);
				
				//out.println(tracks);
				out.println("<td><a href=\"displayTrackData.jsp?id="
				             +tracks.get("id")+"&songId="
							 +currentSong.getID()+"\"><img src=\""
				             +tracks.get("release_image")+"\" class=\"img-responsive\"></a></br>"
						     +"</br> Title: "+currentSong.getTitle()+"<br>Artist Name: "
				             +currentSong.getArtist_name()+"</td>");
				temp="";
			}
			respBuff="";
		}
		}catch (Exception e){
			e.printStackTrace();
		}
	}
	out.println("</tr>");
	out.println("</tbody></table>");
	
	%>
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script
		src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.1.1/js/bootstrap.min.js"></script>
</body>
</html>