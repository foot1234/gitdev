package org.me.db.model;
/*
* 前台翻页grid属性
 * author:duanjian
 * date:2013/04/17
 */
import java.util.List;

public class PageorColumns {
	private  List<ColumnInfoBean> column_ls =null;
	private int totalRows=0;//总记录数
	private int pageSize=100000;//每页显示记录数
	private int currentPage=1;//当前页
	private int PageCount=1;//总页数
	
	public List<ColumnInfoBean> getColumn_ls() {
		return column_ls;
	}
	public void setColumn_ls(List<ColumnInfoBean> column_ls) {
		this.column_ls = column_ls;
	}
	public int getTotalRows() {
		return totalRows;
	}
	public void setTotalRows(int totalRows) {
		this.totalRows = totalRows;
	}
	public int getPageSize() {
		return pageSize;
	}
	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}
	public int getCurrentPage() {
		return currentPage;
	}
	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}
	public int getPageCount() {
		return PageCount;
	}
	public void setPageCount(int pageCount) {
		PageCount = pageCount;
	}
}
