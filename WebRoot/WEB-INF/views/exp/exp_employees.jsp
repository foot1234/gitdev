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
		             <label>员工代码:</label>
		               <input class="easyui-validatebox" type="text" style="width:155px;" name="employee_code" >
		             <label>员工姓名:</label>
		               <input class="easyui-validatebox" type="text" style="width:155px;" name="name" >
		           </div>  
                    <div class="fitem">
	                  <label>模糊查询(%):</label><!-- style="margin-top:15px;margin-bottom:15px;"   -->
		              <input id="query_text_id"  class="easyui-searchbox"  name="query_text"  data-options="width:416,searcher:querys,prompt:'请输入条件,以%开始或结束'"  type="text" />
	               </div>
	            </div>
	         </form>
 </div>
      <div  style="margin-left:20px;margin-bottom:10px;">  
			<a href="javascript:void(0)" id='addLine_btn' class="easyui-linkbutton" data-options="iconCls:'icon-search'"  onclick="querys()" >查询</a>  
			<a href="javascript:void(0)" id='addLine_btn' class="easyui-linkbutton" data-options="iconCls:'icon-redo'" onclick="reset()"  >重置</a>  
	</div> 
<table id="flex1"  class="easyui-datagrid" title="员工定义" style="width:auto;height:300px"></table>
<script type="text/javascript">
/**********当前功能全局变量定义*******************************/
var g_temp_record;//保存点击行
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
 /*var docWin1='#edit_test';
 $('#dg').resizeDataGrid(docWin1,0, 0, 0, 0);
 // 当窗口大小发生变化时，调整DataGrid的大小
 $(docWin1).resize(function() {
  $('#dg').resizeDataGrid(docWin1,0, 0, 0, 0);
 }); */
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
	$("#flex1").datagrid({url: 'ToDoGo.do?actionId=query@list&dataSorce=xml/exp/exp_employees.xml',
								queryParams: {_para:record},
								pageNumber:1
	                            });
 }
 
$("#flex1").datagrid({
	         height: 350,
			url: 'ToDoGo.do?actionId=query@list&dataSorce=xml/exp/exp_employees.xml',
			dataType: 'json',
			columns:[[   
			          //{field:'ck',title:'ck',checkbox:true },   
			          {field:'employee_id',title:'employee_id',checkbox:true},   
			          {field:'employee_type_id',title:'employee_type_id',hidden:true},   
			          {field:'description',title: '员工类型', width : 70, sortable : true, align: 'center',resizable:true, editor:{ type: 'combobox',required: true}},
			          {field:'employee_code',title: '员工代码', width : 120, sortable : true, align: 'left',resizable:true,editor:{ type: 'validatebox',options: {required: true,validType:'checkUpper'}} },
			          {field:'name',title:'姓名',width:80,align:'left',resizable:true,editor:{ type: 'validatebox',options: {required: true}}},
			          {field:'enabled_flag',title:'启用',width:50,align:'center',resizable:true,formatter: checkbox_c,editor: { type: 'checkbox', options: { on:'Y', off: 'N' } }},
			          {field:'email',title:'邮件',width:50,align:'left',resizable:true,editor:{ type: 'validatebox'}},
			          {field:'mobil',title:'电话',width:180,align:'left',resizable:true,editor:{ type: 'numberbox'}},
			          {field:'bank_account',title:'银行账号',width:120,align:'center',formatter:function(value,row,index){
							//var html= '<a href="javascript:sub_edit(\'' + row + '\')" ; style= "color:red ;text-decoration:underline;">分配页面' + row.subCount + '</a>';
						if( row.employee_id==''|| row.employee_id==null|| row.employee_id==undefined){
						}else{
							if( row.sub_count==''|| row.sub_count==null|| row.sub_count==undefined){
								var html= '<a href="javascript:sub_edit(\'' + index + '\')";>银行账号(0)</a>';
							}else{
							    var html= '<a href="javascript:sub_edit(\'' + index + '\')";>银行账号(' + row.sub_count + ')</a>';
							}
						}
						  return html;
						}},
				     {field:'notes',title:'备注',width:40,align:'left',resizable:true,editor:{ type: 'text'}}
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
	      title:"员工定义",
	     toolbar : [ {text : '添加', iconCls : 'icon-add',handler :  function(){edit_buttion('add')}
	       }, '-', {text : '清除', iconCls : 'icon-remove',handler :  function(){edit_buttion('del')}
	       }, '-', {text : '保存', iconCls : 'icon-save',handler :  function(){edit_buttion('save')}
	       } ],
	      onSelect: function(rowIndex,data){
	    	  debugger;
	    	 var field='description';
	    	  var ed = $('#flex1').datagrid('getEditor', { index: rowIndex, field: field});//获取产品名称text编辑器
              $(ed.target).combobox({
            	    required: true,
					valueField:'employee_type_id',
					textField:'description',
					method:'post',
					mode:'remote',
					url:'ToDoGo.do?actionId=query/combox@exp_type&dataSorce=xml/exp/exp_employees.xml',
				    onSelect: function(data){  //combox 动作赋值
				  		 $(this).combobox('hidePanel');
				    	   $('#flex1').datagrid('updateRow',{index: rowIndex,row: {employee_type_id:data['employee_type_id'],description: data['description']}});
				     }		
              });
             var value= $('#flex1').datagrid('getRows')[rowIndex][field];
             $(ed.target).combobox('setValue',value);//grid lov bug问题解决(点击输入框原内容消失)  
	       },    
	   	onClickCell:function(rowIndex, field, value){
	   	  if(field=='description'){//员工类型combox列
	   	   }
	   	}   
		}).datagrid('_enableRowEditing').datagrid("_columnMoving");

//新增       
function append(){
  //  $("#flex1").datagrid('insertRow',{index:0,row:{}});
  $("#flex1").datagrid('appendRow',{index:0,row:{}});
    
}
	
//grid checkbox格式化
function checkbox_c (value, rowData, rowIndex){
     return value == 'Y' ? '<input   name="enabled_flag" type="checkbox" checked  >': '<input name="enabled_flag" type="checkbox"  >';
}


function edit_buttion(action){
	//var action=callback.currentTarget.text;
	if (action=='add'){
		append();
	}else if(action=='save'){
        if($('#flex1')._checkSave()){//保存校验
        	var saveData=$('#flex1')._getDataChanges();//获取
               var inserted = saveData["inserted"];
		       var deleted = saveData["deleted"];
		       var updated = saveData["updated"];
		       var return_flag=true;
	           if (deleted.length) {
	        	  // return_flag=update_post(deleted,'del');// 执行删除
	               }
		      if (updated.length) {
		    	  return_flag=update_post(updated,'edit');// 执行更新
		         }
	          if (inserted.length) {
	        	  for(var i=0;i<inserted.length;i++){
	        		  var $index=$('#flex1').datagrid('getRowIndex', inserted[i]);
	        		  inserted[i]['index_s']=$index;
	        	  }
	        	  return_flag=update_post(inserted,'add');// 执行插入
	        	  }
	           if(return_flag){
	        	   $.messager.alert("提示", "操作成功!", "info");
	           }
        }
		
	}else if(action=='del'){
		 var rows = $('#flex1').datagrid('getSelections');
	      var records=JSON.stringify(rows);   //对象数组转换为json;
             if (rows.length > 0) {
                 $.messager.confirm("提示", "你确定要删除吗?", function (cmp) {
                	if(cmp){
                		 var rows = $('#flex1').datagrid('getChecked');
           			       for(var i=0;i<rows.length;i++){
                   		      var index=$('#flex1').datagrid('getRowIndex',rows[i]);
                   		      $('#flex1').datagrid('deleteRow', index);
                           }
           			    var deleted = $('#flex1').datagrid('getChanges', "deleted");    //调用原生 getChanges 
           			   /* if (deleted.length) {
      	        	      return_flag=update_post(deleted,'del');// 执行删除
      	                 } */
           			    
			       }  
             });
         }
         else {
             $.messager.alert("提示", "请选择要删除的行!", "error");
         }
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
					   url: "ToDoGo.do?actionId=update/batch@"+action_id+"&dataSorce=xml/exp/exp_employees.xml",
					   data: { _para:rows},// _para 代表数组json数据传入，为内定参数
					   dataType : 'json', 
					   success: function(data){
						   debugger;
						   if(data['success']){
							   rows=data['return'][0].rows;
							   for (var i=0;i<rows.length;i++){
									  var index_s=rows[i]['index_s'];
									  //var parameter_code=re_data[i]['parameter_code'];
									  //var parameter_value=re_data[i]['parameter_value'];
									  //var ed = $(thisGrid).datagrid('getEditor', { index: index_s, field: parameter_code });
									 //$(thisGrid).datagrid('getRows')[index_s][parameter_code] = parameter_value;
									  // $(thisGrid).datagrid('endEdit', index_s);
									   $('#flex1').datagrid('updateRow',{index: index_s,row: rows[i]});
								   }
						   }
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

	function openwin(record){
		var v_employee_id=record['employee_id'];
		g_temp_record=record;
		debugger;
		//编辑框加载数据
			 $("#edit_test").window({
	               width: 780,
	                modal: true,
	               height: 460,
	               iconCls:'icon-edit',
	              // href: '${msUrl}/view/sys_function_edit.jsp?function_id='+v_function_id;
	              href:"initPage.shtml?uri=exp/exp_employee_accounts&employee_id="+v_employee_id
	              });
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