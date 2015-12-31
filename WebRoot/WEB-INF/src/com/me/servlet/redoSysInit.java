package com.me.servlet;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.me.db.util.XMLUtil;

import com.me.utils.SysServiceUrlUtils;

@WebServlet("/redoSysInit")
public class redoSysInit extends HttpServlet {
	private static final long serialVersionUID = 1L;
	  /**
     * @see HttpServlet#HttpServlet()
     */
    public redoSysInit() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Servlet#init(ServletConfig)
	 */
	public void init(ServletConfig config) throws ServletException {
		// TODO Auto-generated method stub
		
	}
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 * 初始重载
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			SysServiceUrlUtils.sys_service_init();//sys_service_init为SysServiceUrlUtils的方法   
			SysServiceUrlUtils.sys_code_init();
			SysServiceUrlUtils.sys_function_init();
			SysServiceUrlUtils.initlogurl();
			XMLUtil.map.clear();
			System.out.println("重载成功!");
		} catch (Exception e) {
			e.printStackTrace();
		}	
	}
}
