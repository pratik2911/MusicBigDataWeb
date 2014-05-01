package edu.music;

import java.io.IOException;

import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;

public class Song {
	private String artist_id;
  private String id;
  private String artist_name;
  private String title;

  public String getArtistId() {
  	return artist_id;
  }
  public void setArtist_id(String phone) {
  	this.artist_id = phone;
  }
  
  public String getID() {
  	return id;
  }
  public void setId(String id) {
  	this.id = id;
  }
  
  public String getTitle() {
  	return title;
  }
  public void setTitle(String title) {
  	this.title = title;
  }
  
  public String getArtist_name() {
  	return artist_name;
  }
  public void setArtist_name(String artist_name) {
  	this.artist_name = artist_name;
  }
    
  @Override
  public String toString() {
  	return "Song [artist_id=" + artist_id + ", id=" + id + ", artist_name=" + 
  			artist_name+ ", title="+ title +"]";
  }
  
  public Song fromJson(String json) throws JsonParseException,
	JsonMappingException, IOException{
		Song song = new ObjectMapper().readValue(json, Song.class);
    return song;
  }
}