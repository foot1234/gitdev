<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/view/base/resource.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
		<table id="action_table_id"  class="easyui-datagrid" style="width:880;height:330px"
         data-options="
			  pagination:true,
		      fitColumns: true,
		     rownumbers:true,
		     collapsible:true
			">
		<thead>
		    <tr><th data-options="field:'action_id',checkbox:true">action_id</th>
		            <th data-options="field:'workflow_id',hidden:true">workflow_id</th>
				  <th data-options="field:'action_title',width:100,sortable:true,editor: { type: 'validatebox', options: { required: true} }">动作名称</th>
				  <th data-options="field:'action_type',width:100,sortable:true,editor:{
															type:'combobox',
															options:{
																valueField:'code_value',
																textField:'code_value_name',
																method:'get',
																url:'SYSCODE/WFL_WORKFLOW_ACTION_TYPE',
																required:true
															}
														},formatter:function(value,row){
															return row.action_type_display;
														}">动作过程</th>
		       </tr>
		</thead>
	</table>
 		
 <script type="text/javascript">
  var g_action_table_id='#action_table_id';
  var g_workflow_id1= '<%=request.getParameter("workflow_id")%>';
  var g_action_uri='ToDoGo.do?actionId=query@action&dataSorce=xml/wfl/WFL1000/wfl_workflow.xml';
  var g_workflow_action_xml='xml/wfl/WFL1000/wfl_workflow.xml';
	/****combox 处理*******************************************************************/   
	function com_init(old_index){
	         var ed = $(g_action_table_id).datagrid('getEditor', {index:old_index,field:'action_type'});
 	    	if(ed!=null){
            var action_type_display = $(ed.target).combobox('getText');
  		   $(g_action_table_id).datagrid('getRows')[old_index]['action_type_display'] = action_type_display;
  		 }
	}
	/***********************************************************************/
  
  var alert_flag=0;
  $(g_action_table_id).datagrid({url: g_action_uri,
  	        queryParams: {workflow_id:g_workflow_id1},
  			onLoadSuccess:function(data){//启用消息提示框   
  			    $(g_action_table_id).datagrid("tooltip");    
  			}, 
  		     onLoadError : function(err,a) {
  		    	 if(alert_flag==0)$.messager.alert("提示", err.responseText+a, "error");
  		    	  alert_flag=1;
  		       },
  		     onClickRow: function(index,rowData){
		  		       $(this).gridEdit(index,{
		                      init : function(old_index) {
		                         com_init(old_index);//combox 返回处理
						}
                 });//编辑  
  			  },	
  		       toolbar : [ {text : '添加', iconCls : 'icon-add',handler : function(){ edit_buttion2('add');}
  		       }, '-', {text : '删除', iconCls : 'icon-remove',handler : function(){ edit_buttion2('del');}
  		       }, '-', {text : '保存', iconCls : 'icon-save',handler : function(){ edit_buttion2('save');}
  		       } ]
  		});
  function edit_buttion2(action){
	  debugger;
	  if (action=='add'){
			 $(g_action_table_id).gridAdd({workflow_id: g_workflow_id1},{
                 init : function(old_index) {
                     com_init(old_index);//combox 返回处理
				}});
		} else if(action=='del'){
			 $(g_action_table_id).gridRemove(g_workflow_action_xml,"action_del");
		}else if(action=='save'){
			 $(g_action_table_id).gridSave(g_workflow_action_xml,'action_edit');
		}
	

  }
    </script>    
</body>
</html>