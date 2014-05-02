package edu.music;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;

public class JsonHelper {
	
	public static void main(String args[]) throws IOException, JSONException {
		String respBuff = "";
		String resp = "";
		URL jsonPage = new URL("http://developer.echonest.com/api/v4/song/search?api_key=EX6P8AWPX20EYYEAD&format=json&results=1&artist=erykah%20badu&title=master%20teacher%20medley&bucket=id:7digital-US&bucket=audio_summary&bucket=tracks");
		URLConnection urIcon = jsonPage.openConnection();
		BufferedReader br = new BufferedReader(new InputStreamReader(urIcon.getInputStream()));
		while((resp = br.readLine()) != null){
			respBuff += resp;
		}
		br.close();
		Gson gson = new GsonBuilder().setPrettyPrinting().disableHtmlEscaping()
		    .create();
		JsonParser jp = new JsonParser();
		JsonElement je = jp.parse(respBuff);
		String prettyJsonString = gson.toJson(je);
		System.out.println(prettyJsonString);
		Map bw = (Map) getMessageObject(respBuff);
		//System.out.println(bw);
		List list = (List) ((Map)bw.get("response")).get("songs");
		System.out.println(((Map)list.get(0)).get("tracks"));
	}
  
  public static String getJsonString(JSONObject messageObject) {
    return messageObject.toString();
  }
  
  public static Object getMessageObject(String jsonString) throws JSONException {
    return getObject(new JSONObject(jsonString));
  }
  
  @SuppressWarnings({ "unchecked" })
  static Object getObject(Object object) {
    try {
      if (object == null) {
        return object;
      }
      if (object instanceof Integer || object instanceof Double
          || object instanceof String || object instanceof Boolean) {
        return object;
      }
      if (object instanceof JSONArray) {
        JSONArray array = (JSONArray) object;
        List<Object> list = new ArrayList<Object>();
        for (int i = 0; i < array.length(); ++i) {
          list.add(getObject(array.get(i)));
        }
        return list;
      }
      if (object instanceof JSONObject) {
        JSONObject message = (JSONObject) object;
          JSONObject jsonObject = (JSONObject) object;
          Map<String, Object> innerMap = new HashMap<String, Object>();
          String [] names = JSONObject.getNames(jsonObject);
          if (names != null) {
            for (String name:names) {
              innerMap.put(name, getObject(jsonObject.get(name)));
            }
          }
          return innerMap;
        }
    }
    catch(Exception e) {
      return null;
    }
    return null;
  }
  
}