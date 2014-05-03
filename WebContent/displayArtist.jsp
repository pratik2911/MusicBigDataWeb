<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="edu.music.JsonHelper"%>
<%@page
	import="org.apache.commons.collections.iterators.EntrySetMapIterator"%>
<%@page import="java.util.Iterator"%>
<%@page import="edu.music.HBaseApi"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLConnection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%!private static final String API_KEY = "EX6P8AWPX20EYYEAD";%>
<link rel="stylesheet"
	href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">

<!-- Optional theme -->
<link rel="stylesheet"
	href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">

<!-- Latest compiled and minified JavaScript -->
<script
	src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Artist Details</title>
</head>
<body>

	<%
		out.println("<h3>Top Artists</h3><table class='table-hover table table-bordered' >");
		out.println("<thead><th>Label</th><th>Values</th></thead><tbody>");

		String artistId = request.getParameter("id");
		Map<String, String> artist = HBaseApi.getArtists(artistId);
		Map<String,String> names = new HashMap();
        Map<String,String> images = new HashMap();
		Map<String, String> data = new HashMap();
		for (Map.Entry<String, String> map : artist.entrySet()) {
			if ((map.getKey().equals("artist_name"))
					|| (map.getKey().equals("artist_terms"))
					|| (map.getKey().equals("similar_artists"))) {
				data.put(map.getKey(), map.getValue());

			}

		}
		String[] imgId = data.get("similar_artists").split(",");
		for (int i = 0; i < 10; i++) {
			Map<String,String>tmp = HBaseApi.getArtists(imgId[i]);
			for(Map.Entry<String,String> m : tmp.entrySet()){
				if(m.getKey().equals("artist_name")){
					String[] str = m.getValue().split("/");
					names.put(imgId[i], str[0]);
				}
			}
			String resp;
			String respBuff = "";
			URL jsonPage = new URL(
					"http://developer.echonest.com/api/v4/artist/images?api_key="
					+API_KEY+"&id="
					+imgId[i]+"&format=json&results=1&start=0&license=unknown");
			URLConnection urIcon = jsonPage.openConnection();
			BufferedReader br = new BufferedReader(new InputStreamReader(
					urIcon.getInputStream()));

			while ((resp = br.readLine()) != null) {
				respBuff += resp;
			}
			br.close();
			
			if (respBuff != null) {
				Map trackDetails = (Map) JsonHelper.getMessageObject(respBuff);
				
				List map = (List) ((Map) trackDetails.get("response"))
						.get("images");
				Map src = (Map)map.get(0);
				//out.println(src.get("url"));
				
				images.put(imgId[i], src.get("url").toString());
			}
			
			respBuff = "";

		}
		String name = data.get("artist_name").split("/")[0];
		out.println("<tr><td>" + "Artist Name" + "</td><td>"
				+ name + "</td></tr>");
		out.println("<tr><td>" + "Artist Tags" + "</td><td>"
				+ data.get("artist_terms") + "</td></tr>");
		out.println("</thead>");
		out.println("</tbody>");
		/* out.println("<tr><td><a href=\"displayArtist.jsp?id="++>" + "Similar Artists" + "</td><td>"
				+ data.get("similar_artists") + "</td></tr>"); */
		
		out.println("<table class='table-hover table table-bordered' >");
				
		out.println("<tr><td>"+"Similar Artists Recommendations"+"</td>");
		for(Map.Entry<String,String> im : images.entrySet()){
			if(names.get(im.getKey()) != null )
			out.println("<td><a href=\"displayArtist.jsp?id="
		                 +im.getKey()+"\"><img src=\""
			             +im.getValue()+"\" height=100 width=100></a><br>"
		                 +names.get(im.getKey())+"</td>");
		}
		out.println("</tr>");
		
		out.println("</tbody>");
		//out.println(images.toString());
	%>
</body>
</html>