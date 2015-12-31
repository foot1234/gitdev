package org.me.db.dao;
/*
* 获取数据库数据接口实现
 * author:duanjian
 * date:2013/03/12
 */


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;  
import java.util.regex.Pattern; 

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.Element;
import org.junit.Test;
import org.me.db.model.ColumnInfoBean;
import org.me.db.model.PageorColumns;
import org.me.db.util.DBUtil;
import org.me.db.util.XMLUtil;
import org.me.db.view.jsonFactory;

import com.me.utils.SessionUtils;




public class DoDao implements IDoDao {
	public PageorColumns page_columns=new PageorColumns();
//	private  List<ColumnInfoBean> column_ls =null;
	private HttpServletRequest request=null;
	private HttpServletResponse response =null;
	private Map<String, String> outParameterMap =null;//函数或过程out型参数暂存
	private String sql_xml_path="";
	private String act_id="";
	private final static Logger log= Logger.getLogger(jsonFactory.class);

	public String getSql_xml_path() {
		return sql_xml_path;
	}
	public void setSql_xml_path(String sql_xml_path) {
		this.sql_xml_path = sql_xml_path;
	}
	public String getAct_id() {
		return act_id;
	}
	public void setAct_id(String act_id) {
		this.act_id = act_id;
	}
	public HttpServletResponse getResponse() {
		return response;
	}
	public void setResponse(HttpServletResponse response) {
		this.response = response;
	}
	public HttpServletRequest getRequest() {
		return request;
	}
	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}
	//获取参数	 并/置换sql参数值	
	private String get_subParam(String str_sql,Map<String,Object> map_Param,boolean force_type){
				String str="";
				boolean find_flag=true;
		    try {
						String[] 	subParam ={""};
						subParam = StringUtils.substringsBetween(str_sql, "#{", "}");
						//System.out.println("subParam.length:"+subParam.length);
							if(subParam != null &&subParam.length >0){
									 for(String key_sr:subParam){
										 String param_value=null;
										  if(key_sr.indexOf("/session/")>=0){//获取session值
											  try{
												  param_value= (String)SessionUtils.getAttr(request, key_sr);
											 }catch(Exception e) {}
										  }else{
												try {
														param_value = map_Param.get(key_sr).toString();//获取原始值
													} catch (Exception e1) {
														try {
															param_value = map_Param.get(key_sr.toUpperCase()).toString();//无法获取时,尝试大写
														} catch (Exception e) {
																try {
																	param_value = map_Param.get(key_sr.toLowerCase()).toString();//无法获取时,尝试小写
																} catch (Exception e2) {find_flag=false;}
														}
													}
										    }
												try {	
													if(find_flag==true){
														if(key_sr.equals("$JQGRID")||key_sr.equals("$JQORDERBY")){
															str=str_sql.replace("#{"+key_sr+"}",param_value); 
														}else{
														    str=str_sql.replace("#{"+key_sr+"}","'"+param_value+"'"); 
														}
													}else if(find_flag==false&&force_type==true){
														 str=str_sql;
													}
												} catch (Exception e1) {
												   if(force_type==true)
												   {  str=str_sql;
													   System.out.println("原sql中 "+key_sr+" 需要被置换,却没有被置换!");
													   System.out.println(str_sql);
												   }
												}
										     //System.out.println(key_sr+"="+param_value+";");
									 }//end loop
							   }else{
								   //无参数sql
								   str=str_sql;
							   }//end if
			   } catch (Exception e1) {
				  System.out.println("eeeeeeeeeeeeeeee:"); e1.printStackTrace();
				   str=str_sql;
				}	
		    return str;
	     }
	//获取总记录数
	  	private int get_totalRows(String sql) {
	  		Connection con = null;
	  		PreparedStatement ps = null;
	  		ResultSet rs = null;
	  		int totalRows=0;
	  		try {
	  	   con = DBUtil.getConnection();
	  		ps = con.prepareStatement("select count(1) from("+sql+") v1");
			rs = ps.executeQuery();
	  			//获取数据
	  			while(rs.next()) {
	  				totalRows=rs.getInt(1);
	  			}
	  		} catch (SQLException e) {
	  			e.printStackTrace();
	  		} finally {
	  			DBUtil.close(rs);
	  			DBUtil.close(ps);
	  			DBUtil.close(con);
	  		}
	  		return totalRows;
	  	} 
	   
	  
	
	
	//获取sql
		@SuppressWarnings("unchecked")
		public String get_sql(Map<String,Object> map_Param,String sql_xml_path, String act_id) throws Exception{
			//Document d= new XMLUtil().getInstance("xml/export_excl_sql.xml");
			Document d= new XMLUtil().getInstance(sql_xml_path);
			Element root=d.getRootElement();
			
			//查找属性中id="list"的sql
			String sql=null;
			List<Element> eles=null;
			List<Element> el_where=null;
			List<Element> where_name_l=null;
			String where_str="";
			String  order_by_str="";
			String  jqorder_by_str="";
			List<Element> order_by_l=null;
			List<Element> jqorder_by_l=null;
			
		 try {
			eles=root.selectNodes("/mapper/query/select[@id='"+act_id+"']");
			 
		} catch (Exception e2) {
			e2.printStackTrace();
			System.out.println("无法获取需要的sql");
		}	
	  for(Element e:eles){
		sql=e.getText();	//获取sql
		el_where=e.selectNodes("where");//获取where 条件
		order_by_l=e.selectNodes("orderby");//获取order by
		jqorder_by_l=e.selectNodes("jqorderby");//获取order by
	    //System.out.println("jqorder_by_l:"+jqorder_by_l);
	  }
	  //处理where 条件
	  for(Element e:el_where){
		  where_name_l= e.selectNodes("name");
			for (Element el:where_name_l){
					String type=el.attributeValue("type").toString();
					String wstr =get_subParam(el.getText().toString(),map_Param,false);//替换参数
					System.out.println("参数type: "+type+" wstr:"+wstr);
					if((wstr == null || wstr.length() < 1)&&type.equals("normal")){}
					else if ((wstr == null || wstr.length() < 1)&&type.equals("force")){
						System.out.println("参数: "+el.getText()+" 的 type==force  却没有值！");
						where_str=where_str+" and "+el.getText();
					}else{
						if (where_str == null || where_str.length() < 1){//第一次不需要加and 连接符
							where_str=where_str+" "+wstr;
						}else{
							where_str=where_str+" and "+wstr;
						}
				}
			}
		  } 
	  //System.out.println("where_str:="+where_str);	
	//处理order_by
	  for(Element e:order_by_l){
		  order_by_str= order_by_str+" "+e.getText();
		  } 
	//处理jqorder_by//用户自定义排序
	  for(Element e:jqorder_by_l){
		 // System.out.println("jqorder_by_l:="+e.getText().toString());	
		  jqorder_by_str= get_subParam(e.getText().toString(),map_Param,false);//替换参数;
		  } 
	 // System.out.println("order_by_str:="+order_by_str+" jqorder_by_str:"+jqorder_by_str);	
	   //获取参数	 并/置换sql参数值	
	    sql=get_subParam(sql,map_Param,true);//替换参数	
		if (where_str== null || where_str.length() <1){}
		else{
		      sql=sql.trim()+"  where"+where_str;
		 }
	      if(page_columns.getCurrentPage()>1){//翻页过程中不在计算数据数量
	    	  //System.out.println("一次！！！！！！getCurrentPage:"+page_columns.getCurrentPage());
	      }else
		      {
				//设置总记录数
				page_columns.setTotalRows(get_totalRows(sql));
				//System.out.println("setTotalRows:一次！！！！！！PageCount:"+page_columns.getCurrentPage());
		      }
		//设置总页数
		int  intPageCount  =  (page_columns.getTotalRows()+page_columns.getPageSize()-1)  /  page_columns.getPageSize();
		page_columns.setPageCount(intPageCount);
		//算出限定上下限的限定值（每页需要显示的数据区间）
		int limit_down=(page_columns.getCurrentPage()-1)*page_columns.getPageSize();
		int limit_up=page_columns.getCurrentPage()*page_columns.getPageSize();

		//System.out.println("getTotalRows:"+page_columns.getTotalRows());
		//System.out.println("PageCount:"+page_columns.getPageCount());
		//System.out.println("limit_down:"+limit_down+" limit_up:"+limit_up);
		 log.debug("getTotalRows:"+page_columns.getTotalRows());
		 log.debug("PageCount:"+page_columns.getPageCount());
		 log.debug("limit_down:"+limit_down+" limit_up:"+limit_up);
         log.debug(sql);
         
	   if (order_by_str== null || order_by_str.length() <1){
			  if (jqorder_by_str== null || jqorder_by_str.length() <1){}//拼接用户自定义排序
			  else{
			    sql=sql.trim()+"  order by "+jqorder_by_str;  
			  }  
	   }else{
		   if (jqorder_by_str== null || jqorder_by_str.length() <1){
			   sql=sql.trim()+"  order by "+order_by_str;
		     }else{
			    sql=sql.trim()+"  order by "+jqorder_by_str+","+order_by_str;  //拼接用户自定义排序
			  }  
		     
		 }
		//sql="select * from (select a.*, rownum rn from ("+sql+") a where rownum <= "+limit_up+") where rn > "+limit_down;
	   
		sql=" SELECT v.* FROM (SELECT a.*, @row_number:=IFNULL(@row_number,0)+1 rn FROM ("+sql+") a,(SELECT @row_number:=0) AS t) v WHERE v.rn <= "+limit_up+" AND v.rn>"+limit_down;
		
		//System.out.println(sql);	
			return sql;
		}
		
	 //获取要执行的function	
		@SuppressWarnings({ "unchecked", "null" })
		public String get_fun(Map<String,Object> map_Param,String sql_xml_path, String act_id) throws Exception{
			//Document d= new XMLUtil().getInstance("xml/export_excl_sql.xml");
			Document d= new XMLUtil().getInstance(sql_xml_path);
			Element root=d.getRootElement();
			//查找属性中id="list"的sql
			String sql=null;
			List<Element> eles=null;
			List<Element> parameter=null;
		 try {
			eles=root.selectNodes("/mapper/update/execute[@id='"+act_id+"']");
		} catch (Exception e2) {
			log.error("无法获取需要的function");
			log.error(e2.getMessage(), e2);
			//e2.printStackTrace();
			//System.out.println("无法获取需要的function");
		}
			
			for(Element e:eles){
						sql=e.getText();
						try {
							parameter=e.selectNodes("parameters/parameter");
						} catch (Exception e1) {}
			}	
			
/*-----------------------------------------------------------------------------------------*/
//			  if (!outParameterMap.isEmpty()){
//					outParameterMap=null;
//			  }
			String HttpSession="";
			if((parameter!=null)||(!parameter.isEmpty())){
				 outParameterMap=new  HashMap<String, String>();
				 HttpSession=(String)request.getSession(true).getId();
				 
				 log.debug("updateFunction:"+sql);	
				 
				 //sql=sql.substring(0,sql.lastIndexOf("end;"));//去掉end; 开始拼接out参数
				for (Element el:parameter){
							try {
								String type=el.attributeValue("type").toString().trim();
								if(type.equals("out")){
									//System.out.println("out:"+el.getTextTrim());
									String[] strarray=el.getTextTrim().split(":="); 
									String key="",value="";
								      for (int i = 0; i < strarray.length; i++){ 
								          if(i==0){
								        	  key=StringUtils.substringsBetween(strarray[i], "#{", "}")[0];
								          }else{
								        	  value=strarray[i];
								          }
								      } 
								      outParameterMap.put(key, value);//暂存输出参数 
							          log.info("输出参数 key:"+key+" value:"+value);
//							          String ParSql=" insert into fun_out_parameter_tmp "+
//												"(http_session_id, sql_xml_path_action, parameter_code, parameter_value,index_s)"+
//												"values('"+HttpSession+"','"+sql_xml_path+"@"+act_id+"','"+key+"',"+value+",#{index_s}); ";
//									 sql+=ParSql;
							          
								}
						
							} catch (Exception e1) {
								log.error("解析out类型参数出错!");
								log.error(e1.getMessage(), e1);
								//System.out.println("解析out类型参数出错!");
								//e1.printStackTrace();
							}
						}
					//sql=sql+" end;";
			}
			try{
		   String index_s=	map_Param.get("index_s").toString();
		   outParameterMap.put("index_s", index_s);//暂存输出参数 (grid index索引)
		  }catch(Exception e){}
/*------------------------------------------------------------------------------------------------------*/			
			try {
				//获取参数	 并/置换sql参数值	
				String[] subParam= StringUtils.substringsBetween(sql, "#{", "}") ;				 	
				 for(String key_sr:subParam){
					 String sr_param=null;
					  if(key_sr.indexOf("/session/")>=0){//获取session值
						  try{
							 sr_param= (String)SessionUtils.getAttr(request, key_sr);
						 }catch(Exception e) {}
					  }else{
						 try {
							 sr_param = map_Param.get(key_sr).toString();//获取原始值
							} catch (Exception e1) {
								try {
									sr_param = map_Param.get(key_sr.toUpperCase()).toString();//无法获取时,尝试大写
								} catch (Exception e) {
									try {
										sr_param = map_Param.get(key_sr.toLowerCase()).toString();//无法获取时,尝试小写
									} catch (Exception e2) {
										  if(key_sr.equals("index_s")){//grid index
											   sr_param="";
											 }else{
										       log.error("参数置换错误", e2);
											 }
										//e2.printStackTrace();
									}
								}
							}
					  }
					  
					  if(sr_param==null||sr_param.length()<1){
					    sr_param="null";
					    sql=sql.replace("#{"+key_sr+"}",""+sr_param+""); 
					  }else{
				         sql=sql.replace("#{"+key_sr+"}","'"+sr_param+"'"); 
					  }
				     System.out.println(key_sr+"="+sr_param+";");
				 }
			} catch (Exception e1) {
				log.error(e1.getMessage(), e1);
				e1.printStackTrace();
			}	 
			
			log.info("需要执行的sql:"+sql);	
			return sql;
		}		
		
		
	@Override
	public List<Map<String, Object>> query_list(String sql) {
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<Map<String, Object>>  listMap=new ArrayList< Map<String, Object>>(); 		
		try {
			con = DBUtil.getConnection();
			//获取数据
			ps = con.prepareStatement(sql);
			rs = ps.executeQuery();
			List<ColumnInfoBean> listColum = getColumnInfoes(rs);
			
			//获取数据
			while(rs.next()) {
				Map<String, Object> map=new HashMap<String, Object>();
				for (ColumnInfoBean cl:listColum){
					map.put(cl.getName(), rs.getString(cl.getName()));
					//System.out.println(".................................cl.getName()="+cl.getName()+",rs.getString(cl.getName())="+rs.getString(cl.getName()));
				}
				listMap.add(map);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.close(rs);
			DBUtil.close(ps);
			DBUtil.close(con);
		}
		return listMap;
	}
	

	
	//获取json 格式数据
@Override
	public String query_list2json(String sql) throws Exception{
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		//String jsonStr="{\"record\":[";
		String jsonStr="";
		String err_msg="";
		//List<Map<String, Object>>  listMap=new ArrayList< Map<String, Object>>(); 		
		try {
			con = DBUtil.getConnection();
			
//		ps = con.prepareStatement("select * from("+sql+") where 1=0");
//			rs = ps.executeQuery();
		//获取字段名
//	   List<ColumnInfoBean> listColum = getColumnInfoes(rs);
			//获取数据
			ps = con.prepareStatement(sql);
			rs = ps.executeQuery();
		    List<ColumnInfoBean> listColum = getColumnInfoes(rs);
			
			//开始拼接json 数据
			int a=0;
			int b=0;
			//获取数据
			while(rs.next()) {
				//Map<String, Object> map=new HashMap<String, Object>();
				if(b==0)
				{
					jsonStr+="{";
					b=1;  
				}
				else
				{ 
					jsonStr+=",{";
				}
				
				a=0;
					for (ColumnInfoBean cl:listColum){
						String values=null;
						try{
						    values=rs.getString(cl.getName().trim());
						}catch(Exception e){
							try{
								  values=rs.getString(cl.getName().trim().toLowerCase());//尝试小写
							 }catch(Exception e1){
						          values=rs.getString(cl.getName().trim().toUpperCase());//尝试大写
							}
						}
						
						if (values == null || values.length() < 1)
						{
							values="";
						}else
						{
							values=values.replaceAll("\"","\\\\\"");
							 Pattern CRLF = Pattern.compile("(\r\n|\r|\n|\n\r)");  //替换回车
						        Matcher m = CRLF.matcher(values);  
						    if (m.find()) {  
						    	values = m.replaceAll("<br>");  
						        }  

						}
						
						if(a==0){
						    jsonStr+="\""+cl.getName().toLowerCase()+"\":\""+values+"\"";
						}else
						{
						   jsonStr+=",\""+cl.getName().toLowerCase()+"\":\""+values+"\"";
						}
					a++;
				}
					jsonStr+="}";
			}
			
		} catch (SQLException e) {
			//System.out.println("qqqqqqqqqqqqqqqqqq1"+e.getMessage());
			err_msg=e.getMessage();
			log.error(err_msg, e);
			//jsonStr="{\"msg\":\""+ e.getMessage()+"\"}";
			//new BaseAction().sendOraMessage(response, jsonStr);//抛错到前台
			//e.printStackTrace();
		} catch (Exception e) {
			//System.out.println("qqqqqqqqqqqqqqqqqq2"+e.getMessage());
			err_msg=e.getMessage();
			log.error(err_msg, e);
			//new BaseAction().sendOraMessage(response, jsonStr);//抛错到前台
			//e.printStackTrace();
		}finally {
			DBUtil.close(rs);
			DBUtil.close(ps);
			DBUtil.close(con);
		}
		if(err_msg.length()>0){//有异常则抛出到前台
			throw new Exception(err_msg);
		}
		//jsonStr+="]";
		//System.out.println(jsonStr);
		
	return 	jsonStr;
	} 
 
	  
	// 取得某表下的所有字段信息
	  public List<ColumnInfoBean> getColumnInfoes(ResultSet rs){
		  List<ColumnInfoBean>  column_ls = new ArrayList<ColumnInfoBean>();
	    try {
	 	  // Get result set meta data
	      ResultSetMetaData rsmd = rs.getMetaData();
	      int numColumns = rsmd.getColumnCount();
	      // Get the column names; column indices start from 1
	      for (int i = 1; i < numColumns + 1; i++) {
	        ColumnInfoBean columnInfoBean = new ColumnInfoBean();
	        // 字段名
	        columnInfoBean.setName(rsmd.getColumnName(i));
	        // 字段类型
	        columnInfoBean.setTypeName(rsmd.getColumnTypeName(i));
	        // 字段类型对应的java类名
	        columnInfoBean.setClassName(rsmd.getColumnClassName(i));
	        // 显示的长度
	        columnInfoBean.setDisplaySize(rsmd
	            .getColumnDisplaySize(i));
	        // Precision
	        columnInfoBean.setPrecision(rsmd.getPrecision(i));
	        // Scale
	        columnInfoBean.setScale(String.valueOf(rsmd.getScale(i)));
	        column_ls.add(columnInfoBean);
	      }
	    } catch (SQLException e) {
	      e.printStackTrace();
	    }
	    //设置字段名
	    page_columns.setColumn_ls(column_ls);
	    return column_ls;
	  }

	  @Override
		public int update(String sql) {
			Connection con = null;
			PreparedStatement ps = null;
			Statement stmt;
			ResultSet rs = null;
			try {
				con = DBUtil.getConnection();
				ps = con.prepareStatement(sql);
//				ps = con.prepareStatement(sql);
				ps.executeUpdate();
//				stmt = (Statement) con.createStatement();
//	            boolean hasResultSet = stmt.execute(sql);	
//				
			} catch (SQLException e) {
				e.printStackTrace();
				return -1;
			} finally {
				DBUtil.close(rs);
				DBUtil.close(ps);
				DBUtil.close(con);
			}
			return 0;
		} 
	  
	  public String execute( String fun_sql) throws Exception {
			Connection con = null;
			PreparedStatement ps = null;
			Statement stmt;
			ResultSet rs = null;
			String ReturnjsonStr="";
			boolean status=true;
			String msg="";
			try {
				String sql=fun_sql;
				
				con = DBUtil.getConnection();
//				ps = con.prepareStatement(sql);
//				ps.executeUpdate();
				stmt = (Statement) con.createStatement();
	            boolean hasResultSet = stmt.execute(sql);	
	          //int exe_has= stmt.executeUpdate(sql);	
	            System.out.println("outParameterMap.isEmpty():"+outParameterMap.isEmpty());
		         if (!outParameterMap.isEmpty()&&outParameterMap!=null){
		        	  sql="select  " ;
		        	  int count=0;
		        	 for (Map.Entry entry : outParameterMap.entrySet()) {
		        		    String key = entry.getKey().toString();
		        		    String value = entry.getValue().toString();
		        		    System.out.println("key=" + key + " value=" + value);
		        		    if(count==0){
		        		    	count+=1;
		        		    	sql+= value;
		        		    }else
		        		    {
		        		    	sql+= ","+value;
		        		    }
		        		  
		        		 }
		        	 sql+=" from dual";
//			           sql="select t.index_s,t.parameter_code, t.parameter_value from fun_out_parameter_tmp t where t.http_session_id ='"
//			                  +request.getSession(true).getId()+"' and t.sql_xml_path_action='"+sql_xml_path+"@"+act_id+"'";
					  log.info("输出参数sql:"+sql);
					  ps = con.prepareStatement(sql);
					  rs = ps.executeQuery();
					  int a=0;
					  int b=0;
					    List<ColumnInfoBean> listColum = getColumnInfoes(rs);
						//获取数据
						while(rs.next()) {
							if(b==0)
							{
								ReturnjsonStr+="{";
								b=1;  
							}
							else
							{ 
								ReturnjsonStr+=",{";
							}
							a=0;
							
							//获取输出值
							 for (Map.Entry entry : outParameterMap.entrySet()) {
				        		    String parm_key = entry.getKey().toString().trim();
				        		    String parm_value = entry.getValue().toString().trim();
				        		    String values=rs.getString(parm_value);
				        		  //查看是否有session 数据需要被更新
							     if(parm_key.indexOf("/session/")>=0){//设置session值
										SessionUtils.setAttr(request, parm_key, values);
								 }
									 
								if (values == null || values.length() < 1)
								{
									values="";
								}else
								{
									values=values.replaceAll("\"","\\\\\"");
									 Pattern CRLF = Pattern.compile("(\r\n|\r|\n|\n\r)");  //替换回车
								        Matcher m = CRLF.matcher(values);  
								    if (m.find()) {  
								    	values = m.replaceAll("<br>");  
								        }  

								}
								
								if(a==0){
									ReturnjsonStr+="\""+parm_key+"\":\""+values+"\"";
								}else
								{
									ReturnjsonStr+=",\""+parm_key+"\":\""+values+"\"";
								}
							a++;
						}
							ReturnjsonStr+="}";
					}
/*-------------------------------------------------------------------------------------*/		  
		         }
//		         //清除临时表
//		        sql="begin delete from fun_out_parameter_tmp t where t.http_session_id ='"
//		                  +request.getSession(true).getId()+"' and t.sql_xml_path_action='"+sql_xml_path+"@"+act_id+"';   end;";
//		         stmt.execute(sql);	
		         status=true;   
		         msg="";
			} catch (SQLException e) {
				System.out.println("getMessage"+e.getMessage());
				System.out.println("getLocalizedMessage"+e.getLocalizedMessage());
				System.out.println("getErrorCode"+e.getErrorCode());
				//e.printStackTrace();
			    status=false;
			    msg=e.getMessage();
			}catch (Exception e) {
				e.printStackTrace();
				System.out.println("getMessage"+e.getMessage());
				//System.out.println("getLocalizedMessage"+e.getLocalizedMessage());
				//System.out.println("getErrorCode"+e.getErrorCode());
				//e.printStackTrace();
			    status=false;
			    msg=e.getMessage();
			} finally {
				DBUtil.close(rs);
				DBUtil.close(ps);
				DBUtil.close(con);
			}
			
			if(!status){//有异常则抛出到前台
				throw new Exception(msg);
			}
			
			
			ReturnjsonStr="{\"success\":"+status+",\"msg\":\""+msg+"\",\"rows\":["+ReturnjsonStr+"]}";
			return ReturnjsonStr;
		}

	  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	 @Test 
		public void update1() {
			Connection con = null;
			PreparedStatement ps = null;
			Statement stmt;
			ResultSet rs = null;
			try {
				String sql="begin test_insert_pkg.insert_test(p_user_id =>111, p_type =>'test'); end;";
				con = DBUtil.getConnection();
//				ps = con.prepareStatement(sql);
//				ps.executeUpdate();
				stmt = (Statement) con.createStatement();
	            boolean hasResultSet = stmt.execute(sql);	
				System.out.println(hasResultSet);
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				DBUtil.close(rs);
				DBUtil.close(ps);
				DBUtil.close(con);
			}
		}




	
}
