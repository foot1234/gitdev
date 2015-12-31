package com.me.action;
/*
 * author:duanjian
 * date:2013/03/10
 * 
 */
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.servlet.ModelAndView;

import com.me.edit.MyEditor;
import com.me.utils.SessionUtils;
import com.me.utils.SysServiceUrlUtils;

public class BaseAction{
	
	public final static String SUCCESS ="success";  
	
	public final static String MSG ="msg";  
	
	
	public final static String DATA ="data";  
	
	public final static String LOGOUT_FLAG = "logoutFlag";  
	
	
   @InitBinder  
   protected void initBinder(WebDataBinder binder) {  
		 binder.registerCustomEditor(Date.class, new CustomDateEditor(
                new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"), true));  
		 binder.registerCustomEditor(int.class,new MyEditor()); 
   }  
	 
	 /**
	  * 获取IP地址
	  * @param request
	  * @return
	  */
	 public String getIpAddr(HttpServletRequest request) {
		String ip = request.getHeader("x-forwarded-for");
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}
		return ip;
	}
 
		protected ModelAndView page(String uri,HttpServletRequest request,HttpServletResponse response) throws Exception{
			//return forword("main/main",context); 
			System.out.println("uri:"+uri);
			//Map<String,Object>  context = getRootMap();
			String baseUri = request.getContextPath();
			//String function_code=request.getParameter("function_code");
			//System.out.println("function_code------------------------"+function_code);
	    int 	VerifyInt= 	PageServiceVerify( uri, request, response);
		    if (VerifyInt==-1){
		    	//throw new Exception("页面不存在!");
		    	//sendFailureMessage(response, "页面不存在!");
		    	response.sendRedirect(baseUri+"/pageNotFind.shtml");
				return null;
		    }else if(VerifyInt==1){
		    	//throw new Exception("登录已失效!");
		    	//sendFailureMessage(response, "登录已失效!");
		    	Map<String,Object>  context = getRootMap("msUrl",request.getContextPath());
				return forword("login_time_out", context);
		    }else if(VerifyInt==2){
		    	throw new Exception("没有权限访问!");
		    	//sendFailureMessage(response, "登录已失效!");
				//return null;
		    }else if(VerifyInt==0){//校验成功
				Map<String,Object>  context = getRootMap("msUrl",request.getContextPath());
				//String ss="[{\"id\":\"3\",\"pid\":\"null\",\"open\":\"false\",\"name\":\"公司级基础数据定义\",\"files\":\"null\",\"rn\":\"1\"}]";
				//context.put("json", ss);
				return forword(uri,context); 
				//return new ModelAndView(new RedirectView(uri),context);    //客户端跳转
				//return "redirect:"+uri;
		    }else
		    {return null;}
		}
	 
	 
	 /**
	  * 页面权限校验
	  *  -1 页面不存在；
	  *  1 登录失效
	  *  0 可以登录
	  */
	 public Integer PageServiceVerify(String uri,HttpServletRequest request,HttpServletResponse response){
		 try {
			 System.out.println("uri:"+uri);
				Map<String, Object> ms=SysServiceUrlUtils.sys_service_map.get(uri);
				 Object loginreq =  ms.get("is_login_required");
				 Object access_ck =  ms.get("is_access_checked");
				 Object service_id =  ms.get("service_id");
				 System.out.println("loginreq:::"+loginreq+"  access_ck::"+access_ck);
				  if(ms.isEmpty()){
					  //页面不存在
					  return -1;
				  }
				  if (loginreq.equals("1")){
					  //需要登录，检查登录
					  String encryted_session_id=(String)SessionUtils.getAttr(request, "/session/encryted_session_id");
						System.out.println("encryted_session_id:"+encryted_session_id);
						if(encryted_session_id  == null||encryted_session_id.equals("")){
							return 1;
						}else if(access_ck.equals("1")){
							int r_return=2;	
						try {
								//有权限控制
									Map<String, String> sys_function=SysServiceUrlUtils.sys_function_map.get(service_id);
									
									String role_id= SessionUtils.getAttr(request, SessionUtils.SESSION_ROLE_ID).toString();
									System.out.println("页面权限校验role_id:"+role_id);
									if(role_id.length()<1||role_id.equals("")){
										//未选择角色.直接权限不足
										return r_return;
									}
									 
					             for( Entry<String, String> entry : sys_function.entrySet()) {
										 System.out.println("页面权限校验:"+entry.getKey()+"----"+entry.getValue()+"\n");
										 String function_id=entry.getKey();
										 Map<String, String> function_role=SysServiceUrlUtils.role_function_map.get(function_id);		
										 for( Entry<String, String> entry1 : function_role.entrySet()) {
											 if(role_id.equals(entry1.getKey())){//权限校验通过
										    	   r_return=0;
										    	   break;
							                     }
										 }
									  if(r_return==0){
										  break; 
									  }
								  }
							    return r_return;
							} catch (Exception e) {
								return r_return;
							}
						}else
						{   
							return 0;
						}
					  
				  }else if (loginreq.equals("0")){
					  //不需要登录
					  return 0;
				  }
		} catch (Exception e) {
			e.printStackTrace();
		}
		 return -1;
	 }
	 
	 /**
	  * 所有ActionMap 统一从这里获取
	  * @return
	  */
	 public Map<String,Object> getRootMap(){
			//Map<String,Object> rootMap = new HashMap<String, Object>();
			//添加url到 Map中
			//rootMap.putAll(URLUtils.getUrlMap());
			return SysServiceUrlUtils.getUrlMap(null, null);
		}
	 //登陆设置
	public Map<String,Object> getRootMap(String key,String value){
		//Map<String,Object> rootMap = new HashMap<String, Object>();
		//添加url到 Map中
		//rootMap.putAll(URLUtils.getUrlMap());
		return SysServiceUrlUtils.getUrlMap(key, value);
	}

	
	
	public ModelAndView forword(String viewName,Map context){
		return new ModelAndView(viewName,context); 
	}
	
	public ModelAndView error(String errMsg){
		return new ModelAndView("error"); 
	}
	
	/**
	 *
	 * 提示成功信息
	 *
	 * @param message
	 *
	 */
//	public void sendSuccessMessage(HttpServletResponse response,  String message) {
//		Map<String, Object> result = new HashMap<String, Object>();
//		result.put(SUCCESS, true);
//		result.put(MSG, message);
//		HtmlUtil.writerJson(response, result);
//	}

	/**
	 *
	 * 提示失败信息
	 *
	 * @param message
	 *
	 */
//	public void sendFailureMessage(HttpServletResponse response,String message) {
//		Map<String, Object> result = new HashMap<String, Object>();
//		result.put(SUCCESS, false);
//		result.put(MSG, message);
//		HtmlUtil.writerJson(response, result);
//	}
	
	
}



