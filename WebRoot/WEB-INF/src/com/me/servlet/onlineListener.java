package com.me.servlet;  
  
import java.util.ArrayList;  
import javax.servlet.ServletContext;  
import javax.servlet.http.HttpSessionAttributeListener;  
import javax.servlet.http.HttpSessionBindingEvent;  
import javax.servlet.http.HttpSessionEvent;  
import javax.servlet.http.HttpSessionListener;  

import com.me.utils.SessionUtils;
  
public class onlineListener implements HttpSessionListener,  
        HttpSessionAttributeListener {  
    // 参数  
    ServletContext sc;  
  
    static  ArrayList   list = new ArrayList();  
  
    // 新建一个session时触发此操作  
    public void sessionCreated(HttpSessionEvent se) {  
        sc = se.getSession().getServletContext();  
        System.out.println("新建一个session");  
    }  
  
    // 销毁一个session时触发此操作  
    public void sessionDestroyed(HttpSessionEvent se) {  
    	System.out.println("销毁一个session"+(String) se.getSession().getAttribute(SessionUtils.SESSION_USER));  
    	if (!list.isEmpty()) {  
            list.remove((String) se.getSession().getAttribute(SessionUtils.SESSION_USER));  
            sc.setAttribute("list", list);  
        }  
    }  
  
    // 在session中添加对象时触发此操作，在list中添加一个对象  
    public void attributeAdded(HttpSessionBindingEvent sbe) {  
    	if(sbe.getName().equals(SessionUtils.SESSION_USER)){
	        list.add((String) sbe.getValue());  
	        System.out.println("添加session："+sbe.getName()+":"+sbe.getValue());  
	        System.out.println("当前在线用户数："+list.size());  
	        sc.setAttribute("list", list);  
        }
    }  
  
    // 修改、删除session中添加对象时触发此操作  
    public void attributeRemoved(HttpSessionBindingEvent sbe) {  
        System.out.println("session删除！"+sbe.getName()+":"+sbe.getValue());  
        if ((!list.isEmpty())&&(sbe.getName().equals(SessionUtils.SESSION_USER))) {  
            //list.remove((String) sbe.getSession().getAttribute(SessionUtils.SESSION_USER));  
        	list.remove((String) sbe.getValue());  
            sc.setAttribute("list", list);  
        }  
    }  
  
    public void attributeReplaced(HttpSessionBindingEvent arg0) {  
        System.out.println("session被替换!");  
    }  
} 