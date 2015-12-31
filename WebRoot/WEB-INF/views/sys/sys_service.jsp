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
						<label>页面:</label>
						<input class="easyui-validatebox"   style="width:155px;" name="service_name"  >	
						<label>标题:</label>
		                <input class="easyui-validatebox"  style="width:155px;" name="title" >	
		           </div>  
		             <div class="fitem">
		             <label style="margin-bottom:10px;" >权限控制:</label>
		               <input type="checkbox"   value="1"  style="width:30px;" name="is_access_checked" ><!--checked="checked"   -->
		             <label style="margin-bottom:10px;" >需要登录:</label>
		               <input type="checkbox"  value="1"   style="width:30px;"  name="is_login_required" >
		               <label style="margin-bottom:10px;" >系统级页面:</label>
		               <input type="checkbox"   value="1"  name="is_system_access" >
		           </div>  
                    <div class="fitem">
	                  <label >模糊查询(%):</label><!-- style="margin-bottom:15px;"  -->
		              <input id="query_text_id"  class="easyui-searchbox"  name="query_text"  data-options="width:416,searcher:querys,prompt:'请输入条件,以%开始或结束'"  type="text" />
	               </div>
	            </div>
	         </form>
  </div>
      <div  style="margin-left:20px;margin-bottom:10px;">  
			<a href="javascript:void(0)" id='addLine_btn' class="easyui-linkbutton" data-options="iconCls:'icon-search'"  onclick="querys()" >查询</a>  
			<a href="javascript:void(0)" id='addLine_btn' class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="reset()"  >重置</a>  
    </div> 
	<table id="service_table_id"  title="页面注册" class="easyui-datagrid" style="width:auto;height:350px"
         data-options="
			  iconCls: 'icon-edit',
			  pagination:true,
		      fitColumns: true,
		     rownumbers:true,
		     collapsible:true
			">
		<thead>
		    <tr><th data-options="field:'ck',checkbox:true">ck</th>
		          <th data-options="field:'service_id',hidden:true">service_id</th>
				  <th data-options="field:'service_name',width:200,sortable:true,resizable:true,editor: { type: 'validatebox', options: { required: true} }">页面</th>
				  <th data-options="field:'title',width:100,sortable:true,resizable:true,editor:'text'">标题</th>
				  <th data-options="field:'is_access_checked',width:100,resizable:true,align:'center',formatter: checkbox_c,editor: { type: 'checkbox', options: { on: 1, off: 0 } }">权限控制</th>
				  <th data-options="field:'is_login_required',width:100,resizable:true, align:'center',formatter:checkbox_r,editor: { type: 'checkbox', options: { on: 1, off: 0 } }">需要登录</th>
				  <th data-options="field:'is_system_access',width:100,resizable:true,align:'center',formatter:checkbox_s,editor: { type: 'checkbox', options: { on: 1, off: 0 } }">系统级页面</th>
				  <th data-options="field:'is_entry_page',width:100,hidden:true">is_entry_page</th>
		       </tr>
		</thead>
	</table>
<script type="text/javascript">
var g_queryForm_id='#queryForm';
var g_table_id='#service_table_id';
var g_table_uri='ToDoGo.do?actionId=query@load&dataSorce=xml/sys/sys_service.xml';
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
	
//grid checkbox格式化
function checkbox_c (value, rowData, rowIndex){
     return value == 1 ? '<input  name="is_access_checked" type="checkbox" checked  >': '<input name="is_access_checked" type="checkbox"  >';
}
function checkbox_r (value, rowData, rowIndex){
	  return value == 1 ? '<input  name="is_login_required" type="checkbox" checked  >': '<input name="is_login_required" type="checkbox"  >';
}
function checkbox_s (value, rowData, rowIndex){
	  return value == 1 ? '<input name="is_system_access" type="checkbox" checked >': '<input name="is_system_access" type="checkbox" >';
}



	
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
		       toolbar : [ {text : '添加', iconCls : 'icon-add',handler :  function(){edit_buttion('add')}
		       }, '-', {text : '删除', iconCls : 'icon-remove',handler :  function(){edit_buttion('del')}
		       }, '-', {text : '保存', iconCls : 'icon-save',handler :  function(){edit_buttion('save')}
		       } ]
		});
function edit_buttion(action){
	//var action=callback.currentTarget.text;
	if (action=='add'){
		append();
	}else if(action=='del'){
		remove();
	}else if(action=='save'){
		 debugger;
			  if(cheak_save()){
		        var inserted = $(g_table_id).datagrid('getChanges', "inserted");
		        var deleted = $(g_table_id).datagrid('getChanges', "deleted");
		        var updated = $(g_table_id).datagrid('getChanges', "updated");  
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
		          $(g_table_id).datagrid('acceptChanges'); //界面数据提交
		           if(return_flag){
		        	   querys();
		        	   $.messager.alert("提示", "操作成功!", "info");
		           }
			  }else{
				  $.messager.alert("提示", "没有数据需要保存!", "error");
			  }
	}
}
 function cheak_save()
 {  
	 var allRow=$(g_table_id).datagrid('getRows');
	  for(var i=0;i<allRow.length;i++){
		  var index=$(g_table_id).datagrid('getRowIndex', allRow[i]);
		  $(g_table_id).datagrid('endEdit', index);//关闭最后一行
	  } 
	 
	   var rows = $(g_table_id).datagrid('getChanges');
	   debugger;
	   var flag=false;
	   var check_flag=false;
	    //保存验证
		    for(var i=0;i<rows.length;i++){
		    	var index=$(g_table_id).datagrid('getRowIndex', rows[i]);
		    	$(g_table_id).datagrid('selectRow', index);
		    	
		    	
		        if($(g_table_id).datagrid('validateRow', index))
		        {
		        	check_flag=true;
		        }else
		        {
		        	check_flag=false;
		        	break;
		        }
		     
		    }
		    if(check_flag==true){
		    	flag=true;
		    }
	   return flag;
 }
 


 function update_post(records,action_id){
		if(records.length > 0){
				var rows=JSON.stringify(records);   //对象数组转换为json
				var return_s=false;
			     $.ajax({
						   type: "POST",
						   async: false, //同步请求
						   url: "ToDoGo.do?actionId=update/batch@"+action_id+"&dataSorce=xml/sys/sys_service.xml",
						   data: { _para:rows},// _para 代表数组json数据传入，为内定参数
						   dataType : 'json', 
						   success: function(data){
							   debugger;
							   //EyMs.alert('提示',data.msg,'info');    
							   return_s= true;
						   }, error: function(err){
							   debugger;
							   EyMs.alert('提示',err.responseText,'error');  
							   return_s= false;
						   }
					});
			     return return_s;
			}
	  }
 

//**行编辑开始 gridedit ***********************************************************************//        
 $(g_table_id).datagrid().datagrid('_enableCellEditing');
//新增       
function append(){
    $(g_table_id).datagrid('insertRow',{index:0,row:{is_access_checked:1,is_login_required:1}});
}
//删除
function remove(){
	 var rows = $(g_table_id).datagrid('getSelections');
	 //选择要删除的行
        if (rows.length > 0) {
            $.messager.confirm("提示", "你确定要删除吗?", function (cmp) {
           	if(cmp){
           		 for(var i=0;i<rows.length;i++){
		        		  var index=$(g_table_id).datagrid('getRowIndex',rows[i]);
		        		  $(g_table_id).datagrid('deleteRow', index);
		             }
           	    //$(g_table_id).datagrid('acceptChanges'); //界面数据提交
           		 var deleted = $(g_table_id).datagrid('getChanges', "deleted");
           	    debugger;
           		 if (deleted.length) {
           			 if(update_post(deleted,'del')){// 执行删除
	                    	 $.messager.alert("提示", "操作成功!", "info");
	                     } 
     	               } 
			      
			     
		       }  
        });
    }
    else {
        $.messager.alert("提示", "请选择要删除的行!", "error");
    }
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
</body>
</html>