package org.me.db.view;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

//import net.sf.json.JSONObject;

import org.me.db.dao.DoDao;
import org.me.db.model.ColumnInfoBean;

import com.me.action.MainAction;

public class jsonFactory {
	private static DoDao ud = new DoDao();
	private final static Logger log= Logger.getLogger(jsonFactory.class);

	public static void main(String[] args) {
		try {
			testList();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
  //拼接jqgrid 自带的查询参数
	private String jq_query_parm(HttpServletRequest request) throws UnsupportedEncodingException{
	    System.out.print("rows:"+request.getParameter("rows"));
	    System.out.print("page:"+request.getParameter("page"));
	    String searchfield=request.getParameter("searchField");   //条件查询的字段。
	    String searchoper=request.getParameter("searchOper");    //条件查询的方式是等于还是其他的。
	    String where_str="";   
	    String case_w=" ";
	    String search_content=" ";
		try {
			//String searchstring =new String(request.getParameter("searchString").getBytes("ISO-8859-1"),"utf-8");
			String searchstring = request.getParameter("searchString");
			System.out.print("searchfield: "+searchfield+" searchoper: "+searchoper+" searchstring:"+searchstring);
		   
		        if (searchfield== null || searchfield.length() <1){}
		        else{
		        	String data_type="";
		        	List<ColumnInfoBean> column_ls=ud.page_columns.getColumn_ls();
		        	for(ColumnInfoBean cl:column_ls){
		        		if(cl.getName().equals(searchfield)){
		        			data_type=cl.getTypeName();//获取数据库类型
		        			break;
		        		}
		        	}
		        	if(searchoper.equals("eq"))//等于
		        	{  //System.out.println("searchstring:"+searchstring+" "+searchstring.indexOf("%"));
		        		if (searchstring== null || searchstring.length() <1){}
			           else if(searchstring.indexOf("%")!=-1){//包含 %用like
			        	   case_w=" like ";
		        		}else{
		        			case_w="=";
		        		}
		        	}else if (searchoper.equals("ne")){//不等于
		        		if (searchstring== null || searchstring.length() <1){}
				           else if(searchstring.indexOf("%")!=-1){//包含 %用like
				        	   case_w=" not like ";
			        		}else{
			        			case_w="<>";
			        		}
		        	}else if (searchoper.equals("lt")){//小于
		        		case_w="<";
		        	}else if (searchoper.equals("le")){//小于等于
		        		case_w="<=";
		        	}else if (searchoper.equals("gt")){//大于
		        		case_w=">";
		        	}else if (searchoper.equals("ge")){//大于等于
		        		case_w=">=";
		        	}else if (searchoper.equals("nu")){//空
		        		case_w=" is null";
		        	}else if (searchoper.equals("nn")){//非空
		        		case_w=" is not null";
		        	}else if (searchoper.equals("in")){//
		        		case_w=" like ";
		        	}else if (searchoper.equals("bn")){//
		        		case_w=" not like ";
		        	}else{
		        		case_w="";
		        	}
		        	
			        if (data_type.equals("DATE")){//处理date型数据
			        	search_content="to_date('"+searchstring+"','yyyy-mm-dd hh24:mi:ss')";
			        }else{
			        	search_content="'"+searchstring+"'";
			        }
			        if (searchoper.equals("nu")||searchoper.equals("nn")){//空和非空的处理
			         where_str= where_str+searchfield+case_w;
			        }else  if (searchstring== null || searchstring.length() <1){//如果条件内容为空，忽略查询条件
			         where_str="";
			        }else{
		        	where_str= where_str+searchfield+case_w +search_content;
			        }
		        }
		        if (case_w== null || case_w.length() <1){//条件为空，忽略当前条件
		        	where_str="";
		        }
		} catch (Exception e) {
			//e.printStackTrace();
		} //条件查询的值。
        
			return where_str;
	}
	  //拼接jqorderby  用户排序参数
		private String jq_orderby_parm(HttpServletRequest request){
		    String orderby= null;
			String asc_desc= null;
			try {
				  //easyUi 支持
					System.out.print("sortname:"+request.getParameter("sort"));
					System.out.print("sortorder:"+request.getParameter("order"));
					   orderby = request.getParameter("sort");
					    asc_desc = request.getParameter("order");
			} catch (Exception e) {
				//jqgrid 支持
				System.out.print("sidx:"+request.getParameter("sidx"));
				System.out.print("sord:"+request.getParameter("sord"));
				   orderby = request.getParameter("sidx");
				    asc_desc = request.getParameter("sord");
				    
			}   
			        if (orderby== null || orderby.length() <1){}
			        else{
			        	orderby=orderby+" "+asc_desc;
			        }
				return orderby;
		}	
	
	public String List2json(Map<String, Object> map_Param, HttpServletRequest request,String sql_xml_path,
			String act_id)  throws Exception  {
		//设置页数和每页显示记录
		int PageSize=100000;
		int CurrentPage=1;
		try {
				 CurrentPage=Integer.parseInt(request.getParameter("page")); //默认第一页
				 PageSize=Integer.parseInt(request.getParameter("rows"));//每页显示10条记录
			
				String jq_parm=	jq_query_parm(request);//拼接来自grid 上自带查询条件
				if (jq_parm== null || jq_parm.length() <1){}
				else{
					map_Param.put("$JQGRID",jq_parm);
				}
				String jq_orderby_parm=	jq_orderby_parm(request);//拼接来自grid 上用户排序参数
				if (jq_orderby_parm== null || jq_orderby_parm.length() <1){}
				else{
					map_Param.put("$JQORDERBY",jq_orderby_parm);
				}
				
		} catch (Exception e) {
			// log.error(e.getMessage(),e);
			//e.printStackTrace();
		}
		
		 Map<String,String[]> m=request.getParameterMap();//获取request 的map参数
		  String para_json="";
		  for (Object so : m.keySet()){ //获取所有参数
				       String[] ss=m.get(so);
				      // System.out.println("name:" + so + " value：" + ss[0]);  
				       log.debug("name:" + so + " value：" + ss[0]);
				       if(so.toString().equals("_para")){
				    	      para_json=ss[0];
				    	   //忽略json数据，由json解析函数处理
				       }else{
				       //添加参数
				           map_Param.put(so.toString(), ss[0]);  
				       }
				} 
		  
		ud.page_columns.setCurrentPage(CurrentPage); //默认第一页
		ud.page_columns.setPageSize(PageSize);//每页显示100000条记录
		///System.out.println("CurrentPage::::"+CurrentPage);
		//System.out.println("PageSize::::"+PageSize);
		 log.debug("CurrentPage::::"+CurrentPage);
		 log.debug("PageSize::::"+PageSize);
		 
		ud.setRequest(request);
		//ud.setResponse(response);
		ud.setSql_xml_path(sql_xml_path);
		ud.setAct_id(act_id);
		String sql ="";
		String jsonStr="";
		/////////////////////////////////////
		  if(para_json  == null||para_json.equals("")||para_json.length()<1){//非批量处理
			// 设置参数，获取拼接好的sql
				 sql = ud.get_sql(map_Param, sql_xml_path, act_id);// "select * from t_user";
		  }else{//批量处理
			  //String sJson = "[{'gwcxxid':'1','spsl':'2'},{'gwcxxid':'1','spsl':'2'},{'gwcxxid':'3','spsl':'4'}]";
				try {
					JSONArray jsonArray = new JSONArray(para_json);
				//	int iSize = jsonArray.length();
					int iSize =1;//默认第一条查询条件
					for (int i = 0; i < iSize; i++) {
						JSONObject jsonObj = jsonArray.getJSONObject(i);
						 //map_Param.clear();
						for (Iterator<?> iter = jsonObj.keys(); iter.hasNext();) {//迭代器应用
							String key = (String) iter.next();
							String b=jsonObj.get(key).toString();
							if (b== null || b.length() <1){}else{
							    map_Param.put(key, b);
							   }
							 log.debug("[" + i + "]="+"key:"+key +" value:" + jsonObj.get(key));
							//System.out.println("[" + i + "]="+"key:"+key +" value:" + jsonObj.get(key));
						}
						
						 sql= ud.get_sql(map_Param, sql_xml_path, act_id);//
						 
					}
				} catch (JSONException e) {
				
					jsonStr="解析_para 的json数据出错!";
					log.error(jsonStr);
					//System.out.println(jsonStr);
					log.error(e.getMessage(),e);
					//e.printStackTrace();
				}
		  }
		/////////////////////////////////////
		
		

		// 查询数据
			jsonStr = ud.query_list2json(sql);
			int pageCount 	=	ud.page_columns.getPageCount();
			int currentPage =	ud.page_columns.getCurrentPage();
			int totalRows	=	ud.page_columns.getTotalRows();
			//jsonStr="{ \"pageCount\": \""+pageCount+"\",   \"currentPage\": \""+currentPage+"\",  \"totalRows\": \""+totalRows+"\",    \"data\" : ["+jsonStr+" ]} ";
			//jsonStr="{ \"total\": \""+pageCount+"\", \"page\": \""+currentPage+"\", \"records\": \""+totalRows+"\", \"rows\": ["+jsonStr+" ]} ";
			//if (PageSize==100000){//则视为没有设置分页或为combox请求数据
			//	jsonStr="[ "+jsonStr+" ] ";
		//	}
			jsonStr="{\"total\": \""+totalRows+"\", \"page\": \""+currentPage+"\", \"rows\":["+jsonStr+"]}";
		return jsonStr;

	}

	// 获取总行数
	public int getTotalrows() {
		return ud.page_columns.getTotalRows();
	}

	//获取数据库错误信息
	public String getOraErrMsg(String msg_id) {
		// 设置参数，获取拼接好的sql
		String sql = "select s.message  from sys_raise_app_errors s where s.app_error_line_id ="+ msg_id;// "select * from t_user";
		// 查询数据
		List<Map<String, Object>> listMap = ud.query_list(sql);
		// 获取字段名
		List<ColumnInfoBean> listColum = ud.page_columns.getColumn_ls();

		// 开始拼接json 数据
		String Str ="";
		int a = 0;
		for (Map<String, Object> m : listMap) {
			for (ColumnInfoBean cl : listColum) {
					Str += m.get(cl.getName());
			}
		}
		return Str;
	}
	
	
	public String execute(Map<String, Object> map_Param,HttpServletRequest request, HttpServletResponse response,String sql_xml_path,
			String act_id) throws Exception {
	if(act_id==null|| act_id.length() <1){//如果动作参数为空，取jqgrid 动作参数
			 act_id=request.getParameter("oper");
			 System.out.println("nameoper0:" + request.getParameter("oper"));  	  
		}
		 //System.out.println("act_id:"+act_id+" nameoper1:" + request.getParameter("oper"));  	   
		// 设置参数，获取拼接好的sql
		ud.setRequest(request);
		ud.setResponse(response);
		ud.setSql_xml_path(sql_xml_path);
		ud.setAct_id(act_id);	
		
     Map<String,String[]> m=request.getParameterMap();//获取request 的map参数
     String para_json="";
     for (Object so : m.keySet()){ //获取所有参数
		       String[] ss=m.get(so);
		       if(so.toString().equals("_para")){
		    	      para_json=ss[0];
		    	   //忽略json数据，由json解析函数处理
		       }else{
		       //添加参数
		           map_Param.put(so.toString(), ss[0]);  
		       }
		} 
     
 	/////////////////////////////////////
     String fun_sql="";
     String jsonStr="";
	  if(para_json  == null||para_json.equals("")||para_json.length()<1){//非批量处理参数
		// 设置参数，获取拼接好的sql
		  fun_sql = ud.get_fun(map_Param, sql_xml_path, act_id);// "select * from t_user";
	  }else{//批量处理
		  //String sJson = "[{'gwcxxid':'1','spsl':'2'},{'gwcxxid':'1','spsl':'2'},{'gwcxxid':'3','spsl':'4'}]";
			try {
				JSONArray jsonArray = new JSONArray(para_json);
			//	int iSize = jsonArray.length();
				int iSize =1;//默认第一条查询条件
				System.out.println("Size:" + iSize);
				for (int i = 0; i < iSize; i++) {
					JSONObject jsonObj = jsonArray.getJSONObject(i);
					 //map_Param.clear();
					for (Iterator<?> iter = jsonObj.keys(); iter.hasNext();) {//迭代器应用
						String key = (String) iter.next();
						String b=jsonObj.get(key).toString();
						//if (b== null || b.length() <1){}else{
						    map_Param.put(key, b);
						//   }
						System.out.println("[" + i + "]="+"key:"+key +" value:" + jsonObj.get(key));
					}
					
					fun_sql= ud.get_fun(map_Param, sql_xml_path, act_id);//
					 
				}
			} catch (JSONException e) {
				jsonStr="解析_para 的json数据出错!";
				throw new Exception(jsonStr);	
			}
	  }
	/////////////////////////////////////
		//String fun_sql = ud.get_fun(map_Param, sql_xml_path, act_id);// "select * from t_user";
		 System.out.println("---------->fun_sql:"+fun_sql);
		// 执行sql
		 jsonStr = ud.execute(fun_sql);
		return jsonStr;
	}
	
	/*
	 * 批量执行sql程序
	 */
	public String executeBatch(Map<String, Object> map_Param,HttpServletRequest request, HttpServletResponse response,String sql_xml_path,
			String act_id) throws Exception {
		
		  if(act_id==null|| act_id.length() <1){//如果动作参数为空，取jqgrid 动作参数
				 act_id=request.getParameter("oper");
				 System.out.println("nameoper0:" + request.getParameter("oper"));  	  
			}
			// 设置参数，获取拼接好的sql
			ud.setRequest(request);
			ud.setResponse(response);
			ud.setSql_xml_path(sql_xml_path);
			ud.setAct_id(act_id);

		  Map<String,String[]> m=request.getParameterMap();//获取request 的map参数
		  String para_json="";
		  for (Object so : m.keySet()){ //获取所有参数
				       String[] ss=m.get(so);
				       System.out.println("name:" + so + " value：" + ss[0]);  
				       if(so.toString().equals("_para")){
				    	      para_json=ss[0];
				    	   //忽略json数据，由json解析函数处理
				       }else{
				       //添加参数
				           map_Param.put(so.toString(), ss[0]);  
				       }
				} 
		  String fun_sql="";
		  String jsonStr ="";
		  if(para_json  == null||para_json.equals("")||para_json.length()<1){//非批量处理
				 fun_sql = ud.get_fun(map_Param, sql_xml_path, act_id);// "select * from t_user";
				
		  }else{//批量处理
			  //String sJson = "[{'gwcxxid':'1','spsl':'2'},{'gwcxxid':'1','spsl':'2'},{'gwcxxid':'3','spsl':'4'}]";
				try {
					JSONArray jsonArray = new JSONArray(para_json);
					int iSize = jsonArray.length();
					System.out.println("Size:" + iSize);
					for (int i = 0; i < iSize; i++) {
						JSONObject jsonObj = jsonArray.getJSONObject(i);
						 map_Param.clear();
						for (Iterator<?> iter = jsonObj.keys(); iter.hasNext();) {//迭代器应用
							String key = (String) iter.next();
							map_Param.put(key, jsonObj.get(key).toString());
							System.out.println("[" + i + "]="+"key:"+key +" value:" + jsonObj.get(key));
						}
						   fun_sql = ud.get_fun(map_Param, sql_xml_path, act_id);
						   jsonStr += ud.execute(fun_sql);  
						   jsonStr+=",";
					}
				} catch (JSONException e) {
					jsonStr="解析_para 的json数据出错!";
					System.out.println(jsonStr);
					e.printStackTrace();
				}
		  }
			
			// 执行sql块
		 // System.out.println("fun_sql:"+fun_sql);
		  //fun_sql="begin "+fun_sql+" end;";:{"success":true,"msg":"","rows":[]}{"success":true,"msg":"","rows":[]}
		  jsonStr= jsonStr.substring(0,jsonStr.length()-1);//去除最后一个逗号
		  jsonStr="{\"success\":true,\"return\":"+"["+jsonStr+"]}";
	   return jsonStr;
	}
	// json 转换为map
	
	// json 转换为map
/*	public Map<String, Object> getMapFromJson(String jsonString) {
		System.out.println(jsonString);
		Map<String, Object> map = new HashMap<String, Object>();
		if (jsonString == null || jsonString.length() < 1) {
			return null;
		} else {
			JSONObject jsonObject = JSONObject.fromObject(jsonString);
			

			for (Iterator<?> iter = jsonObject.keys(); iter.hasNext();) {
				String key = (String) iter.next();
				//map.put(key, jsonObject.get(key));
				System.out.println("json_key:"+key+" value:"+jsonObject.get(key));
			}
			 System.out.println("ooooOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
			return map;
		}
	}*/

	public static void testList() throws Exception {
		Map<String, Object> map_Param = new HashMap<String, Object>();
		map_Param.put("id", "20");
		map_Param.put("type", "0");
		// 设置参数，获取拼接好的sql
		String sql = ud.get_sql(map_Param, "xml/sys_user_sql.xml", "load");// "select * from t_user";
		// 查询数据
		List<Map<String, Object>> listMap = ud.query_list(sql);
		// 获取字段名
		List<ColumnInfoBean> listColum = ud.page_columns.getColumn_ls();
		String Column = "";
		for (ColumnInfoBean cl : listColum) {
			Column += cl.getName() + ",";
		}
		System.out.println(Column);
		for (Map<String, Object> m : listMap) {
			String data = "";
			for (ColumnInfoBean cl : listColum) {
				data += m.get(cl.getName()) + ",";
			}
			System.out.println(data);
		}
	}

	public String List2json_old(Map<String, Object> map_Param,
			String sql_xml_path, String act_id) throws Exception {
		// 设置参数，获取拼接好的sql
		String sql = ud.get_sql(map_Param, sql_xml_path, act_id);// "select * from t_user";
		// 查询数据
		List<Map<String, Object>> listMap = ud.query_list(sql);
		// 获取字段名
		List<ColumnInfoBean> listColum = ud.page_columns.getColumn_ls();

		// 开始拼接json 数据
		String jsonStr = "{\"record\":[{";
		int a = 0;
		for (Map<String, Object> m : listMap) {
			// String data="";
			for (ColumnInfoBean cl : listColum) {
				// data+= m.get(cl.getName())+",";
				if (a == 0) {
					jsonStr += "\"" + cl.getName() + "\":\""
							+ m.get(cl.getName()) + "\"";
				} else {
					jsonStr += ",\"" + cl.getName() + "\":\""
							+ m.get(cl.getName()) + "\"";
				}
				a++;
			}
			// System.out.println(data);
		}
		jsonStr += "}]}";
		// System.out.println(jsonStr);
		return jsonStr;
	}

	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

}
