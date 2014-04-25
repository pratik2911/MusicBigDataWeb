<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="edu.music.HBaseApi"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.util.List"%>
<%@page import="java.lang.Exception" %>

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
				getParameter("userId").toString(), "item_based");
		
		for(String str : outList){
			try {
			String id = str.split(":")[0];
			URL jsonPage = new URL("http://developer.echonest.com/api/v4/song/profile?api_key="+API_KEY+"&format=json&id=potty");//+id.trim());
			URLConnection urIcon = jsonPage.openConnection();
			BufferedReader br = new BufferedReader(new InputStreamReader(urIcon.getInputStream()));
		
			while((resp = br.readLine()) != null){
				respBuff += resp;
			}
			br.close();
			out.println(respBuff+"<br><br><br>");
			respBuff="";
			}catch (Exception e){
				e.printStackTrace();
			}
		}
	}

	
	
	
%>
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/bootstrap.min.js"></script>
</body>
</html>