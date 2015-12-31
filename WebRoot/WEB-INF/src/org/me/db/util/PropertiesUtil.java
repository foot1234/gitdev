package org.me.db.util;
/*
* 获取properties配置文件
 * author:duanjian
 * date:2013/04/26
 */
import java.io.IOException;
import java.util.Properties;

public class PropertiesUtil {
	private static Properties jdbcProp;
	private static Properties parameterProp;
	public  static Properties logProp;
	
/*	public static Properties getJdbcProp() {
		try {
			if(jdbcProp==null) {
				jdbcProp = new Properties();
				jdbcProp.load(PropertiesUtil.class.getClassLoader().getResourceAsStream("configure/jdbc.properties"));
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return jdbcProp;
	}
	public static Properties getParameterProp() {
		try {
			if(parameterProp==null) {
				parameterProp = new Properties();
				parameterProp.load(PropertiesUtil.class.getClassLoader().getResourceAsStream("configure/parameter.properties"));
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return parameterProp;
	}*/
	
	public static Properties getlogProp() {
		try {
			if(logProp==null) {
				logProp = new Properties();
				logProp.load(PropertiesUtil.class.getClassLoader().getResourceAsStream("urls.properties"));
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return logProp;
	}

	public static Properties getParameterProp() {
		// TODO Auto-generated method stub
		return null;
	}
}
