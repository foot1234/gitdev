<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/view/base/resource.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
		<table id="procedure_table_id"  class="easyui-datagrid" style="width:880;height:330px"
         data-options="
			  pagination:true,
		      fitColumns: true,
		     rownumbers:true,
		     collapsible:true
			">
		<thead>
		    <tr><th data-options="field:'record_id',checkbox:true">record_id</th>
		            <th data-options="field:'proc_display_id',hidden:true">proc_display_id</th>
		          <th data-options="field:'proc_display_id',hidden:true">description_id</th>
				  <th data-options="field:'proc_type',width:100,sortable:true,editor:{
															type:'combobox',
															options:{
																valueField:'code_value',
																textField:'code_value_name',
																method:'get',
																url:'SYSCODE/WFL_WORKFLOW_PROC_TYPE',
																required:true
															}
														},formatter:function(value,row){
															return row.proc_type_display;
														}">过程类型</th>
				  <th data-options="field:'proc_name',width:100,sortable:true,editor: { type: 'validatebox', options: { required: true} }">过程名称</th>
				   <th data-options="field:'proc_display',width:100,sortable:true,editor: { type: 'validatebox', options: { required: true} }">过程标题</th>
				  <th data-options="field:'description',width:100,sortable:true,editor:'text'">过程描述</th>
		       </tr>
		</thead>
	</table>
 <script type="text/javascript">
  var g_table_id='#procedure_table_id';
  var g_proc_workflow_id= '<%=request.getParameter("workflow_id")%>';
  var g_action_uri='ToDoGo.do?actionId=query@wfl_procedure&dataSorce=xml/wfl/WFL1000/wfl_workflow.xml';
  var g_workflow_proc_xml='xml/wfl/WFL1000/wfl_workflow.xml';
  var alert_flag=0;
	/****combox 处理*******************************************************************/   
	function com_init(old_index){
	    var ed = $(g_table_id).datagrid('getEditor', {index:old_index,field:'proc_type'});
	    	if(ed!=null){
          var proc_type_display = $(ed.target).combobox('getText');
		   $(g_table_id).datagrid('getRows')[old_index]['proc_type_display'] = proc_type_display;
		 }
	}
	/***********************************************************************/
  $(g_table_id).datagrid({url: g_action_uri,
  	        queryParams: {workflow_id:g_proc_workflow_id},
  			onLoadSuccess:function(data){//启用消息提示框   
  			    $(g_table_id).datagrid("tooltip");    
  			}, 
  		   onClickRow: function(index,rowData){
  		       $(this).gridEdit(index,{
                      init : function(old_index) {
                         com_init(old_index);//combox 返回处理
				}
		         });//编辑  
				  },	
  		     onLoadError : function(err,a) {
  		    	 if(alert_flag==0)$.messager.alert("提示", err.responseText+a, "error");
  		    	  alert_flag=1;
  		       },
  		       toolbar : [ {text : '添加', iconCls : 'icon-add',handler : function(){edit_buttion1_p('add');}
  		       }, '-', {text : '删除', iconCls : 'icon-remove',handler : function(){edit_buttion1_p('del');}
  		       }, '-', {text : '保存', iconCls : 'icon-save',handler : function(){edit_buttion1_p('save');}
  		       } ]
  		});
  function edit_buttion1_p(action){
	  if (action=='add'){
			 $(g_table_id).gridAdd({workflow_id: g_proc_workflow_id},{
              init : function(old_index) {
                  com_init(old_index);//combox 返回处理
				}});
		} else if(action=='del'){
			 $(g_table_id).gridRemove(g_workflow_proc_xml,"proc_del");
		}else if(action=='save'){
			 $(g_table_id).gridSave(g_workflow_proc_xml,'proc_edit');
		}
  }
    </script>    
</body>
</html>