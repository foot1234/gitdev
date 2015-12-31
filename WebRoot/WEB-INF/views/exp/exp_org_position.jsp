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
						<label>岗位代码:</label>
						<input class="easyui-validatebox"   style="width:155px;" name="position_code"  >	
						<label>描述:</label>
		                <input class="easyui-validatebox"  style="width:155px;" name="description" >	
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
	<table id="service_table_id"  title="角色定义" class="easyui-datagrid" style="width:auto;height:350px"
         data-options="
			  iconCls: 'icon-edit',
			  pagination:true,
		      fitColumns: true,
		     rownumbers:true,
		     collapsible:true
			">
		<thead>
		    <tr><th data-options="field:'ck',checkbox:true">ck</th>
		          <th data-options="field:'company_id',hidden:true">company_id</th>
		          <th data-options="field:'unit_id',hidden:true">unit_id</th>
		          <th data-options="field:'position_id',hidden:true">position_id</th>
		          <th data-options="field:'parent_position_id',hidden:true">parent_position_id</th>
		          <th data-options="field:'company_desc',width:100,resizable:true,editor:{type:'combobox',options: { required: true} }">公司</th>
				  <th data-options="field:'unit_desc',width:100,sortable:true,resizable:true,editor: { type: 'combobox', options: { required: true} }">部门</th>
				  <th style="width:400px;height:200px" data-options="field:'position_code',width:100,height:100,sortable:true,resizable:true,editor: { type: 'validatebox', options: { required: true,validType:'checkUpper'} }">岗位代码</th>
				  <th data-options="field:'description',width:100,sortable:true,resizable:true,editor:'text'">岗位描述</th>
                  <th data-options="field:'enabled_flag',width:100,resizable:true,align:'center',formatter: checkbox_c,editor: { type: 'checkbox', options: { on: 'Y', off: 'N' } }">启用</th>
		       </tr>
		</thead>
	</table>
<script type="text/javascript">
var g_queryForm_id='#queryForm';
var g_table_id='#service_table_id';
var g_table_uri='ToDoGo.do?actionId=query@list_position&dataSorce=xml/exp/exp_org_position.xml';
var g_table_save_url="xml/exp/exp_org_position.xml";


//grid checkbox格式化
function checkbox_c (value, rowData, rowIndex){
     return value == 'Y' ? '<input  name="is_access_checked" type="checkbox" checked  >': '<input name="is_access_checked" type="checkbox"  >';
}
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
	
/***********************************************************************/   	
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
		   onSelect: function(index,data){
			   onSelectRow(index,data); 
			   if(data['position_id']){//存在不允许维护公司
			          $(g_table_id)._gridRead(index,'company_desc').readOnly(true);
			   }
	        },
		   toolbar : [ {text : '添加', iconCls : 'icon-add',handler : function(){ edit_buttion('add');}
		       }, '-', {text : '保存', iconCls : 'icon-save',handler : function(){edit_buttion('save');}
		   } ]
		}).datagrid('_enableRowEditing').datagrid("_columnMoving");
function edit_buttion(action){
	//var action=callback.currentTarget.text;
	if (action=='add'){
		$(g_table_id)._gridAdd({enabled_flag:'Y'});
	}else if(action=='save'){
		 $(g_table_id)._gridSave(g_table_save_url,null,true);//function(url,action,alert_flag)
	}
}


function onSelectRow(index,data){
	debugger;
 	//公司选择列
     $(g_table_id)._gridlov({
		  title:"lov查询",
		  id:"com_lov_id",
		  url:"initPage.shtml?uri=sys/SYS001/fnd_com_comlov",
		  index:index,
		  field:"company_desc",
		  width:540,
		  height:490,
		  callback:function(rowIndex,calldata,edit){
			 debugger; 
			 var lov_data=calldata;
	           $(g_table_id).datagrid('updateRow',{index: rowIndex,row: {company_id:lov_data['company_id'],company_desc: lov_data['company_desc']}});
		  }
	  }); 
   //上级部门选择列
     $(g_table_id)._gridlov({
		  title:"lov查询",
		  id:"unit_lov_id",
		  url:"initPage.shtml?uri=exp/exp_org_unit_comlov&company_id="+data["company_id"],
		  index:index,
		  field:"unit_desc",
		  width:540,
		  height:490,
		  callback:function(rowIndex,calldata,edit){
			 debugger; 
			 var lov_data=calldata;
	           $(g_table_id).datagrid('updateRow',{index: rowIndex,row: {unit_id:lov_data['unit_id'],unit_desc: lov_data['unit_desc']}});
		  }
	  }); 
}

/***********************************************************************/   
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