package org.me.db.util;
/*
 * 实现数据库连接关闭
  * author:duanjian
 * date:2013/03/10
 */

import java.io.InputStream;
import java.sql.Connection;
//import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import com.mchange.v2.c3p0.ComboPooledDataSource;
import java.util.Properties;
import javax.sql.DataSource;

import org.apache.commons.dbcp.BasicDataSourceFactory;

public class DBUtil {
	//c3p0 用
	private static ComboPooledDataSource dataSource;
	//dbcp 用
	 private static InputStream inStream;
	 private static Properties pro;
	 private static DataSource datasource;


	// 设置成单态模式，构造器私有
	private DBUtil() {
	}

//	// c3p0 方式
//	static {
//		// System.setProperty("com.mchange.v2.c3p0.cfg.xml","configure/c3p0-config.xml");
//		// dataSource = new ComboPooledDataSource("userApp");
//		try {
//			Properties prop = PropertiesUtil.getJdbcProp();
//			String driverClass = prop.getProperty("driverClass").trim();
//			String url = prop.getProperty("url").trim();
//			String user = prop.getProperty("user").trim();
//			String password = prop.getProperty("password").trim();
//			int initialPoolSize = Integer.parseInt(prop.getProperty(
//					"initialPoolSize").trim());
//			int maxIdleTime = Integer.parseInt(prop.getProperty("maxIdleTime")
//					.trim());
//			int maxPoolSize = Integer.parseInt(prop.getProperty("maxPoolSize")
//					.trim());
//			int maxStatements = Integer.parseInt(prop.getProperty(
//					"maxStatements").trim());
//			int minPoolSize = Integer.parseInt(prop.getProperty("minPoolSize")
//					.trim());
//			dataSource = new ComboPooledDataSource();
//			dataSource.setUser(user);
//			dataSource.setPassword(password);
//			dataSource.setJdbcUrl(url);
//			dataSource.setDriverClass(driverClass);
//			// 设置初始连接池的大小！
//			dataSource.setInitialPoolSize(initialPoolSize);
//			// 设置连接池的最小值！
//			dataSource.setMinPoolSize(minPoolSize);
//			// 设置连接池的最大值！
//			dataSource.setMaxPoolSize(maxPoolSize);
//			// 设置连接池中的最大Statements数量！
//			dataSource.setMaxStatements(maxStatements);
//			// 设置连接池的最大空闲时间！
//			dataSource.setMaxIdleTime(maxIdleTime);
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//
//	}
//
//	public static Connection getConnection() throws SQLException {
//		
//		return dataSource.getConnection();
//
//	}
	
	
	// dbcp 方式
	 static{
	        inStream=DBUtil.class.getClassLoader().getResourceAsStream("db_configure/MysqlDbcpConfig.properties");
	        pro=new Properties();
	        try {
	            pro.load(inStream);
	            datasource=BasicDataSourceFactory.createDataSource(pro);
	        } catch (Exception e) {
	            e.printStackTrace();
	            throw new RuntimeException("初始化错误！");
	        }
	    }
	    
	    public static DataSource getDataSource(){
	        return datasource;
	    }
	    
	    public static Connection getConnection(){
	        try {
	            return datasource.getConnection();
	        } catch (SQLException e) {
	            e.printStackTrace();
	            throw new RuntimeException("得到数据库连接失败！");
	        }
	    }

	// jdbc 方式
//	 public static Connection getConnection() {
//	 Properties prop = PropertiesUtil.getJdbcProp();
//	 String username = prop.getProperty("user");
//	 String password = prop.getProperty("password");
//	 String url = prop.getProperty("url");
//	 String driver= prop.getProperty("driverClass");
//	 Connection con = null;
//	 try {
//	 Class.forName(driver);
//	 con = DriverManager.getConnection(url, username, password);
//	 } catch (SQLException e) {
//	 e.printStackTrace();
//	 } catch (ClassNotFoundException e) {
//	 e.printStackTrace();
//	 }
//	 return con;
//	 }

	public static void close(Connection con) {
		try {
			if (con != null)
				con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void close(Statement ps) {
		try {
			if (ps != null)
				ps.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void close(ResultSet rs) {
		try {
			if (rs != null)
				rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
