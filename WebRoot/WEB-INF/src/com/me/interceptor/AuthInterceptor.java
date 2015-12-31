package com.me.interceptor;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.me.annotation.Auth;
import com.me.utils.SessionUtils;

/**
 * 权限拦截器
 * @author lu
 *
 */
public class AuthInterceptor extends HandlerInterceptorAdapter {
	private final static Logger log= Logger.getLogger(AuthInterceptor.class);
	
	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
		String baseUri = request.getContextPath();
		String path = request.getServletPath();
		System.out.println("baseUri:"+baseUri);
		System.out.println("path:"+path);
		
		String s = ".*(SYSCODE/).*";
		Pattern  pattern=Pattern.compile(s);  
        Matcher  ma=pattern.matcher(path);  
        
       // System.out.println();

		if(ma.find()||path.endsWith(".shtml")||path.endsWith(".do")||path.equals("/ToDoGo")){
			HandlerMethod method = (HandlerMethod)handler;
			Auth  auth = method.getMethod().getAnnotation(Auth.class);
			////验证登陆超时问题  auth = null，默认验证 
			System.out.println("auth.verifyLogin:"+auth.verifyLogin());
			if( auth == null || auth.verifyLogin()){
				String encryted_session_id=(String)SessionUtils.getAttr(request, "/session/encryted_session_id");
				//System.out.println("<<<<<<<<<<<<<<<<<<<<<<encryted_session_id:"+encryted_session_id);
				log.debug("<<<<<<<<<<<<<<<<<<<<<<encryted_session_id:"+encryted_session_id);
				if(encryted_session_id  == null||encryted_session_id.equals("")){
					//System.out.println("系统登录超时!");
					log.error("系统登录超时!");
					response.setStatus(response.SC_GATEWAY_TIMEOUT);
					//throw new Exception("系统登录超时!");
					response.sendRedirect(baseUri+"/uncheckPage.shtml?uri=login_time_out");
					//return false;
				}
			}

		}
		

		
//		//验证URL权限
//		if( auth == null || auth.verifyURL()){		
//			//判断是否超级管理员
////			if(!SessionUtils.isAdmin(request)){
////				String menuUrl = StringUtils.remove( request.getRequestURI(),request.getContextPath());;
////				if(!SessionUtils.isAccessUrl(request, StringUtils.trim(menuUrl))){					
////					//日志记录
////					String userMail = SessionUtils.getUser(request).getEmail();
////					String msg ="URL权限验证不通过:[url="+menuUrl+"][email ="+ userMail+"]" ;
////					log.error(msg);
////					
////					response.setStatus(response.SC_FORBIDDEN);
////					Map<String, Object> result = new HashMap<String, Object>();
////					result.put(BaseAction.SUCCESS, false);
////					result.put(BaseAction.MSG, "没有权限访问,请联系管理员.");
////					HtmlUtil.writerJson(response, result);
////					return false;
////				}
//			//}
//		}
		return super.preHandle(request, response, handler);
	}

	
}
