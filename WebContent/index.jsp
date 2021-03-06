<%@page trimDirectiveWhitespaces = "true" %>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="edu.music.HBaseApi"%>
<%@page import="edu.music.JsonHelper"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>

<%@ page language="java" contentType="text/html; charset=US-ASCII"
	pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
	<!-- Bootstrap core CSS -->
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet">
    
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

	<!-- Latest compiled and minified JavaScript -->
	<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>

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

		<!--  Body  -->
		<div class="panel panel-default">
		<div class="panel-heading">
		<h1>Music Recommendations</h1>
		</div>
		<div class="panel-body">
		<div class="row">
		  <div class="col-md-6">
			<form action="index.jsp" method="get">
				User ID: <input type="text" name="userId" id="userId" size="50" />
				<input type="submit" class="btn btn-success" value="Submit">
			</form>
		  	</div>
		  	<div class="col-md-6">
		  	<form action="displayTrackData.jsp" method="get">
				Song ID: <input type="text" name="songId" id="songId" size="50" />
				<input type="submit" class="btn btn-success" value="Submit">
			</form>
		  </div>
		</div>
		<br><br>

<%!
	private static final String API_KEY = "EX6P8AWPX20EYYEAD";
	
%>

<%
	
	String userId=request.getParameter("userId");
	
	if(userId != null && userId.length()>0){
		String resp;
		String temp2="";
		String respBuff="";
		Map<String, Double> outList = HBaseApi.getRecommendations(userId.toString(),"recommendations_large", "item_based");
		Map<String, Double> history = HBaseApi.getRecommendations(userId.toString(), "recommendations_large", "input");
		
		out.println("<h3>User History</h3>");
		if(history.size()>0){
			
			out.println("<table class='table-hover table table-bordered' >");
			out.println("<tbody>");
			out.println("<tr>");
			int count=0;
			for (String id : history.keySet()){
				respBuff="";
				
				try {
				URL jsonPage = new URL("http://developer.echonest.com/api/v4/song/profile?api_key="+API_KEY+"&format=json&id="+id.trim());
				URLConnection urIcon = jsonPage.openConnection();
				BufferedReader br = new BufferedReader(new InputStreamReader(urIcon.getInputStream()));
				
				while((resp = br.readLine()) != null){
					respBuff += resp;
				}
				br.close();
				
				if(respBuff!=""){
					temp2="";
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
					out.println("<td><a href=\"displayTrackData.jsp?id="
				            +tracks.get("id")+"&songId="
							+id+"\"><img src=\""
				            +tracks.get("release_image")+"\" class=\"img-responsive\"></a></br>"
						    +"</br> Title: "+songBw.get("title")+"<br>Artist Name: "
				            +songBw.get("artist_name")+"</td>");
					count++;
					if(count>10){
						break;
					}
				}
				else{
					out.println("User not Found. Try Again.");
				}
				}catch(Exception e){
					
				}
			}
			
			
			out.println("</tr>");
			out.println("</tbody></table>");
		}else{
			out.println("User history NOT found! Try Again.");
		}
		
		out.println("<h3>Recommendations</h3>");
		if(outList.size()>0){
			out.println("<table class='table-hover table table-bordered' >");
			out.println("<tbody>");
			out.println("<tr>");
			
			for(String id : outList.keySet()){
				try {
				//String id = str.split(":")[0];
				URL jsonPage = new URL("http://developer.echonest.com/api/v4/song/profile?api_key="+API_KEY+"&format=json&id="+id.trim());
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
								 +id+"\"><img src=\""
					             +tracks.get("release_image")+"\" class=\"img-responsive\" height=\"200\" width=\"200\"></a></br>"
							     +"</br> Title: "+songBw.get("title")+ "<br>Artist Name: "
					             +songBw.get("artist_name")+"</td>");
				}
				respBuff="";
				}catch (Exception e){
					e.printStackTrace();
				}
			}
			out.println("</tr>");
			out.println("</tbody></table>");
		}else{
			out.println("Recommendations NOT found! Try Again.");
		}
	}
	
%>
</div>
</div>
</div>
    </div>

	<!-- Bootstrap core JavaScript
    ================================================== -->
	<!-- Placed at the end of the document so the pages load faster -->
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script
		src="//cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.1.1/js/bootstrap.min.js"></script>

</body>
</html>
