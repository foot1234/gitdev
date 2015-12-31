<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@include file="/view/base/resource.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>

 <!-- Edit Win&From ****************************************************************************************************************8-->
     	<form id="showForm" class="ui-form" method="post"> 
	              <!-- <div class="ftitle">维护信息</div>  --> 
		           <div class="fitem">
		              <label>员工代码:</label>
		              <input class="easyui-validatebox" type="text" style="width:155px;" name="employee_code"  disabled="true">
		              <label>姓名:</label>
		             	<input class="easyui-validatebox" type="text" style="width:155px;" name="name"  disabled="true">
		           </div>  
	            <div id="toolbar12"  style="margin-left:20px;margin-bottom:10px;margin-top:30px;">  
			               <a href="javascript:void(0)" id='addLine_btn' class="easyui-linkbutton" data-options="iconCls:'icon-back'"  onclick="closeBack()" >返回</a>  
			    </div> 
	         </form>
			 	<table id="dg1we" class="easyui-datagrid" title="页面分配" style="width:auto;height:300px">
		        <thead>
		            <tr>
		             <th data-options="field:'rn',checkbox:true">rn</th>
		              <th data-options="field:'employee_id',hidden:true">employee_id</th>
		              <th data-options="field:'exp_employee_accounts_id',hidden:true">exp_employee_accounts_id</th>
		              <th data-options="field:'line_number',width:40,editor:{type:'numberbox',options: { required: true} }">行号</th><!--editor:'text'  -->
				      <th data-options="field:'bank_code',width:100,editor:{type:'validatebox'}">银行代码</th><!--editor:'text'  -->
			          <th data-options="field:'bank_name',width:100,editor:{type:'validatebox'}">银行名称</th>
			          <th data-options="field:'bank_location_code',width:100,editor:{type:'validatebox'}">银行地点代码</th><!--editor:'text'  -->
			          <th data-options="field:'bank_location',width:100,editor:{type:'validatebox'}">银行地点</th>
			          <th data-options="field:'account_number',width:100,editor:{type:'validatebox',options: {required: true} }">银行账号</th><!--editor:'text'  -->
			          <th data-options="field:'account_name',width:100,editor:{type:'validatebox',options: {required: true} }">户名</th>
			          <th data-options="field:'enabled_flag',width:100,resizable:true,align:'center',formatter: checkbox_c,editor: { type: 'checkbox', options: { on: 'Y', off: 'N'} }">启用</th>
			          <th data-options="field:'notes',width:100,editor:{type:'validatebox'}">备注</th>
				  	 </tr>
		        </thead>
		    </table>


 		
 <script type="text/javascript">
  var g_employee_id= '<%=request.getParameter("employee_id")%>';
 // alert(g_employee_id);
  var g_record=window.g_temp_record;
  var g_sub_table_id="#dg1we";
  var g_role_data='ToDoGo.do?actionId=query@accounts&dataSorce=xml/exp/exp_employee_accounts.xml';
  var g_role_combox_url="initPage.shtml?uri=sys/SYS001/sys_role_comlov";
  var g_com_combox_url="initPage.shtml?uri=sys/SYS001/fnd_com_comlov";
  
  function checkbox_c (value, rowData, rowIndex){
	     return value == 'Y' ? '<input  name="is_access_checked" type="checkbox" checked  >': '<input name="is_access_checked" type="checkbox"  >';
	}
  
  
$(function() {  
	//form初始化
	$('#showForm').form('load',g_record);
	  var alert_flag1=0; 
	  $("#dg1we").datagrid({
		     url: g_role_data,
		     method: 'get',
	         queryParams: {employee_id:g_employee_id},
			  pagination:true,
		      fitColumns: true,
		      rownumbers:true,
		      collapsible:true,
			  onLoadSuccess:function(data){//启用消息提示框   
				$(g_sub_table_id).initdata(data);//保存原始数据
			    $(g_sub_table_id).datagrid("tooltip");    
			    
			  debugger;
			  }, 
		      onLoadError : function(err,a) {
		    	 if(alert_flag1==0)$.messager.alert("提示", err.responseText+a, "error");
		    	 alert_flag1=1;
		      },
		     toolbar : [ {text : '添加', iconCls : 'icon-add',handler : add_edit12
		     }, '-', {text : '保存', iconCls : 'icon-save',handler : add_edit12
		    }, '-', {text : '删除', iconCls : 'icon-remove',handler : add_edit12
		    }]
		}).datagrid('_enableRowEditing');   
  });
  function add_edit12(callback){
	var action=callback.currentTarget.text;
		if ($.trim(action)=='添加'){
			   append();
		}else if ($.trim(action)=='保存'){
			  if($('#dg1we')._checkSave()){
				  var saveData=$('#flex1')._getDataChanges();//获取
	               var inserted = saveData["inserted"];
			       var deleted = saveData["deleted"];
			       var updated = saveData["updated"];
		        debugger;
		        var return_flag=true;
		           if (deleted.length) {
		        	   return_flag=update_post(deleted,'del');// 执行删除
		               }
			      if (updated.length) {
			    	  return_flag=update_post(updated,'edit');// 执行更新
			         }
		          if (inserted.length) {
		        	  return_flag=update_post(inserted,'add');// 执行插入
		        	  }
		          $(g_sub_table_id).datagrid('acceptChanges'); //界面数据提交
		           if(return_flag){
		        	   $.messager.alert("提示", "操作成功!", "info");
		           }
			  }else{
				
			  }
		}else if ($.trim(action)=='删除'){
			 var rows = $('#dg1we').datagrid('getChecked');
			  for(var i=0;i<rows.length;i++){
        		  var index=$('#dg1we').datagrid('getRowIndex',rows[i]);
        		  $('#dg1we').datagrid('deleteRow', index);
              }
          // $('#dg1we').datagrid('acceptChanges'); //界面数据提交
		}
			
   }
  



  function update_post(records,action_id){
		if(records.length > 0){
				var rows=JSON.stringify(records);   //对象数组转换为json
				var return_s=false;
				debugger;
			    $.ajax({
						   type: "POST",
						   async: false, //同步请求
						   url: "ToDoGo.do?actionId=update/batch@"+action_id+"&dataSorce=xml/exp/exp_employee_accounts.xml",
						   data: { _para:rows},// _para 代表数组json数据传入，为内定参数
						   dataType : 'json', 
						   success: function(data){
							 //  debugger;
							   //EyMs.alert('提示',data.msg,'info');    
							   return_s= true;
						   }, error: function(err){
							   EyMs.alert('提示',err.responseText,'error');  
							   return_s= false;
						   }
					});
			     return return_s;
			}
	  }
  
  
  

 
 function append(){
	// $('#dg1we').datagrid('insertRow',{index:0,row:{user_id:g_user_id}});
	 $('#dg1we').datagrid('appendRow',{employee_id:g_employee_id});
	 
	   // if (endEditing()){
	        //$('#dg').datagrid('appendRow',{function_id:g_function_id});
	    //    $('#dg1we').datagrid('insertRow',{index:0,row:{user_id:g_user_id}
	   //       });
	//    }
	//    $('#dg1we').datagrid('updateRow',{index:0,row: {}});//实现一次可以多增几行
	}
  
  function closeBack()//返回
   {
	 $("#edit_test").dialog('close'); 
	}	  
    </script>    
</body>
</html>