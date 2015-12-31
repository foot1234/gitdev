package com.me.exception;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.me.db.view.jsonFactory;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;


public class ExceptionGlob implements HandlerExceptionResolver {
	private final static Logger log= Logger.getLogger(ExceptionGlob.class);//默认形式
	//private final static Logger log= Logger.getLogger("stdout");//基于自定义名称形式
	@Override
	public ModelAndView resolveException(HttpServletRequest request,
			HttpServletResponse response, Object arg2, Exception ex) {
		 
		try {  
			 request.setCharacterEncoding("UTF-8");
		     response.setCharacterEncoding("UTF-8");	
				String OraMessage=ex.getMessage();
				System.out.println("进入异常处理中.."+OraMessage);
				String OraCode="";
				String MsgId="";
				String Message="";
					try {
						OraCode = OraMessage.substring(0, OraMessage.indexOf(":")).trim();
						String MsgCode=OraMessage.substring(OraMessage.indexOf(":")+1);
						MsgId = MsgCode.substring(0,MsgCode.indexOf("ORA")).trim();
						System.out.println("OraCode:"+OraCode+"MsgId:"+MsgId);
					} catch (Exception el) {
					}
				Message=OraMessage;
				if(OraCode.equals("ORA-20000")){
					//数据库自定义异常
					Message=	new jsonFactory().getOraErrMsg(MsgId);
				}
				log.error(Message);//日志记录
				response.getWriter().print(Message);//抛到前台
		} catch (IOException e) {
			e.printStackTrace();
			log.error(e.getMessage(), e);
		} 
		return new ModelAndView(); 
	}
}
