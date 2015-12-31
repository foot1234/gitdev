package org.me.db.model;
/*
* 获取数据库表字段属性
 * author:duanjian
 * date:2013/04/17
 */

public class ColumnInfoBean {
private String Name;  // 字段名
private String TypeName; // 字段类型
private String ClassName;   // 字段类型对应的java类名
private int DisplaySize;   // 显示的长度
private float Precision;//精度
private String Scale;
public String getName() {
	return Name;
}
public void setName(String name) {
	Name = name;
}
public String getTypeName() {
	return TypeName;
}
public void setTypeName(String typeName) {
	TypeName = typeName;
}
public String getClassName() {
	return ClassName;
}
public void setClassName(String className) {
	ClassName = className;
}
public int getDisplaySize() {
	return DisplaySize;
}
public void setDisplaySize(int displaySize) {
	DisplaySize = displaySize;
}
public float getPrecision() {
	return Precision;
}
public void setPrecision(float precision) {
	Precision = precision;
}
public String getScale() {
	return Scale;
}
public void setScale(String scale) {
	Scale = scale;
}
}
