<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/view/base/resource.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body> 
 	<form id="editForm_love12" class="ui-form"> 
	     <table style="padding:5px;height:auto"><tr>
	        <td><label>查询条件:</label></td>
	       <td><input  id="lov_query_text_id_e12"  class="easyui-searchbox"  name="lov_query_text"  data-options="width:200,searcher:lov_querye12,prompt:'请输入查询条件'"  type="text" /></td>
		   <td style="padding:15px;height:auto" ><a href="javascript:void(0)" class="easyui-linkbutton"  onclick="lov_querye12()">查询</a></td>
		  <td><a href="javascript:void(0)" class="easyui-linkbutton" onclick="lov_reserte12()">重置</a> </td>
		  <td><a href="javascript:void(0)" class="easyui-linkbutton" onclick="lov_confirm12()">确定</a> </td>
		  </tr>
		  </table>
 	</form>
	<table id="lov12" class="easyui-datagrid" style="width:auto;height:350px"   data-options="
			  iconCls: 'icon-edit',
			  pagination:true,
		      fitColumns: true,
		     rownumbers:true,
		     collapsible:true,
		     singleSelect: true,
		     method: 'get',
		     url:'ToDoGo.do?actionId=query@load&dataSorce=xml/sys/sys_service.xml',
		     onDblClickRow: function (index, data) {
        	 lov_record=data;//赋值父页
        	 $('#edit_test_open').window('close');  
             }
			">
		        <thead>
		            <tr>
		             <th data-options="field:'service_id',checkbox:true">service_id</th>
				     <th data-options="field:'service_name',width:200,editor:'text'">页面</th>
					 <th data-options="field:'title',width:100,editor:'text'">标题</th>
		            </tr>
		        </thead>
		    </table> 
 <script type="text/javascript">
    //**begin edit lovcombox************************************************************************//    
    //lov全局变量
    var lov_table_id='#lov12';
    var this_window_id='#edit_test_open';
    var lov_url_e12='ToDoGo.do?actionId=query@load&dataSorce=xml/sys/sys_service.xml';
 
    lov_record="";
	/*$(lov_table_id).datagrid({
         onDblClickRow: function (index, data) {
        	 lov_record=data;//赋值父页
        	 $(this_window_id).window('close');  
        }
 });	*/

    
 function lov_querye12(val){
	 debugger;
	var query_text= $('#lov_query_text_id_e12').searchbox('getValue');
 	if(query_text==""||query_text==undefined||query_text==null)
 		{
 		query_text="";
 		}
 	query_text=encodeURIComponent(encodeURIComponent(query_text));//注意：''%'' 模糊查询必须转码，否则报错
 	 $(lov_table_id).datagrid({url: lov_url_e12+'?query_text='+query_text,
 	    method: 'post',
 	    pageNumber:1
 	 });
   }
   function lov_reserte12()
   {
 	  $("#lov_query_text_id_e12").searchbox('setValue',"");
 	 lov_querye12();
   }
   
 //预定义		
 //Grid 工具类
 	   //Grid DataList
 	var Grid_lov = $('#lov12');
 	var Utils_lov = {
 		getCheckedRows : function(){
 			return Grid_lov.datagrid('getChecked');			
 		},
 		checkSelect : function(rows){//检查grid是否有勾选的行, 有返回 true,没有返回true
 	
 			var records =  rows;
 			if(records && records.length > 0){
 				return true;
 			}
 			EyMs.alert('警告','未选中记录!','warning');  
 			return false;
 			
 		},
 		checkSelectOne : function(rows){//检查grid是否只勾选了一行,是返回 true,否返回true
 			//debugger;
 			var records = rows;
 			if(!Utils.checkSelect(records)){
 				return false;
 			}
 			if(records.length == 1){
 				return true;
 			}
 			EyMs.alert('警告','只能选择一行记录!','warning');  
 			return false;
 		}
 	}
   function lov_confirm12(){
 		var records = Utils_lov.getCheckedRows();
		if (Utils_lov.checkSelectOne(records)){
			 lov_record=records[0];//赋值父页
        	 $(this_window_id).window('close');  
		}	 
   }

 

  //**end edit lovcombox************************************************************************// 
</script>    
</body>
</html>