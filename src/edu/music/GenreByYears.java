package edu.music;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class GenreByYears {
	private List<String> decades;
	private List<Integer> count;
	
	private Map<String, String> map;
	
	private String[] allGenres={"rock", "electronic", "pop", "alternative rock", "jazz", "hip hop", "united states", "alternative", "pop rock", "indie"};
	
	public GenreByYears(){
		decades = new ArrayList<String>();
		count = new ArrayList<Integer>();
		map = new HashMap<String, String>();
	}
	
	public void createLists(String tag) {
		count.clear();
		BufferedReader br = null;
		try {
			String sCurrentLine;
			br = new BufferedReader(new FileReader(tag));
			while ((sCurrentLine = br.readLine()) != null) {
				String arr[] = sCurrentLine.split(":");
				decades.add("'"+arr[0]+"'");
				count.add(Integer.parseInt(arr[1]));
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
	
	public List<String> getDecadeList(){
		return decades;
	}
	
	public List<Integer> getCountsList(){
		return count;
	}
	
	public String[] getAllGenres(){
		return allGenres;
	}
	
	public Map<String, String> getMap(String jspPath){
		for(String genre : allGenres){
			createLists(jspPath+genre);
			map.put(genre, getCountsList().toString());
		}
		return Collections.unmodifiableMap(map);
	}

	public static void main(String args[]){
		GenreByYears gen = new GenreByYears();
		//System.out.println(gen.getMap());
	}
}
