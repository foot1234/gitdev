package com.me.servlet;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.me.db.view.jsonFactory;

/**
 * Servlet implementation class AjaxService
 */
@WebServlet("/AjaxService")
public class AjaxService extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AjaxService() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Servlet#init(ServletConfig)
	 */
	public void init(ServletConfig config) throws ServletException {
		// TODO Auto-generated method stub
		
	}

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)
	 */
//	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		// TODO Auto-generated method stub
//		System.out.println("methodHHsss:"+request.getParameter("method"));
//	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		System.out.println("actionIdHH:"+request.getParameter("actionId"));
//		System.out.println("dataSorceHH:"+request.getParameter("dataSorce"));
//		System.out.print("rows:"+request.getParameter("rows"));
//	    System.out.print("page:"+request.getParameter("page"));
//	    System.out.print("sidx:"+request.getParameter("sidx"));
//	    System.out.print("sord:"+request.getParameter("sord"));
//	    
	    request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");	
	    
	    String sql_xml_path="";
	    String sql_xml_para="";
	    String dataSorce=request.getParameter("dataSorce");
	    String actionId=request.getParameter("actionId");
	    String action="";
	    Map<String,Object> map_Param	=new HashMap<String, Object>();	
		try {	
			  dataSorce=URLDecoder.decode(dataSorce,"ISO-8859-1");
			  dataSorce=new String(dataSorce.getBytes("ISO-8859-1"),"utf-8");
			  action=actionId.substring(0,actionId.indexOf("@")).trim(); //得到动作。查询query 执行update
			  actionId=actionId.substring(actionId.indexOf("@")+1,actionId.length()).trim();
			  System.out.println("action:"+action +" actionId:"+actionId);
		    if(dataSorce.indexOf(".xml?")!=-1){//说明xml有参数传来
				System.out.print("substring:"+dataSorce.substring(0,dataSorce.indexOf(".xml?")+4));
				sql_xml_path=dataSorce.substring(0,dataSorce.indexOf(".xml?")+4);
				sql_xml_para=dataSorce.substring(dataSorce.indexOf(".xml?")+5,dataSorce.length());
				System.out.print("sql_xml_para:"+sql_xml_para);
			}else{
				sql_xml_path=dataSorce;
			}
			 if (sql_xml_para== null || sql_xml_para.length() <1){}//条件为空，忽略当前条件
			 else{
					 if(sql_xml_para.indexOf("&")!=-1){//说明有多个参数
							String xml_para[] =sql_xml_para.split("&");
						   for(int i=0;i<xml_para.length;i++){
							   String a=xml_para[i].substring(0, xml_para[i].indexOf("="));
							   String b=xml_para[i].substring(xml_para[i].indexOf("=")+1, xml_para[i].length());
							   if (b== null || b.length() <1){}else{
							    map_Param.put(a, b);
							   }
							   System.out.print("a:"+a+" b:"+b);
						   }
					  }else{
						   String xml_para[] ={sql_xml_para};  
						   for(int i=0;i<xml_para.length;i++){
							   String a=xml_para[i].substring(0, xml_para[i].indexOf("="));
							   String b=xml_para[i].substring(xml_para[i].indexOf("=")+1, xml_para[i].length());
							   if (b== null || b.length() <1){}else{
								    map_Param.put(a, b);
								 }
							   System.out.print("a:"+a+" b:"+b);
						   }
					  }
		       }
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.print("sql_xml_path:"+sql_xml_path);
		//sql_xml_path="xml/wfl_type_workflow_sql.xml";
		//String sql_xml_path="xml/sys_user_sql.xml";
		//map_Param.put("user_id", "20");
		//map_Param.put("user_name", "ADMIN");
		//map_Param.put("start_date", "2000-01-01");
		//设置参数，获取拼接好的sql
		
		if(action.toLowerCase().equals("query")){
			// 查询数据  
		    String jsonStr = null;
			try {
				jsonStr = new jsonFactory().List2json(map_Param,request,sql_xml_path, actionId);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} 
	        response.getWriter().write(jsonStr);
	    }else if(action.toLowerCase().equals("update"))
	    {  //执行或更新
	        String v_return = null;
			try {
				v_return = new jsonFactory().execute(map_Param,request,response,sql_xml_path, actionId);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		    System.out.println(v_return);
		    response.getWriter().write(v_return);
	    }else
	    {
	    	 response.getWriter().write("query or update  error!");
	    }
	}

	/**
	 * @see HttpServlet#doHead(HttpServletRequest, HttpServletResponse)
	 */
	protected void doHead(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("doHead11111111111111111111111111111111");
	}

}
