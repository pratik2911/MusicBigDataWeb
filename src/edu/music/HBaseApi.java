package edu.music;

import java.io.IOException;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.TreeMap;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.HColumnDescriptor;
import org.apache.hadoop.hbase.HTableDescriptor;
import org.apache.hadoop.hbase.KeyValue;
import org.apache.hadoop.hbase.MasterNotRunningException;
import org.apache.hadoop.hbase.ZooKeeperConnectionException;
import org.apache.hadoop.hbase.client.Delete;
import org.apache.hadoop.hbase.client.Get;
import org.apache.hadoop.hbase.client.HBaseAdmin;
import org.apache.hadoop.hbase.client.HConnection;
import org.apache.hadoop.hbase.client.HConnectionManager;
import org.apache.hadoop.hbase.client.HTableInterface;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.client.Result;
import org.apache.hadoop.hbase.client.ResultScanner;
import org.apache.hadoop.hbase.client.Scan;
import org.apache.hadoop.hbase.util.Bytes;

public class HBaseApi {
	private static Configuration conf = null;
	private static HConnection connection = null;
	
  /**
   * Initialization
   */
  static {
      conf = HBaseConfiguration.create();
			try {
				connection = HConnectionManager.createConnection(conf);
			} catch (ZooKeeperConnectionException e) {
				e.printStackTrace();
			}
  }

  /**
   * Create a table
   */
  public static void creatTable(String tableName, String[] familys)
          throws Exception {
      HBaseAdmin admin = new HBaseAdmin(conf);
      if (admin.tableExists(tableName)) {
          System.out.println("table already exists!");
      } else {
          HTableDescriptor tableDesc = new HTableDescriptor(tableName);
          for (int i = 0; i < familys.length; i++) {
              tableDesc.addFamily(new HColumnDescriptor(familys[i]));
          }
          admin.createTable(tableDesc);
          System.out.println("create table " + tableName + " ok.");
      }
      admin.close();
  }

  /**
   * Delete a table
   */
  public static void deleteTable(String tableName) throws Exception {
      try {
          HBaseAdmin admin = new HBaseAdmin(conf);
          admin.disableTable(tableName);
          admin.deleteTable(tableName);
          System.out.println("delete table " + tableName + " ok.");
          admin.close();
      } catch (MasterNotRunningException e) {
          e.printStackTrace();
      } catch (ZooKeeperConnectionException e) {
          e.printStackTrace();
      }
      
  }

  /**
   * Put (or insert) a row
   */
  public static void addRecord(String tableName, String rowKey,
          String family, String qualifier, String value) throws Exception {
      try {
      		HTableInterface table = connection.getTable(tableName);
          Put put = new Put(Bytes.toBytes(rowKey));
          put.add(Bytes.toBytes(family), Bytes.toBytes(qualifier), Bytes
                  .toBytes(value));
          table.put(put);
          System.out.println("insert recored " + rowKey + " to table "
                  + tableName + " ok.");
          table.close();
      } catch (IOException e) {
          e.printStackTrace();
      }
  }

  /**
   * Delete a row
   */
  public static void delRecord(String tableName, String rowKey)
          throws IOException {
  		HTableInterface table = connection.getTable(tableName);
      List<Delete> list = new ArrayList<Delete>();
      Delete del = new Delete(rowKey.getBytes());
      list.add(del);
      table.delete(list);
      System.out.println("del recored " + rowKey + " ok.");
      table.close();
  }

  /**
   * Get a row
   */
  public static Map<String,Double> getOneRecord (String tableName, String rowKey) throws IOException{
      HTableInterface table = connection.getTable(tableName);
      Get get = new Get(rowKey.getBytes());
      Result rs = table.get(get);
      TreeMap<String, Double> output=new TreeMap<String, Double>();
      String key="";
      
      for(KeyValue kv : rs.raw()){
//        System.out.print(new String(kv.getRow()) + " " );
//        System.out.print(new String(kv.getFamily()) + ":" );
//        System.out.print(new String(kv.getQualifier()) + " " );
//        System.out.print(kv.getTimestamp() + " " );
//        System.out.println(new String(kv.getValue()));
      	key=new String (kv.getRow());
      	output.put(new String(kv.getQualifier()), Double.parseDouble(new String(kv.getValue())));
      }
      table.close();
      
      Map<String,Double> sortedMap = sortByValues(output);
      System.out.println(sortedMap);
      return sortedMap;
  }

  /*
   * Java method to sort Map in Java by value e.g. HashMap or Hashtable
   * throw NullPointerException if Map contains null values
   * It also sort values even if they are duplicates
   */
	public static <K extends Comparable,V extends Comparable> Map<K,V> sortByValues(Map<K,V> map){
	List<Map.Entry<K,V>> entries = new LinkedList<Map.Entry<K,V>>(map.entrySet());
	
	Collections.sort(entries, new Comparator<Map.Entry<K,V>>() {
		@Override
		public int compare(Entry<K, V> o1, Entry<K, V> o2) {
			// TODO Auto-generated method stub
			return o2.getValue().compareTo(o1.getValue());
		}
    });
  
    //LinkedHashMap will keep the keys in the order they are inserted
    //which is currently sorted on natural ordering
    Map<K,V> sortedMap = new LinkedHashMap<K,V>();
  
    for(Map.Entry<K,V> entry: entries){
        sortedMap.put(entry.getKey(), entry.getValue());
    }
    return sortedMap;
	}
  /**
   * Scan (or list) a table
   */
  public static void getAllRecords (String tableName) {
      try{
      		 HTableInterface table = connection.getTable(tableName);
           Scan s = new Scan();
           ResultScanner ss = table.getScanner(s);
           for(Result r:ss){
               for(KeyValue kv : r.raw()){
                  System.out.print(new String(kv.getRow()) + " ");
                  System.out.print(new String(kv.getFamily()) + ":");
                  System.out.print(new String(kv.getQualifier()) + " ");
                  System.out.print(kv.getTimestamp() + " ");
                  System.out.println(new String(kv.getValue()));
               }
           }
           table.close();
      } catch (IOException e){
          e.printStackTrace();
      }
  }
  
  public static List<String> getRecommendations(String userId, String tableName, String familyName) {
    try{
    	 List<String> recommendations = new ArrayList<String>();
         HTableInterface table = connection.getTable(tableName);
         Get get = new Get(Bytes.toBytes(userId));
         get.addFamily(Bytes.toBytes(familyName));
         Result result = table.get(get);
         for(KeyValue keyValue : result.raw()) {
        	 recommendations.add(
        			 new String(keyValue.getQualifier())
        			 + ":"
        			 + new String(keyValue.getValue()));
        	 
         }
         table.close();
         return recommendations;
    } catch (Exception e){
    	return null;
    }
  }
  
	public static List<Map.Entry<String, String>> getTopArtists(int limit){
		try{
			int rank = 1;
			List<String> recommendations = new ArrayList<>();
			List<Map.Entry<String, String>> topArtists = new ArrayList<>();
			List<Get> getList = new ArrayList<Get>();
			HTableInterface topArtistsTable = connection.getTable(Bytes.toBytes("top_artists"));
			
			while(rank <= limit){
				Get get = new Get(Bytes.toBytes(rank));
				get.addFamily(Bytes.toBytes("most_popular"));
				getList.add(get);
				rank++;
			}
			
			Result[] result = topArtistsTable.get(getList);
			for(int i = 0; i < limit; ++i) {
				for(KeyValue keyValue : result[i].raw()){
					recommendations.add(new String(keyValue.getValue()));
				}
			}
			topArtistsTable.close();
			
			HTableInterface artistsTable = connection.getTable("artists"); 
			int count = 0;
			getList.clear();
			while(count < limit){
				//int k = count+1;
				Get getArtists = new Get(Bytes.toBytes(recommendations.get(count)));
				getArtists.addFamily(Bytes.toBytes("data"));
				getList.add(getArtists);
				count++;
			}
			
			Result[] res = artistsTable.get(getList);
			
			for(int i = 0; i < limit; ++i) {
				for(KeyValue key : res[i].raw()){
					if(key.matchingQualifier(Bytes.toBytes("artist_name"))){
						Map.Entry<String, String> map = new AbstractMap.SimpleEntry(recommendations.get(i), new String(key.getValue()));
						topArtists.add(map);
					}
				}
			}
			
			artistsTable.close();
			//System.out.println(topArtists);
			return topArtists;
		}catch(Exception e){
			e.printStackTrace();
			System.out.println(e.getMessage());
			return null;
		}
	}

    public static List<String> getTopSongs(int limit){
    	try{
    		int rank = 1;
    		List<String> recommendations = new ArrayList<>();
    		
    		HTableInterface table = connection.getTable("top_songs");
    		while(rank <= limit){
				Get get = new Get(Bytes.toBytes(rank));
				get.addFamily(Bytes.toBytes("most_listened"));
				Result result = table.get(get);
				for(KeyValue keyValue : result.raw()){
					recommendations.add(new String(keyValue.getQualifier()));
				}
				rank++;
			}
			table.close();
    		
    		
    		return recommendations;
    	}catch(Exception e){
    		return null;
    	}
    }
	
	
    public static Map<String,String> getArtists(String artistId){
  		HTableInterface table = null;
    	try{
    		table = connection.getTable("artists");
    		Map<String,String> map = new HashMap<>();
    		Get get = new Get(Bytes.toBytes(artistId));
    		get.addFamily(Bytes.toBytes("data"));
    		Result result = table.get(get);
    		for(KeyValue keyValue : result.raw()){
    			map.put(new String(keyValue.getQualifier()), new String(keyValue.getValue()));
    		}
    	return map;
    	}catch(Exception e){
    		return null;
    	}finally {
    		if (table != null) {
    			try {
						table.close();
					} catch (IOException e) {
					}
    		}
    	}
    }
  
  public static void main(String args[]) throws IOException{
  	getTopArtists(1);
  	long start = System.currentTimeMillis();
  	getTopArtists(100);
  	long stop = System.currentTimeMillis();
  	System.out.println("done "+(stop-start)/1000.0);
//  	System.out.println(getRecommendations("9be82340a8b5ef32357fe5af957ccd54736ece95","recommendations" ,"item_based"));
  	//Map<String, Double> out= getOneRecord("song_similarity_large", "SOAXQEG12AB01899F9");
  	//System.out.println(out.toString());
  	//getAllRecords("recommendations");
  }
}