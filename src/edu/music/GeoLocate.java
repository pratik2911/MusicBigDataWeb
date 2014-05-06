package edu.music;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class GeoLocate {
	
	private Map<String, String> map;
	private static List<Map<String, String>> list;
	
	public GeoLocate(){
		map= new HashMap<String, String>();
		list = new ArrayList<Map<String,String>>();
	}
	public List<Map<String, String>> createLists(String tag) {
		if(!tag.contains("null")){
			BufferedReader br = null;
			try {
				String sCurrentLine;
				int count =0;
				br = new BufferedReader(new FileReader(tag));
				while ((sCurrentLine = br.readLine()) != null) {
					String arr[] = sCurrentLine.split("\t");
					try{
					map = new HashMap<String, String>();
					map.put("latitude",arr[1]);
					map.put("longitude",arr[2]);
					map.put("city",arr[3]);
					map.put("count",arr[4]);
					if(!arr[3].contains("<")){
						list.add(map);
					}
					}catch(Exception e) {
						//System.out.println(sCurrentLine);
					}
				}
				
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				try {
					if (br != null){
						br.close();
					}
				} catch (IOException ex) {
					ex.printStackTrace();
				}
			}
		}
		return list;

	}
	
	public static void main(String args[]) {
		GeoLocate geo = new GeoLocate();
		List<Map<String, String>> lis = geo.createLists("united states");
		//System.out.println(lis);
	}
}
