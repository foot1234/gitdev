package org.me.db.util;
/*
* 获取xml配置文件
 * author:duanjian
 * date:2013/04/18
 */
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;

import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;

import com.me.action.MainAction;

public class XMLUtil {
	private static Document userDocument;
	private  Document document;
	//解决频繁读取io数据
	public static  HashMap<String, Document> map=new HashMap<String, Document>();  
	private final static Logger log= Logger.getLogger(XMLUtil.class);
	/**
	 * 用来读取UserDocument
	 * @return
	 */
	public static Document getUserDocument() {
		//如果document存在直接返回
		if(userDocument!=null) return userDocument;
		//如果不存在就创建对象
		try {
			SAXReader reader = new SAXReader();
			userDocument = reader.read(XMLUtil.class.getClassLoader().getResourceAsStream("xml/users.xml"));
			return userDocument;
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public  Document getInstance(String xml_path) throws Exception {
		//如果不存在就创建对象
		String xml_doc=null;
	    Boolean get_flag=false;
			try {
				if(map.size()>0){
					    document=map.get(xml_path);
					    xml_doc= document.toString();
					   if(xml_doc==null|| xml_doc.length() <1){	
						   get_flag=false;
					    }else{
					       get_flag=true;
						   System.out.println("取到了map document:"+xml_path);
						}
					}
			} catch (Exception e1) {
				get_flag=false;
			}
			
			if(get_flag==false){	
				 try {
						SAXReader reader = new SAXReader();
						document = reader.read(XMLUtil.class.getClassLoader().getResourceAsStream(xml_path));
						
						map.put(xml_path, document);  
						System.out.println("添加了map document:"+xml_path);
					} catch (DocumentException e) {
						String errStr="无法取到路径:"+xml_path+" 的配置文件，请检查路径!";
						System.out.println(errStr);
						log.error(errStr);
						throw new Exception(errStr);
						//e.printStackTrace();
					}	
			}	
			return document;	
	}
	
	public static void write2XML(Document d,String name) {
		XMLWriter out = null;
		try {
			String path = XMLUtil.class.getClassLoader().getResource("xml/"+name+".xml").getPath();
			path = path.replace("bin","src");
			out = new XMLWriter(new FileWriter(path),OutputFormat.createPrettyPrint());
			out.write(d);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if(out!=null) out.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
}
