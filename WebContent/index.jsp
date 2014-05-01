<%@page import="edu.music.Song"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="edu.music.HBaseApi"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.util.List"%>
<%@page import="java.lang.Exception" %>
<%@page import="java.util.regex.Pattern" %>
<%@page import="java.util.regex.Matcher" %>

<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">

<!-- Optional theme -->
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">

<!-- Latest compiled and minified JavaScript -->
<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>

 <!-- Custom styles for this template -->
    <link href="dashboard.css" rel="stylesheet">
    
<%!
	private static final String API_KEY = "EX6P8AWPX20EYYEAD";
	
%>

<title>Big Data Analytics</title>
</head>
<body>

<h1>Get Recommendations</h1>
<form action="index.jsp" method="post">
User ID: <input type="text" name="userId" id="userId" size="50" />
<input type="submit" class="btn btn-success" value="submit">
</form>


<%

	if(request.getParameter("userId") != null){
		String resp;
		String respBuff="";
		List<String> outList = HBaseApi.getRecommendations(request.
				getParameter("userId").toString(),"recommendations", "item_based");
		Song currentSong = new Song();
		out.println("<table class='table-hover table table-bordered' >");
		out.println("<thead><th>Album Art</th><th>Song Title</th><th>Artist Name</th></thead><tbody>");
		for(String str : outList){
			try {
			String id = str.split(":")[0];
			//out.println(id+"  ");
			URL jsonPage = new URL("http://developer.echonest.com/api/v4/song/profile?api_key="+API_KEY+"&format=json&id="+id.trim());
			URLConnection urIcon = jsonPage.openConnection();
			BufferedReader br = new BufferedReader(new InputStreamReader(urIcon.getInputStream()));
			
			while((resp = br.readLine()) != null){
				respBuff += resp;
			}
			
			br.close();
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
					Matcher m = Pattern.compile(".*(http:.*jpg).*").matcher(temp);
					if(m.matches()){
						out.println("<tr><td><img src=\""+m.group(1)+"\" class=\"img-responsive\"></td> <td>"+currentSong.getTitle()+"</td><td> \n "+currentSong.getArtist_name()+"</td></tr>");
					}
					
					temp="";
				}
				
			}
			
			respBuff="";
			}catch (Exception e){
				e.printStackTrace();
			}
		}
		out.println("</tbody></table>");
	}
	
%>

	<!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.1.1/js/bootstrap.min.js"></script>
    
</body>
</html>