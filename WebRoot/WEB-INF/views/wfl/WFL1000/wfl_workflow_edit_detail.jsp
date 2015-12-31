<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@include file="/view/base/resource.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<div class="easyui-panel" title="维护"  style="width:900px">
 	<form id="editForm" class="ui-form" method="post"> 
     	 <!-- 隐藏文本框 -->
		     	 <input class="hidden" name="workflow_id">
		     	 <input class="hidden" name="name_id">
		     	 <input class="hidden" name="display_form">
		     	 <input class="hidden" name="update_form">
		     	  <input class="hidden" name="finish_procedure">
		     	  <input class="hidden" name="workflow_category">
	            <div data-options="region:'north',split:true" style="height:120px;padding:10px">  
		           <div class="fitem">
		              <label>工作流代码:</label>
		              <input class="easyui-validatebox" type="text" style="width:155px;background-color:#D2D2D2;" name="workflow_code"    readonly="true" ><!--disabled="true"  -->
		               <label>名称:</label>
		             <input class="easyui-validatebox" type="text" style="width:155px;" name="name"  data-options="required:true">
		              <label>类型:</label>
		               <input id="function_type_select_id" class="easyui-combobox"  style="width:155px;" name="workflow_category_display" data-options="
								url:'SYSCODE/WFL_WORKFLOW_CATEGORY',
								method:'post',
								valueField:'code_value',
								textField:'code_value_name',
								required:true,
								onSelect: function(rec){  
								      $('#editForm').form('load',{'workflow_category':rec.code_value}); 
						        }
								">
		           </div>  
		            <div class="fitem">
		              <label>状态:</label>
		               <input class="easyui-combobox"  style="width:155px;"  name="status" data-options="
								method:'post',
								valueField:'status',
								textField:'status_desc',
								data:[{status:'0',status_desc:'有效'},{status:'-1',status_desc:'无效'}]
								">
		            <label>显示界面:</label>
		              <input class="easyui-combobox" type="text" style="width:155px;" name="display_form_display"  data-options="
								url:'ToDoGo.do?actionId=query/combox@form_display&dataSorce=xml/wfl/WFL1000/wfl_workflow_nodes.xml',
								required:true,
								method:'post',
								valueField:'display_form',
								textField:'service_display',
								onSelect: function(rec){  
								      $('#editForm').form('load',{'display_form':rec.display_form}); 
						        }
								">
		              <label>修改界面:</label>
		              <input class="easyui-combobox" type="text" style="width:155px;" name="update_form_display"  data-options="
								url:'ToDoGo.do?actionId=query/combox@form_display&dataSorce=xml/wfl/WFL1000/wfl_workflow_nodes.xml',
								method:'post',
								valueField:'update_form',
								textField:'service_display',
								onSelect: function(rec){  
								      $('#editForm').form('load',{'update_form':rec.update_form}); 
						        }
								">
		           </div>
                    <div class="fitem">   
		                <label>结束时过程:</label>
		               <input class="easyui-combobox"  style="width:155px;"  name="finish_procedure_name" data-options="
								url:'ToDoGo.do?actionId=query/combox@finish_procedure&dataSorce=xml/wfl/WFL1000/wfl_workflow_nodes.xml?workflow_id='+'<%=request.getParameter("workflow_id")%>',
								method:'post',
								valueField:'finish_procedure',
								textField:'proc_display',
									onSelect: function(rec){  
								      $('#editForm').form('load',{'finish_procedure':rec.finish_procedure}); 
						        }
							">
						<label style="margin-bottom:10px;margin-left:10px;" >可回收:</label>
		               <input type="checkbox"   value="1"  name="can_cancel" >		
	               </div>
	            </div>
	         </form> </div>   
	         <div id="tb" style="height:auto;margin:10px;">
			    		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-back'" onclick="closeBack()">返回</a>
			    	    <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveAll()">保存</a>
			    	     <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="test()">test</a>
			  </div>
			  
			<div id="tab-user-right"  class="easyui-tabs" data-options="tabWidth:112" style="width:900px;height:400px">
					<div title="工作流节点" style="margin-left:10px;margin-top:20px;">
						<table id="table_node" style="display:none,width:800px;height:350px"></table>
					</div>
					<div  title="工作流动作" style="margin-left:10px;overflow:hidden">
							<iframe id="first-child" scrolling="yes" frameborder="0"  src="initPage.shtml?uri=wfl/WFL1000/wfl_workflow_action&workflow_id=<%=request.getParameter("workflow_id")%>" style="width:100%;height:100%;"></iframe>
					</div>
					<div title="工作流过程设置" style="margin-left:10px;overflow:hidden">
						<iframe scrolling="yes" frameborder="0"  src="initPage.shtml?uri=wfl/WFL1000/wfl_workflow_procedures&workflow_id=<%=request.getParameter("workflow_id")%>" style="width:100%;height:100%;"></iframe>
					</div>
			</div>
	
 <div id="edit_test_node" title="维护" style="top: 10px; padding: 1px;">
 </div>		
 <script type="text/javascript">
  var g_workflow_id= '<%=request.getParameter("workflow_id")%>';
  var g_node_uri='ToDoGo.do?actionId=query@list&dataSorce=xml/wfl/WFL1000/wfl_workflow_nodes.xml';
  var g_node_save_url="xml/wfl/WFL1000/wfl_workflow_nodes.xml";
  //var g_wfl_save_url="ToDoGo.do?actionId=update@edit&dataSorce=xml/wfl/WFL1000/wfl_workflow.xml";
  var g_wfl_save_url="xml/wfl/WFL1000/wfl_workflow.xml";
  
  
	//form初始化
	$.ajax({
			type: "POST",
			   url: "ToDoGo.do?actionId=query/form@list&dataSorce=xml/wfl/WFL1000/wfl_workflow.xml",
			   data: {workflow_id:g_workflow_id},
			   dataType : 'json', 
			   success: function(msg){
				var rows=msg;
				 //$('#editForm').form('load',rows);
				$('#editForm').formLoad(rows);
			   }, error: function(msg){
				   //debugger;
				   $.messager.alert("提示",msg, "error");
			   }
	}); 
	//form combox 处理
	//  $('#function_type_select_id').combobox({  
//		     onChange:function(newValue,oldText){  //combox 动作赋值
		       //$("#set_of_books_id_id").val(newValue);    
		//       $('#editForm').form('load',{'workflow_category':newValue});
	//	    }
	//	}); 
	/****combox 处理*******************************************************************/   
	function com_init(old_index){
	         var ed = $("#table_node").datagrid('getEditor', {index:old_index,field:'form_name'})
              var ed1 = $("#table_node").datagrid('getEditor', {index:old_index,field:'recipient_type'});
              var ed2 = $("#table_node").datagrid('getEditor', {index:old_index,field:'approval_type'});
    	if(ed!=null||ed1!=null||ed2!=null){
              var form_name_display = $(ed.target).combobox('getText');
    		  var recipient_type_display = $(ed1.target).combobox('getText');
    		  var approval_type_display = $(ed2.target).combobox('getText');
    		   $("#table_node").datagrid('getRows')[old_index]['form_name_display'] = form_name_display;
    		   $("#table_node").datagrid('getRows')[old_index]['recipient_type_display'] = recipient_type_display;
    		   $("#table_node").datagrid('getRows')[old_index]['approval_type_display'] = approval_type_display; 
    	}
	}
	/***********************************************************************/
	//节点维护
	//var old_index=0;
	$("#table_node").datagrid({
		url: g_node_uri,
		queryParams: {
			workflow_id: g_workflow_id
		},
		dataType: 'json',
		columns:[[   
		          {field:'node_id',title:'node_id',checkbox:true },   
		          {field:'sequence_num',title: '序号', width : 70, editor: { type: 'numberbox', options: { required: true} },sortable : true, align: 'center',resizable:true},
		          {field:'name',title: '节点名称', width : 120, editor: { type: 'validatebox', options: { required: true} },sortable : true, align: 'left',resizable:true},
		          {field:'form_name',title:'表单名称',width:120,editor:{
																	type:'combobox',
																	options:{
																		valueField:'display_form',
																		textField:'form_name_display',
																		method:'get',
																		url:'ToDoGo.do?actionId=query/combox@form_display&dataSorce=xml/wfl/WFL1000/wfl_workflow_nodes.xml',
																		required:true,
																		onSelect: function(rec,a,b){  
																			//var aa=$("#table_node").datagrid('getSelected');
																			//var ab=$(this).datagrid('getSelected');
																		     //debugger;
																        }
																	}
																},formatter:function(value,row){
																	return row.form_name_display;
																},align:'center',resizable:true},
		          {field:'recipient_type',title:'接收类型',width:100,editor:{
																type:'combobox',
																options:{
																	valueField:'code_value',
																	textField:'code_value_name',
																	method:'get',
																	url:'SYSCODE/WFL_WORKFLOW_RECIPIENT_TYPE',
																	required:true
																}
															},formatter:function(value,row){
																return row.recipient_type_display;
															},align:'center',resizable:true},
		          {field:'approval_type',title:'审批类型',width:150,editor:{
															type:'combobox',
															options:{
																valueField:'code_value',
																textField:'code_value_name',
																method:'get',
																url:'SYSCODE/WFL_WORKFLOW_APPROVAL_TYPE',
																required:true
															}
														},formatter:function(value,row){
															return row.approval_type_display;
														},align:'center',resizable:true},
		          {field:'childMenus',title:'操作',width:70,align:'center',formatter:function(value,row,index){
						    var html= '<a href="javascript:sub_edit(\'' +index + '\')";>编辑</a>';
						    return html;
					 }}
		      ]],
	 //fitColumns: true,//自适应列宽	
	 //pagination:true,//分页
	 rownumbers:true,//显示行数
	// pageSize:10,
	 //pageList:[10,50,100,500,1000],
	 showFooter:true, //定义是否显示行底
	 striped:true,//显示条纹
	 resizeHandle:'both',
	 singleSelect: false,
	 selectOnCheck: true,
	 checkOnSelect: true,
	 loadMsg : '数据装载中......',
	 onLoadSuccess:function(data){//启用消息提示框   
		    $(this).datagrid("tooltip");    
		}, 
     onLoadError : function() {
           alert('数据加载失败!');
       },
      onClickRow: function(index,rowData){
   	    $(this).gridEdit(index,{
   	    	                            init : function(old_index) {
   	    	                               com_init(old_index);//combox 返回处理
									}
				      });//编辑  
	  },	
      //title:"工作流定义",
     toolbar : [ {text : '添加', iconCls : 'icon-add',handler :function(){ edit_buttion1('add');}
       }, '-', {text : '保存', iconCls : 'icon-save',handler : function(){edit_buttion1('save')}
	   }, '-', {text : '删除', iconCls : 'icon-remove',handler : function(){edit_buttion1('del')}
       }, '-', {text : '清除', iconCls : 'icon-tip',handler : function(){edit_buttion1('clear')}
       } ]
	}).datagrid("columnMoving");
	
	
	function edit_buttion1(action){
		debugger;
		//var action=callback.currentTarget.text;
		if (action=='add'){
			 $("#table_node").gridAdd({workflow_id: g_workflow_id},{
								                    init : function(old_index) {
								                         com_init(old_index);//combox 返回处理
													}
			     });
		} else if(action=='del'){
			 $("#table_node").gridRemove(g_node_save_url);
		}else if(action=='save'){
			 $("#table_node").gridSave(g_node_save_url);
		}else if(action=='clear'){
			 $("#table_node").gridClean();
		}
			
}
	
	//function sub_edit(row){
		//var record= $('#table_node').datagrid('getRows')[index];
		//$('#table_node').datagrid('unselectRow', index);
		//openwin(row);
	//}	
	function sub_edit(index){
		var v_node_id=$("#table_node").datagrid('getRows')[index]['node_id'];
		debugger;
	    if(v_node_id==null||v_node_id==''||v_node_id=="undefined"){
	    	  $.messager.alert("提示","请先保存数据!", "error");
	 	      return;
	 	 }else{
			//debugger;
			//var v_node_id=record['node_id'];
			//var v_node_id=row.node_id;
			//window.open("initPage.shtml?uri=wfl/WFL1000/wfl_workflow_edit_node&node_id="+v_node_id+"&workflow_id="+g_workflow_id);
			//window.location.href="initPage.shtml?uri=wfl/WFL1000/wfl_workflow_edit_detail&workflow_id="+v_workflow_id;
			//编辑框加载数据
				 $("#edit_test_node").window({
		               width: 960,
		                modal: true,
		               height: 700,
		               iconCls:'icon-edit',
		              href:"initPage.shtml?uri=wfl/WFL1000/wfl_workflow_edit_node&node_id="+v_node_id+"&workflow_id="+g_workflow_id
		              });
	 	  }
	}	
	
	//保存
  function saveAll(){
		//form 保存
	   var return_sr=$('#editForm').formSave(g_wfl_save_url,'edit');
	//2节点grid 保存
		if(return_sr){
			//工作流节点保存
			var return_sr1= $("#table_node").gridSave(g_node_save_url);
			if(return_sr1){
			   $.messager.alert("提示", "操作成功!", "info");
			}
		}
		
  }

  
  function test(){
	  debugger;
	var iObj=document.getElementById('first-child').contentWindow;  
	var b=iObj.document.getElementById('action_table_id');  
      var a=$(b).gridSave('xml/wfl/WFL1000/wfl_workflow.xml','action_edit');
      debugger;
  }
  
	
  function closeBack()//返回
   	 {
   		   //$("#edit_test").window('close'); 
		window.location.href="initPage.shtml?uri=wfl/WFL1000/wfl_workflow_edit";
   	 }
        
    </script>    
  <!--</div>     -->	
 <!--end Edit Win&From -->	
</body>
</html>