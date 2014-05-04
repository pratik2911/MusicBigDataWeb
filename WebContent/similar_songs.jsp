<%@page import="edu.music.HBaseApi"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>

<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Similar Songs</title>
</head>
<body>

<%

if(request.getParameter("songId") != null){
	String currentSong=request.getParameter("songId");
	Map<String, Double> map= HBaseApi.getOneRecord("song_similarity_large",
		currentSong);
	out.println(currentSong);
	for(String key : map.keySet()){
		out.print(key+" ");
	}

	}

%>

</body>
</html>