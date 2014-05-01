package edu.music;
import java.io.IOException;

import org.apache.log4j.Logger;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;

/*
 * Java program to convert JSON String into Java object using Jackson library.
 * Jackson is very easy to use and require just two lines of code to create a Java object
 * from JSON String format.
 *
 * @author http://javarevisited.blogspot.com
 */
public class JsonToJavaConverter {
	private static Logger logger = Logger.getLogger(JsonToJavaConverter.class);
	public static void main(String args[]) throws JsonParseException, 
	JsonMappingException, IOException{ 
		Song converter = new Song();
		String json="{\"artist_id\": \"AR24DZB1187FB3C869\", \"id\": \"SOKIGVS1315CD465CB\", \"artist_name\": \"Erykah Badu\"}";
		
		//converting JSON String to Java object
		System.out.println(converter.fromJson(json));
	}
      
	
}

