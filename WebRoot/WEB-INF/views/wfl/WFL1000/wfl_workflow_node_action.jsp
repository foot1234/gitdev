<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/view/base/resource.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
		<table id="action_node_table_id"  class="easyui-datagrid" style="width:880;height:330px"
         data-options="
			  pagination:true,
		      fitColumns: true,
		     rownumbers:true,
		     collapsible:true
			">
		<thead>
		    <tr><th data-options="field:'action_id',checkbox:true">action_id</th>
				  <th data-options="field:'action_id_display',width:100,sortable:true,editor: { type: 'validatebox', options: { required: true} }">动作</th>
				  <th data-options="field:'exec_proc_display',width:100,sortable:true,editor:'text'">过程</th>
				    <th data-options="field:'order_num',width:100,sortable:true,editor:'text'">顺序</th>
		       </tr>
		</thead>
	</table>
 		
 <script type="text/javascript">
  var g_table_id='#action_node_table_id';
  var g_workflow_id2= '<%=request.getParameter("workflow_id")%>';
  var g_node_id2= '<%=request.getParameter("node_id")%>';
  var g_action_uri='ToDoGo.do?actionId=query@list&dataSorce=xml/wfl/WFL1000/wfl_workflow_node_action.xml';
  var alert_flag=0;
  $(g_table_id).datagrid({url: g_action_uri,
  	        queryParams: {workflow_id:g_workflow_id2,node_id:g_node_id2},
  			onLoadSuccess:function(data){//启用消息提示框   
  			    $(g_table_id).datagrid("tooltip");    
  			}, 
  		     onLoadError : function(err,a) {
  		    	 if(alert_flag==0)$.messager.alert("提示", err.responseText+a, "error");
  		    	  alert_flag=1;
  		       },
  		       toolbar : [ {text : '添加', iconCls : 'icon-add',handler : edit_buttion1
  		       }, '-', {text : '删除', iconCls : 'icon-remove',handler : edit_buttion1
  		       }, '-', {text : '保存', iconCls : 'icon-save',handler : edit_buttion1
  		       } ]
  		});
  function edit_buttion1(callback){
	  
  }
    </script>    
</body>
</html>