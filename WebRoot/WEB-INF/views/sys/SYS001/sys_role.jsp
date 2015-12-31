<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@include file="/view/base/resource.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</script>
</head>
<body>
<div class="easyui-panel" title="查询条件" style="width:700px">
<form id="queryForm" class="ui-form" method="post"> 
	            <div data-options="region:'north',split:true" style="padding:5px">  
	              <!-- <div class="ftitle">维护信息</div>  -->
	              
		            <div class="fitem">
						<label>角色代码:</label>
						<input class="easyui-validatebox"   style="width:155px;" name="role_code"  >	
						<label>角色名称:</label>
		                <input class="easyui-validatebox"  style="width:155px;" name="role_name" >	
		           </div>  
                    <div class="fitem">
	                  <label>模糊查询(%):</label>
		              <input id="query_text_id"  class="easyui-searchbox"  name="query_text"  data-options="width:416,searcher:querys,prompt:'请输入条件,以%开始或结束'"  type="text" />
	               </div>
	            </div>
	         </form>
  </div>
      <div  style="margin-left:20px;margin-bottom:10px;">  
			<a href="javascript:void(0)" id='addLine_btn' class="easyui-linkbutton" data-options="iconCls:'icon-search'"  onclick="querys()" >查询</a>  
			<a href="javascript:void(0)" id='addLine_btn' class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="reset()"  >重置</a>  
    </div> 
	<table id="service_table_id"  title="角色定义" class="easyui-datagrid" style="width:auto;height:350px"
         data-options="
			  iconCls: 'icon-edit',
			  pagination:true,
		      fitColumns: true,
		     rownumbers:true,
		     collapsible:true
			">
		<thead>
		    <tr><th data-options="field:'ck',checkbox:true">ck</th>
		          <th data-options="field:'role_id',hidden:true">role_id</th>
				  <th data-options="field:'role_code',width:100,sortable:true,resizable:true,editor: { type: 'validatebox', options: { required: true,validType:'checkUpper'} }">角色代码</th>
				  <th data-options="field:'role_name',width:100,sortable:true,resizable:true,editor:'text'">角色名称</th>
				  <th data-options="field:'role_description',width:100,resizable:true,editor:'text'">角色描述</th>
				 <th data-options="field:'start_date',width:100,sortable:true,align:'center',resizable:true,editor:{type:'datebox',options: {required: true}}">开始日期</th>
				  <th data-options="field:'end_date',width:100,resizable:true,align:'center',editor:{type:'datebox'}">结束日期</th>
		       </tr>
		</thead>
	</table>
<script type="text/javascript">
var g_queryForm_id='#queryForm';
var g_table_id='#service_table_id';
var g_table_uri='ToDoGo.do?actionId=query@role_code&dataSorce=xml/sys/SYS001/sys_role.xml';
var g_table_save_url="xml/sys/SYS001/sys_role.xml";
$(function() {
	/*1主页的设置*/
	 // 第一次加载时自动变化大小
	  var docWin=document.body;
	 $(g_table_id).resizeDataGrid(docWin,0, 0, 0, 0);
	 // 当窗口大小发生变化时，调整DataGrid的大小
	 $(docWin).resize(function() {
	  $(g_table_id).resizeDataGrid(docWin,0, 0, 0, 0);
	 });
});
	
/***********************************************************************/   	
var alert_flag=0;
$(g_table_id).datagrid({url: g_table_uri,
	       // queryParams: {function_id:g_function_id},
			onLoadSuccess:function(data){//启用消息提示框   
			    $(g_table_id).datagrid("tooltip");    
			}, 
		    onLoadError : function(err,a) {
		    	 if(alert_flag==0)$.messager.alert("提示", err.responseText+a, "error");
		    	  alert_flag=1;
		    },
		   onSelect: function(index,data){
	        },
		   toolbar : [ {text : '添加', iconCls : 'icon-add',handler : function(){ edit_buttion('add');}
		       }, '-', {text : '保存', iconCls : 'icon-save',handler : function(){edit_buttion('save');}
		   } ]
		}).datagrid('_enableRowEditing').datagrid("_columnMoving");
function edit_buttion(action){
	//var action=callback.currentTarget.text;
	if (action=='add'){
		$(g_table_id)._gridAdd({is_access_checked:1,is_login_required:1});
	}else if(action=='save'){
		 $(g_table_id)._gridSave(g_table_save_url,null,true);//function(url,action,alert_flag)
	}
}
/***********************************************************************/   
function querys(){
	var formrecord=$(g_queryForm_id).form('serialize');
	  formrecord['query_text']=$('#query_text_id').searchbox('getValue');//特殊处理
	  var record="["+JSON.stringify(formrecord)+"]";   //对象数组转换为json
		$(g_table_id).datagrid({url: g_table_uri,
									queryParams: {_para:record},
									pageNumber:1
		                            });
}
function reset(){
	 $(g_queryForm_id).form('reset');
	 querys();
}
</script>    
</body>
</html>