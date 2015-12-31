package com.me.action;
/*
 *  author:duanjian
 * date:2013/05/10
 * 
 */
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.me.db.view.jsonFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.me.annotation.Auth;
import com.me.exception.ExceptionGlob;
import com.me.utils.SessionUtils;
import com.me.utils.SysServiceUrlUtils;
@Controller
public class MainAction extends BaseAction {

	
	private final static Logger log= Logger.getLogger(MainAction.class);
	
	
	/**
	 * 核心查询和更新入口
	 * @return
	 */
	@Auth(verifyLogin=true,verifyURL=false)
	@RequestMapping("/ToDoGo")
	protected void AjaxService(HttpServletRequest request, HttpServletResponse response) throws Exception {
				//		System.out.println("actionIdHH:"+request.getParameter("actionId"));
				//		System.out.println("dataSorceHH:"+request.getParameter("dataSorce"));
				//		System.out.print("rows:"+request.getParameter("rows"));
				//	    System.out.print("page:"+request.getParameter("page"));
				//	    System.out.print("sidx:"+request.getParameter("sidx"));
				//	    System.out.print("sord:"+request.getParameter("sord"));
		
		   request.setCharacterEncoding("UTF-8");
		   response.setCharacterEncoding("UTF-8");	
		
		//System.out.println("/session/encryted_session_id:"+SessionUtils.getAttr(request, "/session/encryted_session_id"));
		//System.out.println("/session/user_id:"+SessionUtils.getAttr(request, "/session/user_id"));
		//System.out.println("/session/session_id:"+SessionUtils.getAttr(request, "/session/session_id"));
		
		log.debug("/session/encryted_session_id:"+SessionUtils.getAttr(request, "/session/encryted_session_id"));
		log.debug("/session/user_id:"+SessionUtils.getAttr(request, "/session/user_id"));
		log.debug("/session/session_id:"+SessionUtils.getAttr(request, "/session/session_id"));
	 
		//System.out.print("searchString:"+request.getParameter("searchString"));
		//System.out.print("_para:"+request.getParameter("_para"));
		
		log.debug("searchString:"+request.getParameter("searchString"));
		log.debug("_para:"+request.getParameter("_para"));
		
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
			  //System.out.println("action:"+action +" actionId:"+actionId);
			 log.debug("action:"+action +" actionId:"+actionId);
		    if(dataSorce.indexOf(".xml?")!=-1){//说明xml有参数传来
				System.out.print("substring:"+dataSorce.substring(0,dataSorce.indexOf(".xml?")+4));
				sql_xml_path=dataSorce.substring(0,dataSorce.indexOf(".xml?")+4);
				sql_xml_para=dataSorce.substring(dataSorce.indexOf(".xml?")+5,dataSorce.length());
				//System.out.print("sql_xml_para:"+sql_xml_para);
				log.debug("sql_xml_para:"+sql_xml_para);
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
							   //System.out.print("a:"+a+" b:"+b);
						   }
					  }else{
						   String xml_para[] ={sql_xml_para};  
						   for(int i=0;i<xml_para.length;i++){
							   String a=xml_para[i].substring(0, xml_para[i].indexOf("="));
							   String b=xml_para[i].substring(xml_para[i].indexOf("=")+1, xml_para[i].length());
							   if (b== null || b.length() <1){}else{
								    map_Param.put(a, b);
								 }
							   //System.out.print("a:"+a+" b:"+b);
						   }
					  }
		       }
		} catch (Exception e) {
			//e.printStackTrace();
			log.error(e.getMessage());
		}
		//System.out.print("sql_xml_path:"+sql_xml_path);
		log.debug("sql_xml_path:"+sql_xml_path);
		//sql_xml_path="xml/wfl_type_workflow_sql.xml";
		//String sql_xml_path="xml/sys_user_sql.xml";
		//map_Param.put("user_id", "20");
		//map_Param.put("user_name", "ADMIN");
		//map_Param.put("start_date", "2000-01-01");
		//设置参数，获取拼接好的sql
		System.out.println("action="+action+",action_id="+actionId);
		
		if(action.toLowerCase().equals("query")||action.toLowerCase().equals("query/form")||action.toLowerCase().equals("query/combox")||action.toLowerCase().equals("query/tree")){
			// 查询数据  
		    String jsonStr =new jsonFactory().List2json(map_Param,request,sql_xml_path, actionId); 
		    //System.out.println(jsonStr);
	       if(action.toLowerCase().equals("query/form")){//不需要{[ ]}//easyui定制
		    	jsonStr=jsonStr.substring(jsonStr.indexOf(":[")+2, jsonStr.indexOf("]}"));
		    }else if(action.toLowerCase().equals("query/combox")){//easyui定制
		    	jsonStr=jsonStr.substring(jsonStr.indexOf(":[")+1, jsonStr.indexOf("]}")+1);
		    }else if(action.toLowerCase().equals("query/tree")){//easyui定制
		    	jsonStr=jsonStr.replaceAll("parentid", "_parentId");
		    }
	      // System.out.println(jsonStr);
	   	log.info("queryJsonStr:"+jsonStr);
	    response.getWriter().write(jsonStr); 
	    }else if(action.toLowerCase().equals("update")||action.toLowerCase().equals("update/batch"))
	    {  //执行或更新
	    	String v_return="";
	    	if(action.toLowerCase().equals("update")){//单一update入口
	         v_return= new jsonFactory().execute(map_Param,request,response,sql_xml_path, actionId);
	    	}else if(action.toLowerCase().equals("update/batch")){//批量update入口
	         v_return= new jsonFactory().executeBatch(map_Param,request,response,sql_xml_path, actionId);
	    	}
		    //System.out.println(v_return);
	    	log.info("update_return:"+v_return);
		    response.getWriter().write(v_return);
	    }else
	    {    log.error("query or update  error!");
	    	 response.getWriter().write("query or update  error!");
	    }
	}
	
	/**
	 * 初始化syscode获取,使用Spring rest 风格设置
	 * @return
	 */
	@Auth(verifyLogin=true,verifyURL=false)
	@RequestMapping(value="/SYSCODE/{code}")
	protected void GetSyscodevalues(@PathVariable String code,HttpServletRequest request, HttpServletResponse response){//使用 @PathVariable 注释可以将 {} 内的值注入到函数的参数。
		System.out.println("syscode--------------------------->"+code);
		try {
			 request.setCharacterEncoding("UTF-8");
			 response.setCharacterEncoding("UTF-8");	
			String codeValus= SysServiceUrlUtils.sys_code_map.get(code);
			System.out.println("codeValus--------------------------->"+codeValus);
			  response.getWriter().write(codeValus);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	/**
	 * 登录页面
	 * @param url
	 * @param classifyId
	 * @return
	 */
	@Auth(verifyLogin=false,verifyURL=false)
	@RequestMapping("/login")
	public ModelAndView  login(HttpServletRequest request,HttpServletResponse response) throws Exception{
		SessionUtils.removeUser(request);//清除浏览器session
		SessionUtils.setAttr(request, SessionUtils.SESSION_IP, getIpAddr(request));	//设置客户端ip地址到session中
		SessionUtils.removeValidateCode(request);//清除验证码，确保验证码只能用一次
       //获取ContextPath 进行设置，以便全局使用
		Map<String,Object>  context = getRootMap("msUrl",request.getContextPath());
		return forword("login", context);
	}
	
	
	/**
	 * 登录
	 * @param email 邮箱登录账号
	 * @param pwd 密码
	 * @param verifyCode 验证码
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@Auth(verifyLogin=false,verifyURL=false)
	@RequestMapping(value= "/toLogin",method=RequestMethod.POST )//只允许post 请求调用
	public void  toLogin(HttpServletRequest request,HttpServletResponse response) throws Exception{
		//System.out.println("actionIdHH:"+request.getParameter("verifyCode"));
//		System.out.println("dataSorceHH:"+request.getParameter("dataSorce"));
//		System.out.print("rows:"+request.getParameter("rows"));
//	    System.out.print("page:"+request.getParameter("page"));
//	    System.out.print("sidx:"+request.getParameter("sidx"));
//	    System.out.print("sord:"+request.getParameter("sord")); 
		String verifyCode=request.getParameter("verifyCode");
		String vcode  = SessionUtils.getValidateCode(request);
		SessionUtils.removeUser(request);//清除浏览器session
		SessionUtils.setAttr(request, SessionUtils.SESSION_IP, getIpAddr(request));	//设置客户端ip地址到session中
		SessionUtils.removeValidateCode(request);//清除验证码，确保验证码只能用一次
		System.out.println("SESSION_IP:"+SessionUtils.getAttr(request, SessionUtils.SESSION_IP));
	if(StringUtils.isBlank(verifyCode)){
		throw new Exception("验证码不能为空.");
			//sendFailureMessage(response, "验证码不能为空.");
			//return;
		}
		//判断验证码是否正确
		if(!verifyCode.toLowerCase().equals(vcode)){
			throw new Exception("验证码输入错误.");
		    //sendFailureMessage(response, "验证码输入错误.");
			//return;
		}
		
		//调用核心处理
		AjaxService( request,  response);
		//sendSuccessMessage(response, "登录成功.");
		return;
	}
	
	
	/**
	 * 退出登录
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@Auth(verifyLogin=false,verifyURL=false)
	@RequestMapping("/logout")
	public void  logout(HttpServletRequest request,HttpServletResponse response) throws Exception{
		System.out.println("系统退出。。。。。。。。。！！！");
		SessionUtils.removeUser(request);
		response.setStatus(response.SC_GATEWAY_TIMEOUT);//系统超时
		String baseUri = request.getContextPath();
		//response.sendRedirect(baseUri+"/uncheckPage.shtml?uri=login");
		response.sendRedirect(baseUri+"/login.shtml");
	}

	
	/**
	 * 页面不存在
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@Auth(verifyLogin=false,verifyURL=false)
	@RequestMapping("/pageNotFind")
	public ModelAndView  pageNotFind(HttpServletRequest request,HttpServletResponse response) throws Exception{
		System.out.println("页面不存在。。。。。。。。。！！！");
		//SessionUtils.removeUser(request);
		//response.setStatus(response.SC_GATEWAY_TIMEOUT);//系统超时
		//String baseUri = request.getContextPath();
		//response.sendRedirect(baseUri+"/uncheckPage.shtml?uri=login");
		//response.sendRedirect(baseUri+"/login.shtml");
		Map<String,Object>  context = getRootMap("msUrl",request.getContextPath());
		return forword("error", context);
	}


	/**
	 * 修改密码
	 * @param url
	 * @param classifyId
	 * @return
	 * @throws Exception 
	 */
	@Auth(verifyURL=false)
	@RequestMapping("/modifyPwd")
	public void modifyPwd(String oldPwd,String newPwd,HttpServletRequest request,HttpServletResponse response) throws Exception{
	}
	
	
	
	/**
	 * 所以页面的入口需要登录
	 * @param uri
	 * @return
	 * @throws Exception 
	 */
	@Auth(verifyLogin=true,verifyURL=false)
	@RequestMapping("/initPage") 
	public ModelAndView  initPage(String uri,HttpServletRequest request,HttpServletResponse response) throws Exception{
	  return page(uri,request,response);
	}
	
	
	@Auth(verifyLogin=true,verifyURL=false)
	@RequestMapping("/") 
	public ModelAndView  initPageq(String uri,HttpServletRequest request,HttpServletResponse response) throws Exception{
	  return page(uri,request,response);
	}
	/**
	 * 所以不需要登录页面入口
	 * @param uri
	 * @return
	 * @throws Exception 
	 */
	@Auth(verifyLogin=false,verifyURL=false)
	@RequestMapping("/uncheckPage") 
	public ModelAndView  uncheckPage(String uri,HttpServletRequest request,HttpServletResponse response) throws Exception{
		 return page(uri,request,response);
	}
	
}
