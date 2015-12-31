package org.me.emp.test;

import java.util.Iterator;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class teststr2json {
	public static void main(String[] args) throws JSONException {
		//String sJson = "[{'gwcxxid':'1','spsl':'2'},{'gwcxxid':'1','spsl':'2'},{'gwcxxid':'3','spsl':'4'}]";
		String sJson ="["+
"{'function_id':'670','service_id':'2106','service_name':'modules/mda/MDA7060/mda_item_detail_mt_tmpl_choice.screen','title':'物品属性明细维护申请','creation_date':'2012-12-27 14:00:55.0','rn':'1'},"
+"{'function_id':'670','service_id':'2107','service_name':'modules/mda/MDA7060/mda_item_detail_mt_req_create.screen','title':'物品属性明细维护申请创建','creation_date':'2012-12-27 14:24:48.0','rn':'2'}"
+"]";
		JSONArray jsonArray = new JSONArray(sJson);
		int iSize = jsonArray.length();
		System.out.println("Size:" + iSize);
		/*for (int i = 0; i < iSize; i++) {
			JSONObject jsonObj = jsonArray.getJSONObject(i);
			System.out.println("[" + i + "]gwcxxid=" + jsonObj.get("function_id"));
			System.out.println("[" + i + "]spsl=" + jsonObj.get("service_name"));
			System.out.println();
		}*/
		for (int i = 0; i < iSize; i++) {//迭代器测试
			JSONObject jsonObj = jsonArray.getJSONObject(i);
			for (Iterator<?> iter = jsonObj.keys(); iter.hasNext();) {
				String key = (String) iter.next();
				//map.put(key, jsonObj.get(key));
				 System.out.println("[" + i + "]="+"key:"+key +" value:" + jsonObj.get(key));
			}
			
			//System.out.println("[" + i + "]gwcxxid=" + jsonObj.get("function_id"));
			//System.out.println("[" + i + "]spsl=" + jsonObj.get("service_name"));
			System.out.println();
		}
	}
}
