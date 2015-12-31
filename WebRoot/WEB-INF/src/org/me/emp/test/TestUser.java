package org.me.emp.test;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

//import net.sf.json.JSONObject;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.junit.Test;
import org.me.db.dao.DoDao;
import org.me.db.model.ColumnInfoBean;
import org.me.db.util.PropertiesUtil;
import org.me.db.util.XMLUtil;
import org.me.db.view.jsonFactory;

public class TestUser {
	private static DoDao ud = new DoDao();

	 public static void main(String[] args) {
	 //testAdd();
	 // testUpdate();
	 //testList();
	 //update();
		//int a= "/session/address".indexOf("/session/");
		//System.out.println(a);
		 
		 System.out.println(11);
		String  Message=	new jsonFactory().getOraErrMsg("38745");
		System.out.println("Message:"+Message);
	 }

	public static void testSingleton() {
		Document d1 = XMLUtil.getUserDocument();
		Document d2 = XMLUtil.getUserDocument();
		System.out.println(d1 == d2);
	}

	@Test
	public void update() throws Exception {
		Map<String, Object> map_Param = new HashMap<String, Object>();
		map_Param.put("id", "1");
		// map_Param.put("type", "0");
		// 设置参数，获取拼接好的sql
		String sql = ud.get_sql(map_Param, "xml/sys_user_sql.xml", "update");// "select * from t_user";
		// System.out.println(sql);
		// 更新数据
		int a = ud.update(sql);
		System.out.println(a);

	}

	@Test
	public void testList() throws Exception {
		Map<String, Object> map_Param = new HashMap<String, Object>();
		map_Param.put("id", "20");
		// map_Param.put("type", "0");
		// 设置参数，获取拼接好的sql
		String sql = ud.get_sql(map_Param, "xml/sys_user_sql.xml", "load");// "select * from t_user";
		System.out.println(sql);
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

	@Test
	public void testListmap() throws Exception {
		Map<String, Object> map_Param = new HashMap<String, Object>();
		
		
		//Map<String, Object> data_map_detail = new HashMap<String, Object>();
		Map<String, Map<String, Object>> data_map = new HashMap<String, Map<String, Object>>();
		//map_Param.put("id", "20");
		// map_Param.put("type", "0");
		// 设置参数，获取拼接好的sql
		ud.page_columns.setCurrentPage(1); //默认第一页
		ud.page_columns.setPageSize(100000);//每页显示100000条记录
		String sql = ud.get_sql(map_Param, "xml/sys/sys_service.xml", "load");// "select * from t_user";
		System.out.println(sql);
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
//			String data = "";
//			data += m.get("SERVICE_NAME");
//			System.out.println(data);
			String service_name=(String)m.get("SERVICE_NAME");
			data_map.put(service_name, m);
		}
	
Map<String, Object> ms=data_map.get("modules/sys/SYS1110/sys_parameter.screen");
  Object oo=  ms.get("TITLE");
	System.out.println("oo"+oo);	
		
	}
	
	// 拼接jqgrid 自带的查询参数
	private String jq_query_parm(HttpServletRequest request) {
		System.out.print("rows:" + request.getParameter("rows"));
		System.out.print("page:" + request.getParameter("page"));
		String searchfield = request.getParameter("searchField"); // 条件查询的字段。
		String searchoper = request.getParameter("searchOper"); // 条件查询的方式是等于还是其他的。
		String where_str = "";
		String case_w = " ";
		String search_content = " ";
		try {
			String searchstring = new String(request.getParameter(
					"searchString").getBytes("ISO-8859-1"), "utf-8");
			// String searchstring = request.getParameter("searchString");
			System.out.print("searchfield: " + searchfield + " searchoper: "
					+ searchoper + " searchstring:" + searchstring);

			if (searchfield == null || searchfield.length() < 1) {
			} else {
				String data_type = "";
				List<ColumnInfoBean> column_ls = ud.page_columns.getColumn_ls();
				for (ColumnInfoBean cl : column_ls) {
					if (cl.getName().equals(searchfield)) {
						data_type = cl.getTypeName();// 获取数据库类型
						break;
					}
				}
				if (searchoper.equals("eq"))// 等于
				{ // System.out.println("searchstring:"+searchstring+" "+searchstring.indexOf("%"));
					if (searchstring == null || searchstring.length() < 1) {
					} else if (searchstring.indexOf("%") != -1) {// 包含 %用like
						case_w = " like ";
					} else {
						case_w = "=";
					}
				} else if (searchoper.equals("ne")) {// 不等于
					if (searchstring == null || searchstring.length() < 1) {
					} else if (searchstring.indexOf("%") != -1) {// 包含 %用like
						case_w = " not like ";
					} else {
						case_w = "<>";
					}
				} else if (searchoper.equals("lt")) {// 小于
					case_w = "<";
				} else if (searchoper.equals("le")) {// 小于等于
					case_w = "<=";
				} else if (searchoper.equals("gt")) {// 大于
					case_w = ">";
				} else if (searchoper.equals("ge")) {// 大于等于
					case_w = ">=";
				} else if (searchoper.equals("nu")) {// 空
					case_w = " is null";
				} else if (searchoper.equals("nn")) {// 非空
					case_w = " is not null";
				} else if (searchoper.equals("in")) {//
					case_w = " like ";
				} else if (searchoper.equals("bn")) {//
					case_w = " not like ";
				} else {
					case_w = "";
				}

				if (data_type.equals("DATE")) {// 处理date型数据
					search_content = "to_date('" + searchstring
							+ "','yyyy-mm-dd hh24:mi:ss')";
				} else {
					search_content = "'" + searchstring + "'";
				}
				if (searchoper.equals("nu") || searchoper.equals("nn")) {// 空和非空的处理
					where_str = where_str + searchfield + case_w;
				} else if (searchstring == null || searchstring.length() < 1) {// 如果条件内容为空，忽略查询条件
					where_str = "";
				} else {
					where_str = where_str + searchfield + case_w
							+ search_content;
				}
			}
			if (case_w == null || case_w.length() < 1) {// 条件为空，忽略当前条件
				where_str = "";
			}
		} catch (Exception e) {
			// e.printStackTrace();
		} // 条件查询的值。

		return where_str;
	}

	// 拼接jqorderby 用户排序参数
	private String jq_orderby_parm(HttpServletRequest request) {
		System.out.print("sidx:" + request.getParameter("sidx"));
		System.out.print("sord:" + request.getParameter("sord"));
		String orderby = request.getParameter("sidx");
		String asc_desc = request.getParameter("sord");
		if (orderby == null || orderby.length() < 1) {
		} else {
			orderby = orderby + " " + asc_desc;
		}
		return orderby;
	}

	@Test
	public void List2json_jqgrid() throws Exception {
		Map<String, Object> map_Param=null;
		HttpServletRequest request=null;
		String sql_xml_path="xml/wfl_type_workflow_sql.xml";
		String act_id="listtype";
		// 设置页数和每页显示记录
		try {
			int CurrentPage = Integer.parseInt(request.getParameter("page")); // 默认第一页
			int PageSize = Integer.parseInt(request.getParameter("rows"));// 每页显示10条记录
			ud.page_columns.setCurrentPage(CurrentPage); // 默认第一页
			ud.page_columns.setPageSize(PageSize);// 每页显示10条记录

			String jq_parm = jq_query_parm(request);// 拼接来自grid 上自带查询条件
			if (jq_parm == null || jq_parm.length() < 1) {
			} else {
				map_Param.put("$JQGRID", jq_parm);
			}
			String jq_orderby_parm = jq_orderby_parm(request);// 拼接来自grid
																// 上用户排序参数
			if (jq_orderby_parm == null || jq_orderby_parm.length() < 1) {
			} else {
				map_Param.put("$JQORDERBY", jq_orderby_parm);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("SQL:");
		// 设置参数，获取拼接好的sql
		String sql = ud.get_sql(map_Param, sql_xml_path, act_id);// "select * from t_user";

		// 查询数据
		String jsonStr = "";
		try {
			jsonStr = ud.query_list2json(sql);
			int pageCount = ud.page_columns.getPageCount();
			int currentPage = ud.page_columns.getCurrentPage();
			int totalRows = ud.page_columns.getTotalRows();
			// jsonStr="{ \"pageCount\": \""+pageCount+"\",   \"currentPage\": \""+currentPage+"\",  \"totalRows\": \""+totalRows+"\",    \"data\" : ["+jsonStr+" ]} ";
			jsonStr = "{ \"total\": \"" + pageCount + "\",   \"page\": \""
					+ currentPage + "\",  \"records\": \"" + totalRows
					+ "\",    \"rows\" : [" + jsonStr + " ]} ";
			System.out.println(jsonStr);
		} catch (Exception e) {
			System.out.println("查询失败!");
			e.printStackTrace();
		}

	}

	@Test
	public void testList2json() throws Exception {
		Map<String, Object> map_Param = new HashMap<String, Object>();
		String sql_xml_path = "xml/sys_user_sql.xml";
		// map_Param.put("user_id", "1");
		// map_Param.put("user_name", "ADMIN");
		map_Param.put("start_date", "2000-01-01");
		// 设置页数和每页显示记录
		ud.page_columns.setCurrentPage(4); // 默认第一页
		ud.page_columns.setPageSize(10);// 每页显示10条记录

		// 设置参数，获取拼接好的sql
		String sql = ud.get_sql(map_Param, sql_xml_path, "load");// "select * from t_user";
		// 查询数据
		List<Map<String, Object>> listMap = ud.query_list(sql);
		// 获取字段名
		List<ColumnInfoBean> listColum = ud.page_columns.getColumn_ls();
		String Column = "";
		for (ColumnInfoBean cl : listColum) {
			Column += cl.getName() + ",";
		}
		System.out.println(Column);
		// 开始拼接json 数据
		String jsonStr = "{\"record\":[{";
		int a = 0;
		for (Map<String, Object> m : listMap) {
			String data = "";
			for (ColumnInfoBean cl : listColum) {
				data += m.get(cl.getName()) + ",";
				String dataStr = (String) m.get(cl.getName());
				if (dataStr == null || dataStr.equals("")) {
				} else {
					dataStr = dataStr.replaceAll("\"", "\\\\\"");
				}
				if (a == 0) {
					jsonStr += "\"" + cl.getName() + "\":\"" + dataStr + "\"";
				} else {
					jsonStr += ",\"" + cl.getName() + "\":\"" + dataStr + "\"";
				}
				a++;
			}
			System.out.println(data);
		}
		jsonStr += "}]}";
		System.out.println(jsonStr);
	}

	@Test
	public void List2json() throws Exception {
		Map<String, Object> map_Param = new HashMap<String, Object>();
		String sql_xml_path = "xml/sys_user_sql.xml";
		// map_Param.put("user_id", "20");
		map_Param.put("user_name", "ADMIN");
		map_Param.put("start_date", "2000-01-01");
		// 设置页数和每页显示记录
		ud.page_columns.setCurrentPage(1); // 默认第一页
		ud.page_columns.setPageSize(10);// 每页显示10条记录
		// 设置参数，获取拼接好的sql
		String sql = ud.get_sql(map_Param, sql_xml_path, "load");// "select * from t_user";
		// 查询数据
		String jsonStr = ud.query_list2json(sql);
		System.out.println(jsonStr);

	}

	// json 转换为map
	/*public Map<String, Object> getMapFromJson(String jsonString) {
		JSONObject jsonObject = JSONObject.fromObject(jsonString);
		System.out.println("oooo");
		Map<String, Object> map = new HashMap<String, Object>();
		for (Iterator<?> iter = jsonObject.keys(); iter.hasNext();) {
			String key = (String) iter.next();
			map.put(key, jsonObject.get(key));
		}
		return map;
	}*/

	@Test
	public void Get_Reimbursement_Expenses_Info() {
		String sysSource = null;
		try {
			Properties prop = PropertiesUtil.getParameterProp();
			sysSource = prop.getProperty("sysSource");
			// 1、先获取对应实例id工作流类型下单据的头id
			String sql_xml_path = "xml/by_wfl_type_get_document_id_sql.xml";
			Map<String, Object> map_Param = new HashMap<String, Object>();
			map_Param.put("workflow_type_code", "HEC_EXP_RPT_AUDIT");
			map_Param.put("instance_id", 1188);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@Test
	public void List2jsonTest() throws Exception {
		// Map<String,Object> map_Param =new HashMap<String, Object>();
		Map<String, Object> map_Param = new HashMap<String, Object>();
		String sql_xml_path = "xml/get_wfl_recipient_sql.xml";
		map_Param.put("group_employee_code", "01181499");
		// 设置参数，获取拼接好的sql
		String sql = ud.get_sql(map_Param, sql_xml_path, "load");// "select * from t_user";
		// 查询数据
		String jsonStr = ud.query_list2json(sql);
		// 获取字段名
		// List<ColumnInfoBean> listColum=ud.getColumnInfoes();
		System.out.println(jsonStr);

	}

	@Test
	public void testList2json_test() throws Exception {
		Map<String, Object> map_Param = new HashMap<String, Object>();
		String sql_xml_path = "xml/get_wfl_recipient_sql.xml";
		map_Param.put("group_employee_code", "01181499");
		// map_Param.put("type", "0");
		// 设置参数，获取拼接好的sql
		String sql = ud.get_sql(map_Param, sql_xml_path, "load");// "select * from t_user";
		// 查询数据
		List<Map<String, Object>> listMap = ud.query_list(sql);
		// 获取字段名
		List<ColumnInfoBean> listColum = ud.page_columns.getColumn_ls();
		String Column = "";
		for (ColumnInfoBean cl : listColum) {
			Column += cl.getName() + ",";
		}
		System.out.println(Column);
		// 开始拼接json 数据
		String jsonStr = "{\"record\":[{";
		int a = 0;
		for (Map<String, Object> m : listMap) {
			// String data="";
			for (ColumnInfoBean cl : listColum) {
				// data+= m.get(cl.getName())+",";
				if (a == 0) {
					jsonStr += "\""
							+ cl.getName()
							+ "\":\""
							+ m.get(cl.getName()).toString()
									.replaceAll("\"", "\\\\\"") + "\"";
				} else {
					jsonStr += ",\""
							+ cl.getName()
							+ "\":\""
							+ m.get(cl.getName()).toString()
									.replaceAll("\"", "\\\\\"") + "\"";
				}
				a++;
			}
			// System.out.println(data);
		}
		jsonStr += "}]}";
		System.out.println(jsonStr);

	}

	@Test
	public void getUserDocument() {
		Document d;
		// 如果不存在就创建对象
		try {
			SAXReader reader = new SAXReader();
			d = reader.read(TestUser.class.getClassLoader()
					.getResourceAsStream("aurora.database/datasource.config"));
			// URL url=
			// TestUser.class.getClassLoader().getResource("aurora.database/datasource.config");
			System.out.println(d);
			// 获取根元素
			Element root = d.getRootElement();
			System.out.println("root:" + root.getName());
			// 获取root的所有子节点
			@SuppressWarnings("unchecked")
			List<Element> eles = root.selectNodes("//dc:database-connection");
			for (Element e : eles) {
				System.out.println(e.attributeValue("driverClass"));
				System.out.println(e.attributeValue("url"));
				System.out.println(e.attributeValue("userName"));
				System.out.println(e.attributeValue("password"));
				System.out.println(e.elementText("properties"));

			}
		} catch (DocumentException e) {
			e.printStackTrace();
		}
	}
}
