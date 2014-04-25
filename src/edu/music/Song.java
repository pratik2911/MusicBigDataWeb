package edu.music;

public class Song{
	
	private String songId;
  private String songName;
  private String artistId;
  private String artistName;
  
  public void setSongId(String songId){
  	this.songId = songId;
  }
  
  public void setSongName(String songName) {
  	this.songName = songName;
  }
  
  public void setArtistId(String artistId) {
  	this.artistId = artistId;
  }
  
  public void setArtistName(String artistName){
  	this.artistName = artistName;
  }
  
  public String getSongId(){
  	return songId;
  }
  public String getSongName() {
  	return songName;
  }

  public String getArtistId() {
  	return artistId;
  }
  
  public String getArtistName(){
  	return artistName;
  }
  @Override
  public String toString() {
          return "Song [songID=" + songId + ", songName=" + songName + ", artistId="
                          + artistId + "artistName: "+ artistName+"]";
  }

 
}

