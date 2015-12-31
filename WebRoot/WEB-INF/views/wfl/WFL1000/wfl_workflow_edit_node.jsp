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
 	<form id="edit_node_id" class="ui-form" method="post"> 
     	 <!-- 隐藏文本框 -->
		     	 <input class="hidden" name="workflow_id">
		     	 <input class="hidden" name="node_id">
		     	  <input class="hidden" name="name_id">
		     	 <input class="hidden" name="approval_type">
		     	 <input class="hidden" name="recipient_type">
		     	  <input class="hidden" name="form_name">
	            <div data-options="region:'north',split:true" style="height:120px;padding:10px">  
		           <div class="fitem">
		              <label>节点名称:</label>
		              <input class="easyui-validatebox" type="text" style="width:155px;" name="name"  data-options="required:true">
		               <label>序列号:</label>
		             <input class="easyui-numberbox"  type="number" style="width:155px;" name="sequence_num"  data-options="required:true,min:0,max:9999,missingMessage:'数字域必须填写0~9999之间的数'">
		              <label>接收类型:</label>
		               <input id="recipient_type_select_id" class="easyui-combobox"  style="width:155px;" name="recipient_type_display" data-options="
								url:'SYSCODE/WFL_WORKFLOW_RECIPIENT_TYPE',
								method:'post',
								valueField:'code_value',
								textField:'code_value_name',
								required:true,
								onSelect: function(rec){  
								      $('#edit_node_id').form('load',{'recipient_type':rec.code_value}); 
						        }
								">
		           </div>  
		            <div class="fitem">
		              <label>审批类型:</label>
		                <input id="function_type_select_id" class="easyui-combobox"  style="width:155px;" name="approval_type_display" data-options="
								url:'SYSCODE/WFL_WORKFLOW_APPROVAL_TYPE',
								method:'post',
								valueField:'code_value',
								textField:'code_value_name',
								required:true,
								onSelect: function(rec){  
								      $('#edit_node_id').form('load',{'approval_type':rec.code_value}); 
						        }
								">
		               <label>表单名称:</label>
		               <input class="easyui-combobox"   type="text" style="width:155px;" name="form_name_display"  data-options="
								url:'ToDoGo.do?actionId=query/combox@form_display&dataSorce=xml/wfl/WFL1000/wfl_workflow_nodes.xml',
								method:'post',
								valueField:'display_form',
								textField:'form_name_display',
									onSelect: function(rec){  
								      $('#editForm').form('load',{'form_name_display':rec.form_name_display}); 
						        }
							">
		           </div>
                    <div class="fitem" style="margin-top:10px;">   
						<label style="margin-bottom:10px;margin-left:60px;" >邮件提醒:</label>
		               <input type="checkbox"   value="1"    name="mail_notify" >		
		               	<label style="margin-bottom:10px;margin-left:60px;" >无需重复审批:</label>
		               <input type="checkbox"   value="1"     name="can_auto_pass" >		
		               	<label style="margin-bottom:10px;margin-left:60px;" >节点允许无审批人:</label>
		               <input type="checkbox"   value="1"    name="can_no_approver" >		
		               	<label style="margin-bottom:10px;margin-left:60px;" >允许添加审批人:</label>
		               <input type="checkbox"   value="1"    name="can_add_approver" >		
	               </div>
	                 <div class="fitem" style="margin-top:10px;">   
		               	<label style="margin-bottom:10px;margin-left:60px;" >是否可以转交:</label>
		               <input type="checkbox"   value="1"    name="can_deliver_to" >	
		                <label style="margin-bottom:10px;margin-left:60px;" >提交人无需审批:</label>
		               <input type="checkbox"   value="1"    name="is_self_re_commit" >		
	               </div>
	            </div>
	         </form> </div>   
	         <div id="tb_edit" style="height:auto;margin:10px;">
			    		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-back'" onclick="closeBack1()">返回</a>
			    		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="save_edit_All()">保存</a>
			  </div>
			  
			<div class="easyui-tabs" data-options="tabWidth:112" style="width:900px;height:400px">
					<div title="审批人" style="margin-left:10px;margin-top:20px;">
						<table id="table_node_edit_id"  style="width:880;height:330px"></table>
					</div>
					<div title="动作" data-options="closable:false" style="margin-left:10px;overflow:hidden">
							<iframe scrolling="yes" frameborder="0"  src="initPage.shtml?uri=wfl/WFL1000/wfl_workflow_node_action&workflow_id=<%=request.getParameter("workflow_id")%>&node_id=<%=request.getParameter("node_id")%>" style="width:100%;height:100%;"></iframe>
					</div>
					<div title="节点后处理" style="margin-left:10px;overflow:hidden">
						<iframe scrolling="yes" frameborder="0"  src="initPage.shtml?uri=wfl/WFL1000/wfl_workflow_procedures&workflow_id=<%=request.getParameter("workflow_id")%>" style="width:100%;height:100%;"></iframe>
					</div>
			</div>
		
 <script type="text/javascript">
  var g_workflow_id_edit= '<%=request.getParameter("workflow_id")%>';
  var g_node_id_edit= '<%=request.getParameter("node_id")%>';
  var g_node_uri_edit='ToDoGo.do?actionId=query@load&dataSorce=xml/wfl/wfl_node_recipient_set.xml';
  var g_node_edit_save_url='xml/wfl/WFL1000/wfl_workflow_nodes.xml';
	//form初始化
	$.ajax({
			type: "POST",
			   url: "ToDoGo.do?actionId=query/form@list&dataSorce=xml/wfl/WFL1000/wfl_workflow_nodes.xml",
			   data: {workflow_id:g_workflow_id_edit,
				          node_id:g_node_id_edit},
			   dataType : 'json', 
			   success: function(rows){
				   //debugger;
				 $('#edit_node_id').form('load',rows);
			   }, error: function(msg){
				   //debugger;
				   $.messager.alert("提示",msg, "error");
			   }
	});  

	//节点维护
	$("#table_node_edit_id").datagrid({
		url: g_node_uri_edit,
		queryParams: {
			workflow_id: g_workflow_id_edit,
			node_id:g_node_id_edit
		},
		dataType: 'json',
		columns:[[   
		          {field:'node_id',title:'node_id',checkbox:true },   
		          {field:'rule_sequence',title: '序号',  editor: { type: 'numberbox', options: { required: true} },width : 70, sortable : true, align: 'center',resizable:true},
		          {field:'rule_code_display',title: '审批规则', width : 120, editor:{
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
														return row.rule_code_display;
													},sortable : true, align: 'left',resizable:true},
		          {field:'recipient_sequence',title:'审批顺序', editor: { type: 'numberbox', options: { required: true} },width:120,align:'center',resizable:true},
		          {field:'parameter_1_value',title:'参数1',width:100,align:'center',resizable:true},
		          {field:'parameter_1_desc',title:'描述',width:100,align:'center',resizable:true},
		          {field:'parameter_2_value',title:'参数2',width:100,align:'center',resizable:true},
		          {field:'parameter_2_desc',title:'描述',width:100,align:'center',resizable:true},
		          {field:'parameter_3_value',title:'参数3',width:100,align:'center',resizable:true},
		          {field:'parameter_3_desc',title:'描述',width:100,align:'center',resizable:true},
		          {field:'parameter_4_value',title:'参数4',width:100,align:'center',resizable:true},
		          {field:'parameter_4_desc',title:'描述',width:100,align:'center',resizable:true}
		      ]],   
	 fitColumns: true,//自适应列宽	
	 pagination:true,//分页
	 rownumbers:true,//显示行数
	 pageSize:10,
	 pageList:[10,50,100,500,1000],
	 showFooter:true, //定义是否显示行底
	 striped:true,//显示条纹
	 resizeHandle:'both',
	 singleSelect: false,
	 selectOnCheck: true,
	 checkOnSelect: true,
	 loadMsg : '数据装载中......',
	 onClickRow: function(index,rowData){
	   	    $(this).gridEdit(index,{
	   	    	                            init : function(old_index) {
	   	    	                               //com_init(old_index);//combox 返回处理
										}
					      });//编辑  
	 },	
     onLoadError : function() {
           alert('数据加载失败!');
       },
     onLoadSuccess:function(data){//启用消息提示框   
			    $(this).datagrid("tooltip");    
	   }, 
      //title:"工作流定义",
     toolbar : [ {text : '添加', iconCls : 'icon-add',handler : edit_buttion2
       }, '-', {text : '删除', iconCls : 'icon-remove',handler : edit_buttion2
       } ]
	}).datagrid("columnMoving");
	
	function edit_buttion2(callback){
		 
}

	//保存
	  function save_edit_All(){
		debugger;
			//form 保存
		   var return_sr=$('#edit_node_id').formSave(g_node_edit_save_url,'edit_detail');
		//2节点grid 保存
			if(return_sr){
				//工作流节点保存
				var return_sr1= $("#table_node_edit_id").gridSave(g_node_edit_save_url);
				if(return_sr1){
				   $.messager.alert("提示", "操作成功!", "info");
				}
			}
			
	  }
	
  function closeBack1()//返回
   	 {
   		  $("#edit_test_node").window('close'); 
		//window.location.href="initPage.shtml?uri=wfl/WFL1000/wfl_workflow_edit";
   	 }
        
    </script>    
  <!--</div>     -->	
 <!--end Edit Win&From -->	
</body>
</html>