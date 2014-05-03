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
<link rel="stylesheet"
	href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">

<!-- Latest compiled and minified JavaScript -->
<script
	src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>

<title>Top 100 Artists</title>
</head>
<body>
	<% 

out.println("<h3>Top Artists</h3><table class='table-hover table table-bordered' >");
out.println("<thead><th>Rank</th><th>Artist Name</th></thead><tbody>");

List<Map.Entry<String,String>> artistId = HBaseApi.getTopArtists(100);
int count = 0;
while(count < 100){
   Map.Entry<String, String> map = artistId.get(count);
   String name = map.getValue();
   String[] topName = name.split("/");
   out.println("<tr><td>"+(count+1)+"</td><td><a href=\"displayArtist.jsp?id="+map.getKey()+"\">"+topName[0]+"</a></td></tr>");
   count++;
}
out.println("</tbody>");
out.println("</thead>");

%>
</body>
</html>