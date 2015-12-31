package org.me.db.dao;
/**
 * 获取数据库数据接口
 * author:duanjian
 * date:2013/03/12
 * 
 */
import java.sql.ResultSet;
import java.util.List;
import java.util.Map;


import org.me.db.model.ColumnInfoBean;


public interface IDoDao {

	public String get_sql(Map<String,Object> map_Param,String sql_xml_path, String act) throws Exception;
	public String get_fun(Map<String,Object> map_Param,String sql_xml_path, String act_id) throws Exception;
	public List<ColumnInfoBean> getColumnInfoes(ResultSet rs);
	public List<Map<String,Object>> query_list(String sql);
	public String query_list2json(String sql) throws Exception;
	public int update(String sql);
	public String execute( String fun_sql) throws Exception;
}
