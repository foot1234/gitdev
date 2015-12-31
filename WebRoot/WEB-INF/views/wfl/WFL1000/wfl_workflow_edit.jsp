<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@include file="/view/base/resource.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">


</head>
<body>
<div class="easyui-panel" title="查询条件" style="width:700px">
<form id="queryForm" class="ui-form" method="post"> 
	            <div data-options="region:'north',split:true" style="padding:5px">  
	              <!-- <div class="ftitle">维护信息</div>  -->
	                <div class="fitem">
		             <label>工作流代码:</label>
		               <input class="easyui-validatebox" type="text" style="width:155px;" name="workflow_code" >
		             <label>名称:</label>
		               <input class="easyui-validatebox" type="text" style="width:155px;" name="name" >
		           </div>  
		            <div class="fitem">
		               <label style="margin-bottom:10px;" >状态:</label>
		               <input class="easyui-combobox"  style="width:155px;"  name="status" data-options="
								method:'post',
								valueField:'status',
								textField:'status_desc',
								data:[{status:'',status_desc:'全部'},{status:'0',status_desc:'有效'},{status:'-1',status_desc:'无效'}]
								">
		               <label style="margin-bottom:10px;" >可回收:</label>
		               <input type="checkbox"   value="1"  name="can_cancel" >
		           </div>  
                    <div class="fitem">
	                  <label style="margin-bottom:15px;" >模糊查询(%):</label>
		              <input id="query_text_id"  class="easyui-searchbox"  name="query_text"  data-options="width:416,searcher:querys,prompt:'请输入条件,以%开始或结束'"  type="text" />
	               </div>
	            </div>
	         </form>
 </div>
      <div  style="margin-left:20px;margin-bottom:10px;">  
			<a href="javascript:void(0)" id='addLine_btn' class="easyui-linkbutton" data-options="iconCls:'icon-search'"  onclick="querys()" >查询</a>  
			<a href="javascript:void(0)" id='addLine_btn' class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="reset()"  >重置</a>  
	</div> 
<table id="flex1" style="display:none"></table>
<script type="text/javascript">
/**********当前功能全局变量定义*******************************/
var g_temp_record;//保存点击行
var g_query_uri='ToDoGo.do?actionId=query@list&dataSorce=xml/wfl/WFL1000/wfl_workflow.xml';
/*****************************************************************/

//修改DataGrid对象的默认大小，以适应页面宽度。
$(function() {
/*1主页的设置*/
 // 第一次加载时自动变化大小
  var docWin=document.body;
 $('#flex1').resizeDataGrid(docWin,0, 0, 0, 0);
 // 当窗口大小发生变化时，调整DataGrid的大小
 $(docWin).resize(function() {
  $('#flex1').resizeDataGrid(docWin,0, 0, 0, 0);
 });
 /*2弹出窗的设置*/
 // 第一次加载时自动变化大小
 var docWin1='#edit_test';
 $('#dg').resizeDataGrid(docWin1,0, 0, 0, 0);
 // 当窗口大小发生变化时，调整DataGrid的大小
 $(docWin1).resize(function() {
  $('#dg').resizeDataGrid(docWin1,0, 0, 0, 0);
 }); 
});
 
 /******************************************************************************/
 function reset(){
	 $('#queryForm').form('reset');
	 querys();
 }
 
 function querys(){
	//$('#queryForm').form('setValue',{'query_text':});
	var formrecord=$('#queryForm').form('serialize');
	formrecord['query_text']=$('#query_text_id').searchbox('getValue');//特殊处理
    var record="["+JSON.stringify(formrecord)+"]";   //对象数组转换为json
	$("#flex1").datagrid({url: g_query_uri,
								queryParams: {_para:record},
								pageNumber:1
	                            });
 }
 
$("#flex1").datagrid({
			url: g_query_uri,
			dataType: 'json',
			columns:[[   
			          {field:'workflow_id',title:'workflow_id',checkbox:true },   
			          {field:'workflow_code',title: '工作流代码', width : 70, sortable : true, align: 'center',resizable:true},
			          {field:'name',title: '名称', width : 120, sortable : true, align: 'left',resizable:true},
			          {field:'status_display',title:'状态',sortable : true,width:50,align:'center',resizable:true},
			          {field:'can_cancel_display',title:'可回收',width:50,align:'center',resizable:true},
			          {field:'display_form_display',title:'显示页面',width:180,align:'left',resizable:true},
			          {field:'update_form_display',title:'修改页面',width:180,align:'left',resizable:true},
			          {field:'childMenus',title:'编辑',width:120,align:'center',formatter:function(value,row,index){
							var html= '<a href="javascript:sub_edit(\'' + index + '\')";>编辑</a>';
							return html;
						}}
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
	     onLoadError : function() {
	           alert('数据加载失败!');
	       },
	      title:"工作流定义",
	     toolbar : [ {text : '添加', iconCls : 'icon-add',handler : edit_buttion
	       }, '-', {text : '修改', iconCls : 'icon-edit',handler : edit_buttion
	       }, '-', {text : '删除', iconCls : 'icon-remove',handler : edit_buttion
	       } ]
		}).datagrid("columnMoving");
//预定义		
//Grid 工具类
	   //Grid DataList
	var Grid = $('#flex1');
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
	function openwin(record){
		var v_workflow_id=record['workflow_id'];
		g_temp_record=record;
		//window.open("initPage.shtml?uri=wfl/WFL1000/wfl_workflow_edit_detail&workflow_id="+v_workflow_id);
		window.location.href="initPage.shtml?uri=wfl/WFL1000/wfl_workflow_edit_detail&workflow_id="+v_workflow_id;
		//编辑框加载数据
		/*	 $("#edit_test").window({
	               width: 780,
	                modal: true,
	               height: 560,
	               iconCls:'icon-edit',
	              // href: '${msUrl}/view/sys_function_edit.jsp?function_id='+v_function_id;
	              href:"initPage.shtml?uri=wfl/WFL1000/wfl_workflow_edit_detail&workflow_id="+v_workflow_id
	              });*/
	}


    function edit_buttion(callback){
		var action=callback.currentTarget.text;
		if (action=='添加'){
			var records =[];
			 records['function_id']="";
			openwin(records);
		}else if(action=='修改'){
			var records = Utils.getCheckedRows();
			if (Utils.checkSelectOne(records)){
				openwin(records[0]);
			}	
		}else if(action=='删除'){
			 var rows = $('#flex1').datagrid('getSelections');
		      var records=JSON.stringify(rows);   //对象数组转换为json;
	             if (rows.length > 0) {
	                 $.messager.confirm("提示", "你确定要删除吗?", function (cmp) {
	                	if(cmp){
		                    $.ajax({
		     					   type: "POST",
		     					   async: false, //同步请求
		     					   url: "ToDoGo.do?actionId=update/batch@fun_del&dataSorce=xml/sys/sys_function.xml",
		     					   data: {_para:records},// _para 代表数组json数据传入，为内定参数
		     					   dataType : 'json', 
		     					   success: function(data){
			     						 for(var i=0;i<rows.length;i++){//界面前台数据删除,实现不刷新删除
							        		  var index=$('#flex1').datagrid('getRowIndex',rows[i]);
							        		  $('#flex1').datagrid('deleteRow', index);
							             }
							             $('#flex1').datagrid('acceptChanges'); //界面数据提交
							             $.messager.alert("提示", "操作成功!!", "info");
		     					   }, error: function(err){
		     						  $.messager.alert("提示", err.responseText, "error");
		     					   }
		     				});
				       }  
	             });
	         }
	         else {
	             $.messager.alert("提示", "请选择要删除的行!", "error");
	         }
		}
	}	

function sub_edit(index){
	var record= $('#flex1').datagrid('getRows')[index];
	$('#flex1').datagrid('unselectRow', index);
	openwin(record);
}
</script>
<div id="edit_test" title="维护" style="top: 10px; padding: 1px;">
    </div>
</body>
</html>