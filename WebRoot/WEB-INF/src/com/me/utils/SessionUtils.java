package com.me.utils;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;

import org.apache.log4j.Logger;

import com.sun.jmx.snmp.Timestamp;


/**
 * 
 * Cookie 工具类
 *
 */
public final class SessionUtils{
	
	protected static final Logger logger = Logger.getLogger(SessionUtils.class);
	
	public static final String SESSION_IP = "/session/address";
	
	public static final String SESSION_USER = "/session/user_id";

	public static final String SESSION_VALIDATECODE = "session_validatecode";//验证码
	
	public static final String SESSION_ID = "/session/session_id"; //系统session
	
	public static final String ENCRYTED_SESSION_ID = "/session/encryted_session_id"; //系统加密的session
	
	public static final String SESSION_COMPANY_ID = "/session/company_id"; //
	
	public static final String SESSION_ROLE_ID = "/session/role_id";
	
	/**
	  * 设置session的值
	  * @param request
	  * @param key
	  * @param value
	  */
	 public static void setAttr(HttpServletRequest request,String key,Object value){
		 request.getSession(true).setAttribute(key, value);
	 }
	 
	 
	 /**
	  * 获取session的值
	  * @param request
	  * @param key
	  * @param value
	  */
	 public static Object getAttr(HttpServletRequest request,String key){
		 try {
			return request.getSession(true).getAttribute(key);
		} catch (Exception e) {
			//e.printStackTrace();
		}
		 return "";
	 }
	 
	 /**
	  * 删除Session值
	  * @param request
	  * @param key
	  */
	 public static void removeAttr(HttpServletRequest request,String key){
		 request.getSession(true).removeAttribute(key);
	 }
	 

	 

	 /**
	  * 从session中获取用户信息
	  * @param request
	  * @return SysUser
	  */
	 public static void removeUser(HttpServletRequest request){
		try {
			removeAttr(request, SESSION_USER);
			removeAttr(request, SESSION_IP);
			removeAttr(request, SESSION_ID);
			removeAttr(request, ENCRYTED_SESSION_ID);
			//removeAttr(request, SESSION_VALIDATECODE);
			removeAttr(request, SESSION_COMPANY_ID);
			removeAttr(request, SESSION_ROLE_ID);
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	 }
	 
	 
	 
	 
	 /**
	  * 设置验证码 到session
	  * @param request
	  * @param user
	  */
	 public static void setValidateCode(HttpServletRequest request,String validateCode){
		 request.getSession(true).setAttribute(SESSION_VALIDATECODE, validateCode);
	 }
	 
	 
	 /**
	  * 从session中获取验证码
	  * @param request
	  * @return SysUser
	  */
	 public static String getValidateCode(HttpServletRequest request){
		return (String)request.getSession(true).getAttribute(SESSION_VALIDATECODE);
	 }
	 
	 
	 /**
	  * 从session中获删除验证码
	  * @param request
	  * @return SysUser
	  */
	 public static void removeValidateCode(HttpServletRequest request){
		removeAttr(request, SESSION_VALIDATECODE);
	 }
	 
	 
	 

}