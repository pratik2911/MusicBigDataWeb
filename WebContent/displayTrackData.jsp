<%@page import="edu.music.JsonHelper"%>
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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%!
	private static final String API_KEY = "EX6P8AWPX20EYYEAD";
	
%>
<title>Insert title here</title>
</head>
<body>
	<%
		
		String trackID = request.getParameter("id");
		if( trackID != null){
			String resp;
			String respBuff="";
			URL jsonPage = new URL("http://developer.echonest.com/api/v4/track/profile?api_key="+API_KEY+"&format=json&id="+trackID+"&bucket=audio_summary");
			URLConnection urIcon = jsonPage.openConnection();
			BufferedReader br = new BufferedReader(new InputStreamReader(urIcon.getInputStream()));
			
			while((resp = br.readLine()) != null){
				respBuff += resp;
			}
			br.close();
			if(respBuff != null ){
				Map trackDetails = (Map)JsonHelper.getMessageObject(respBuff);
				
				Map list = (Map)((Map)trackDetails.get("response")).get("track");
				out.println(list.get("audio_summary"));
				
			}
			//out.println(respBuff);
			respBuff = "";
			
		
			}
	%>
</body>
</html>