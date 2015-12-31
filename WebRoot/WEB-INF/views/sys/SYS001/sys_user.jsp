<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@include file="/view/base/resource.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>用户定义</title>
</script>
</head>
<body>
<div class="easyui-panel" title="查询条件" style="width:700px">
<form id="queryForm" class="ui-form" method="post"> 
	            <div data-options="region:'north',split:true" style="padding:5px">  
	              <!-- <div class="ftitle">维护信息</div>  -->
	              
		            <div class="fitem">
						<label>用户名:</label>
						<input class="easyui-validatebox"   style="width:155px;" name="user_name"  >	
						<label>描述:</label>
		                <input class="easyui-validatebox"  style="width:155px;" name="description" >	
		           </div>  
		            <div class="fitem">
						<label>员工代码:</label>
						<input class="easyui-validatebox"   style="width:155px;" name="employee_code"  >	
						<label>姓名:</label>
		                <input class="easyui-validatebox"  style="width:155px;" name="employee_name" >	
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
	<table id="sys_user_table_id"  title="用户定义" class="easyui-datagrid" style="width:auto;height:350px"
         data-options="
			  iconCls: 'icon-edit',
			  pagination:true,
		      fitColumns: true,
		     rownumbers:true,
		     collapsible:true,
		     url:'ToDoGo.do?actionId=query@load&dataSorce=xml/sys/SYS001/sys_user_edit.xml'
			">
		<thead>
		    <tr><th data-options="field:'ck',checkbox:true">ck</th>
		          <th data-options="field:'user_name'">用户名</th>
				  <th data-options="field:'description',width:100,sortable:true,resizable:true">描述</th>
				  <th data-options="field:'start_date',width:100,sortable:true,resizable:true">启用日期</th>
				  <th data-options="field:'end_date',width:100,resizable:true,align:'center'">停止日期</th>
				  <th data-options="field:'p_frozen_flag',width:100,resizable:true, align:'center'">冻结</th>
				  <th data-options="field:'frozen_date',width:100,resizable:true,align:'center'">冻结日期</th>
				  <th data-options="field:'employee_code',width:100">所属员工</th>
				  <th data-options="field:'employee_name',width:100">员工姓名</th>
				  <th data-options="field:'assign_role',width:100,formatter:ass_role">角色分配</th>
				  <!-- <th data-options="field:'edit',width:100">编辑</th> -->
		       </tr>
		</thead>
	</table>
<script type="text/javascript">
var g_table_record="";
var g_queryForm_id='#queryForm';
var g_table_id='#sys_user_table_id';
var g_table_uri='ToDoGo.do?actionId=query@load&dataSorce=xml/sys/SYS001/sys_user_edit.xml';

var g_combox_url="initPage.shtml?uri=sys/SYS001/employee_comlov";
var g_update_user_url="ToDoGo.do?actionId=update@edit&dataSorce=xml/sys/SYS001/sys_user_edit.xml";
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
	
//预定义		
//Grid 工具类
	   //Grid DataList
	var Grid = $(g_table_id);
	var Utils = {
		getCheckedRows : function(){
			return Grid.datagrid('getChecked');			
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
//end 预定义		
	
var alert_flag=0;
$(g_table_id).datagrid({
	         //url: g_table_uri,
	         // queryParams: {function_id:g_function_id},
	        singleSelect: true,
			onLoadSuccess:function(data){//启用消息提示框   
			    $(g_table_id).datagrid("tooltip");    
			}, 
		     onLoadError : function(err,a) {
		    	 if(alert_flag==0)$.messager.alert("提示", err.responseText+a, "error");
		    	  alert_flag=1;
		       },
		       toolbar : [ {text : '添加', iconCls : 'icon-add',handler : function(){edit_buttion('add')}
		       }, '-', {text : '编辑', iconCls : 'icon-edit',handler : function(){edit_buttion('edit')}
		       } ]
		});
function edit_buttion(action){
	//var action=callback.currentTarget.text;
	if (action=='add'){
		var records =[];
		//var date=new Date();
		//debugger;
		 records['encrypted_foundation_password']=1;
		 records['encrypted_user_password']=1;
		 openwin(records);
		//append();
	}else if(action=='edit'){
		var records = Utils.getCheckedRows();
		if (Utils.checkSelectOne(records)){
			openwin(records[0]);
		}	
	
	}
	
}

function openwin(record){
	//debugger;
	$('#editForm').form('reset');
	$('#editForm').form('load',record);
	$('#edit-win').window('open');
	//编辑框加载数据	
}

//角色分配
function ass_role(value,row,index){
	var html= '<a href="javascript:sub_edit(\'' + index + '\')";>角色分配(' + row.sub_count + ')</a>';
	return html;
}
function sub_edit(index){
	//debugger;
	var record= $(g_table_id).datagrid('getRows')[index];
	$(g_table_id).datagrid('unselectRow', index);
	show(record);
}

function show(record){
	g_table_record=record;
	var user_id=g_table_record['user_id'];
	//alert(user_id);
	 $("#edit_role").window({
         width: 780,
          modal: true,
         height: 460,
         iconCls:'icon-edit',
        href:"initPage.shtml?uri=sys/SYS001/sys_user_role_assign&user_id="+user_id
        });
}
/////////////////////////end 行编辑


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
     <!-- Edit Win&Form -->
     <div id="edit-win" class="easyui-dialog" title="编辑" data-options="closed:true,iconCls:'icon-save',modal:true" style="width:570px;height:380px;">  
     	<form id="editForm" class="ui-form" method="post">  
     		 <input class="hidden" name="user_id">
     		 <input id="employee_id_id" class="hidden" name="employee_id">
     		 <div class="ui-edit">
		     	   <div class="ftitle">用户编辑</div>    
		           <div class="fitem">  
		               <label>用户名:</label>  
		               <input class="easyui-validatebox" type="text" name="user_name" data-options="required:true">
		               <label>描述:</label>  
		               <input class="easyui-validatebox" type="text" name="description" data-options="required:true">
		           </div>  
		            <div class="fitem">  
		                <label>启用日期:</label>  
		               <input  class="easyui-datebox" type="text" name="start_date"  data-options="required:true">
		           </div> 
		              <div class="fitem">  
		               <label>停止日期:</label>  
		               <input  class="easyui-datebox" type="text" name="end_date" >
		           </div> 
		             <div class="fitem">  
		               <label>所属员工:</label>  
		                <input id="employee_code_id"  class="easyui-combobox"  type="text"  name="employee_code" >
		                <label>员工姓名:</label>  
		                <input class="easyui-validatebox" type="text"  name="employee_name"  disabled="true"> <!--  disabled = "disabled"  -->
		           </div> 
		            <div class="fitem">  
		                <label>密码:</label>  
		                <input class="easyui-validatebox" type="password"   name="encrypted_foundation_password"  data-options="required:true">
		           </div> 
		            <div class="fitem">  
		                <label>重复密码:</label>  
		                <input class="easyui-validatebox" type="password"   name="encrypted_user_password"   data-options="required:true">
		           </div> 
		            <div class="fitem">  
		               <label>冻结标志:</label>  
		               <input class="easyui-validatebox"  type="checkbox"  name="frozen_flag"  value="Y" >
		           </div> 
		           <div class="fitem">  
		                <label>冻结日期:</label>  
		               <input  class="easyui-datebox" type="text"  name="frozen_date" >
		           </div> 
	         </div>
     	</form>
     	<div id="toolbar"  style="margin-right:50px;margin-top:30px;float:right">  
			<a href="javascript:void(0)" id='addLine_btn' class="easyui-linkbutton" data-options="iconCls:'icon-ok'"  onclick="saveform()">保存</a>  
	     </div> 
  	 </div> 
</div>

<!-- lov面板 -->	
<div id="edit_test_open" title="lov" ></div>
 <!-- end lov面板 -->
 <!-- 角色分配 -->
 <div id="edit_role" title=" 角色分配" style="top: 10px; padding: 1px;">
   </div>
   <!-- end角色分配 -->
<script type="text/javascript">

  function saveform(){
	  /*$("input[type=checkbox]","#editForm").each(function(){
		  alert(this.name);
		 });*/
	/* var checkbox="";
	  $("input[type=checkbox]","#editForm").each(function(){//checkbox 需要特殊处理
		  if(this.name=='frozen_flag'){
			  checkbox=$(this).serializeArray();
			  debugger;
		  }
		 });*/
	  var formrecord=$('#editForm').form('serialize');
		if(!formrecord['frozen_flag']){//checkbox 需要特殊处理
			formrecord['frozen_flag']="";
		}
		//校验密码
		var password=formrecord['encrypted_foundation_password'];
		var re_password=formrecord['encrypted_user_password'];
		if(password!=re_password||password==""||re_password==""){
			   $.messager.alert("提示", "输入密码不匹配!!", "error");
			   return;
		}
		//校验必输域
		 if(!$('#editForm').form('validate'))
		{
			return; 
	     }
		var v_user_id=formrecord['user_id'];
	     var action_id="";
			if(v_user_id==null||v_user_id==undefined||v_user_id==''){
				 //新增
					action_id="add";
				}else
				{//修改
					action_id="edit";
				}
		debugger;
       var rows="["+JSON.stringify(formrecord)+"]";   //对象数组转换为json
	     $.ajax({
			   type: "POST",
			   async: false, //同步请求
			   url: "ToDoGo.do?actionId=update@"+action_id+"&dataSorce=xml/sys/SYS001/sys_user_edit.xml",
			   data: { _para:rows},// _para 代表数组json数据传入，为内定参数
			   dataType : 'json', 
			   success: function(data){
				   $.messager.alert("提示", "操作成功!", "info");
					$(g_table_id).datagrid({url: g_table_uri});//刷新grid  定位当前页
			   }, error: function(err){
				   EyMs.alert('提示',err.responseText,'error');  
			   }
		});
  }

  $('#employee_code_id').combobox({
		 onShowPanel:function(){
			 $('#employee_code_id').combobox('hidePanel');
			 $("#edit_test_open").window({
		         width: 580,
		          modal: true,
		          height: 490,
		         title:"lov查询",
		         iconCls:'icon-search',
		         href: g_combox_url,
		         onClose:function(){ 
		        	 var lov_data=window.lov_record;//接收lov选择的值
				        	if( lov_data==null || lov_data==undefined ||lov_data==''){}//说明没有选择值，直接关闭
				        	 else{
				        		 $('#editForm').form('setValue',{
				        			 'employee_id':lov_data['employee_id'],
				        			 'employee_code':lov_data['employee_code'],
				        			 'employee_name':lov_data['name']
				        			 });	 
					       //  $("#employee_id_id").val(lov_data['service_id']);
					       //  $("#employee_code_id").combobox('setValue',lov_data['service_name']);
				         }
		             }
		        });
		 }
	});
  
</script>    


</body>
</html>