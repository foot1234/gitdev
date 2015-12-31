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
	<table id="lov" class="easyui-datagrid" style="width:auto;height:350px"
		data-options="
				  iconCls: 'icon-edit',
				  pagination:true,
			      fitColumns: true,
			     rownumbers:true,
			     collapsible:true,
			     singleSelect: true,
			     method: 'get',
			     url:'ToDoGo.do?actionId=query@sys_role&dataSorce=xml/sys/SYS001/sys_role_select_lov.xml',
			     onDblClickRow: function (index, data) {
	        	   $('#role_lov_id')._setLovdata(data);
	        	   lov_record=data;
            	   $('#role_lov_id').window('close');  
	             }
				">
		        <thead>
		            <tr>
		             <th data-options="field:'role_id',checkbox:true">role_id</th>
				     <th data-options="field:'role_code',width:100,editor:'text'">角色代码</th>
					 <th data-options="field:'role_name',width:100,editor:'text'">角色名称</th>
		            </tr>
		        </thead>
		    </table> 
 <script type="text/javascript">
    //**begin edit lovcombox************************************************************************//    
    //lov全局变量
    var lov_table_id='#lov';
    var lov_url_e12='ToDoGo.do?actionId=query@sys_role&dataSorce=xml/sys/SYS001/sys_role_select_lov.xml';
 /*$(function () {
	    lov_record="";
	    var alert_flaglov=0;
        $(lov_table_id).datagrid({
        	 url: lov_url_e12,
        	 singleSelect: true,
        	 iconCls: 'icon-edit',
             pagination:true,
             fitColumns: true,
             rownumbers:true,
             method: 'get',
             onDblClickRow: function (index, data) {
            	 //lov_record=data;//赋值父页
            	 debugger;
            	$("#role_lov_id").setLovdata(data);
            	 $("#role_lov_id").window('close');  
            },
           onLoadError : function(err,a) {
		    	 if(alert_flaglov==0)$.messager.alert("提示", err.responseText+a, "error");
		    	 alert_flaglov=1;
		      }
        });
    });*/

 function lov_querye12(val){
	var query_text= $('#lov_query_text_id_e12').searchbox('getValue');
 	if(query_text==""||query_text==undefined||query_text==null)
 		{
 		query_text="";
 		}
 	query_text=encodeURIComponent(encodeURIComponent(query_text));//注意：''%'' 模糊查询必须转码，否则报错
 	 $(lov_table_id).datagrid({url: lov_url_e12+'?query_text='+query_text,
 	    method: 'get',
 	    pageNumber:1
 	 });
   }
   function lov_reserte12()
   {
 	  $("#lov_query_text_id_e12").searchbox('setValue',"");
 	 lov_querye12();
   }
   function lov_confirm12(){
		var records = $(lov_table_id).datagrid('getChecked');	
		  if(records.length > 1){
	 			EyMs.alert('警告','只能选择一行记录!','warning');  
	 			return;
				}
	   $('#role_lov_id')._setLovdata(records);
   	   $('#role_lov_id').window('close');  
  }
  //**end edit lovcombox************************************************************************// 
</script>    
</body>
</html>