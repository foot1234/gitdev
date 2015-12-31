package com.me.utils;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.ResourceBundle;

import org.apache.log4j.Logger;
import org.me.db.dao.DoDao;
import org.me.db.model.ColumnInfoBean;
import org.me.db.util.PropertiesUtil;

import com.me.action.MainAction;

public class SysServiceUrlUtils {

	private static ResourceBundle res = ResourceBundle.getBundle("urls");//读取urls.properties
	private static 	Map<String,Object> urlsMap = null;
	private static DoDao ud = new DoDao();
	public static  Map<String, Map<String, Object>> sys_service_map = new HashMap<String, Map<String, Object>>();
	public static  Map<String, Map<String, String>> sys_function_map = new HashMap<String, Map<String, String>>();
	public static  Map<String, Map<String, String>> role_function_map = new HashMap<String, Map<String, String>>();
	public static  Map<String, String> sys_code_map = new HashMap<String, String>();
	
	//public static String logPath="";
	private final static Logger log= Logger.getLogger(SysServiceUrlUtils.class);
	/**
	 * sys_service_init 用于登录后，校验页面是否注册
	 * @throws Exception 
	 */
	public static void sys_service_init() throws Exception {
		
		Map<String, Object> map_Param =  new HashMap<String, Object>();
		// 设置参数，获取拼接好的sql
		ud.page_columns.setCurrentPage(1); //默认第一页
		ud.page_columns.setPageSize(100000);//每页显示100000条记录
		String sql = ud.get_sql(map_Param, "xml/sys/sys_service.xml", "load");// "select * from sys_service";
		//System.out.println(sql);
		// 查询数据
		List<Map<String, Object>> listMap = ud.query_list(sql);
		// 获取字段名
		List<ColumnInfoBean> listColum = ud.page_columns.getColumn_ls();
		
		//------------------------------初始华输出
//		for (Map<String, Object> m : listMap) {
//			String data = "";
//			for (ColumnInfoBean cl : listColum) {
//				data += m.get(cl.getName()) + ",";
//			}
//			System.out.println(data);
//		}
      //end------------------------------初始华输出
		
		for (Map<String, Object> m : listMap) {
			String service_name=(String)m.get("service_name");
			sys_service_map.put(service_name, m);
		}
//	Map<String, Object> ms=sys_service_map.get("modules/sys/SYS1110/sys_parameter.screen");
//	  Object oo=  ms.get("TITLE");
//		System.out.println("oo"+oo);	
	}

	/**
	 * sys_function_init 用于登录后，校验页面权限分配
	 * @throws Exception 
	 */
	public static void sys_function_init() throws Exception {
		
		Map<String, Object> map_Param =  new HashMap<String, Object>();
		// 设置参数，获取拼接好的sql
		ud.page_columns.setCurrentPage(1); //默认第一页
		ud.page_columns.setPageSize(100000);//每页显示100000条记录
		String sql = ud.get_sql(map_Param, "xml/sys/sys_function_service.xml", "sys_function");// "select * from sys_service";
		//System.out.println(sql);
		// 查询数据
		List<Map<String, Object>> listMap = ud.query_list(sql);
		// 获取字段名
		//List<ColumnInfoBean> listColum = ud.page_columns.getColumn_ls();
		
		//------------------------------初始华输出
//		for (Map<String, Object> m : listMap) {
//			String data = "";
//			for (ColumnInfoBean cl : listColum) {
//				data += m.get(cl.getName()) + ",";
//			}
//			System.out.println(data);
//		}
      //end------------------------------初始华输出
//--------功能对应的页面-------------------------------------------------------------------------------------------------------				
		String old_service_id="";
		 Map<String, String> function_service=null;
		 Integer b=0;
	      //end------------------------------初始华输出
			for (Map<String, Object> m : listMap) {
				String service_id=(String)m.get("service_id");
				if(b==0){
					function_service= new HashMap<String, String>();
					b=1;
					old_service_id=service_id;
				}
				if(!service_id.equals(old_service_id)){
					sys_function_map.put(old_service_id, function_service);
					old_service_id=service_id;
					function_service= new HashMap<String, String>();
				}
				if(b==1){
					function_service.put((String)m.get("function_id"), service_id);	
				}
			
			}
			//保存最后一次循环
			sys_function_map.put(old_service_id, function_service);
			
			//测试打印
		/*	System.out.println("----功能对应的页面------\n"); 
			  for( Entry<String, Map<String, String>> entry : sys_function_map.entrySet()) {
	           System.out.println(entry.getKey()+"----"+entry.getValue()+"\n");
		    }*/
//---------角色对应的功能-------------------------------------------------------------------------------------------------------		
	 sql = ud.get_sql(map_Param, "xml/sys/sys_function_service.xml", "role_function");// "select * from sys_service";
		// 查询数据
	 listMap = ud.query_list(sql);
	 String old_function_id="";
	 Map<String, String> role_function=null;
	 Integer a=0;
      //end------------------------------初始华输出
		for (Map<String, Object> m : listMap) {
			String function_id=(String)m.get("function_id");
			if(a==0){
				role_function= new HashMap<String, String>();
				a=1;
			    old_function_id=function_id;
			}
			//System.out.println(".................................function_id="+function_id+",old_function_id="+old_function_id);
			if(!function_id.equals(old_function_id)){
				role_function_map.put(old_function_id, role_function);
				old_function_id=function_id;
				role_function= new HashMap<String, String>();
			}
			if(a==1){
					role_function.put((String)m.get("role_id"), function_id);	
			}
		
		}
		//保存最后一次循环
		role_function_map.put(old_function_id, role_function);
		
		//测试打印
		/* System.out.println("----角色对应的功能-------\n"); 
		  for( Entry<String, Map<String, String>> entry : role_function_map.entrySet()) {
           System.out.println(entry.getKey()+"----"+entry.getValue()+"\n");
	    }*/
	}
	
	/**
	 * sys_code_init 用于sys_code 初始化
	 * @throws Exception 
	 */
	public static void sys_code_init() throws Exception {
		Map<String, Object> map_Param =  new HashMap<String, Object>();
		// 设置参数，获取拼接好的sql
		ud.page_columns.setCurrentPage(1); //默认第一页
		ud.page_columns.setPageSize(100000);//每页显示100000条记录
		String sql = ud.get_sql(map_Param, "xml/sys_code/sys_code.xml", "load");// "select * from sys_service";
		//System.out.println(sql);
		 log.info("SYSCODE初始化开始.....");
		// 查询数据
		List<Map<String, Object>> listMap = ud.query_list(sql);
		// 获取字段名
		List<ColumnInfoBean> listColum = ud.page_columns.getColumn_ls();
		
	// 开始拼接json 数据
			String jsonStr = "";
			String v_code="";
				int a = 0;
				int b=0;
	for (Map<String, Object> m : listMap) {
				String code=(String)m.get("code");
			
				
				if(v_code.equals("")||v_code == "" || v_code.length() < 1){//初始化
					 jsonStr = "[";
					v_code=code;
					a=0;
					b=0;
				}
				if (!code.equals(v_code)){	//设置值
					jsonStr += "]";
					sys_code_map.put(v_code, jsonStr);//加到map队列
					 jsonStr = "[";
					 a=0;
					 b=0;
				}
				
				if (b==0){
					jsonStr += "{";
					b=1;
				}else
				{
					jsonStr += ",{";
				}
				a=0;
			for (ColumnInfoBean cl : listColum) {//数据拼装
						String dataStr = (String) m.get(cl.getName());
						if (dataStr == null || dataStr.equals("")) {
						} else {
							dataStr = dataStr.replaceAll("\"", "\\\\\"");
						}
						if (a == 0) {
							jsonStr += "\"" + cl.getName().toLowerCase() + "\":\"" + dataStr + "\"";
						} else {
							jsonStr += ",\"" + cl.getName().toLowerCase() + "\":\"" + dataStr + "\"";
						}
						a=1;
			}
			jsonStr += "}";
			v_code=code;		
			//log.info("SYSCODE:"+jsonStr);		
	}
	//加入最后一次
	 jsonStr += "]";
	sys_code_map.put(v_code, jsonStr);//加到map队列
		//------------------------------初始华输出
     for(Map.Entry<String, String> entry : sys_code_map.entrySet()) {
    	 log.info("SYSCODE:"+entry.getKey()+"---------------"+entry.getValue());
           // System.out.println(entry.getKey()+"\n");
           // System.out.println(entry.getValue()+"\n");
		}
      //end------------------------------初始华输出	
	}
	
  /*
   * 获取log4j日志路径配置
   * 
   */
	public static void initlogurl(){
		//Properties logProp=new PropertiesUtil().getlogProp();
		Properties prop = PropertiesUtil.getlogProp();
	     String  logPath=prop.getProperty("logPath");
	     System.setProperty("LOG_DIR", logPath);//设置log路径，以便log4j直接读取
	     System.out.println("logPath:"+logPath); 
	   }
	
	/**
	 * 获取urlMap
	 * @return
	 */
	public static Map<String,Object> getUrlMap(String urlKey,Object urlValue){
		if(urlsMap != null && !urlsMap.isEmpty()){
			return urlsMap;
		}
		urlsMap= new HashMap<String, Object>();
		//首次登录设置
		urlsMap.put(urlKey, urlValue);
		
		Enumeration e = res.getKeys();
		while(e.hasMoreElements()){
			String key = e.nextElement().toString();
			String value = get(key);
			urlsMap.put(key, urlValue+"/"+value); //urlValue为context path,所有路径都要 拼接上context path
			System.out.println(key+"---"+urlValue+"/"+value);
		}
		
		return urlsMap;
	}
	/**
	 * 获取urlMap
	 * @return
	 */
	public static Object getUrlMap(String urlKey){
		if(urlsMap != null && !urlsMap.isEmpty()){
			return urlsMap.get(urlKey);
		}
		return null;
	}
	
	
	public static String get(String key){
		return res.getString(key);
	}
	
	
	public static String getReqUri(String reqUrl){
		try {
			URL url  = new URL(reqUrl);
//			System.out.println("getAuthority = "+url.getAuthority());
//			System.out.println("getDefaultPort = "+url.getDefaultPort());
//			System.out.println("getFile = "+url.getFile());
//			System.out.println("getHost"+ " = "+url.getHost());
//			System.out.println("getPath"+ " = "+url.getPath());
//			System.out.println("getPort"+ " = "+url.getPort());
//			System.out.println("getProtocol"+ " = "+url.getProtocol());
//			System.out.println("getQuery"+ " = "+url.getQuery());
//			System.out.println("getRef"+ " = "+url.getRef());
//			System.out.println("getUserInfo"+ " = "+url.getUserInfo());
			return url.getPath();
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
		
	}
	
}
