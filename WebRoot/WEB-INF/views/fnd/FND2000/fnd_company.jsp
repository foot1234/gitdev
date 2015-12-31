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
 <style type ="text/css" >
    .i {
  border-color: #ffa8a8;
  background-color: #EBEBE4;
  color: #000;
  border: 1px solid #95B8E7;
  height:20px;
  width:346px;
  
};
    
    </style>
<div class="easyui-panel" title="查询条件" style="width:700px">
<form id="queryForm" class="ui-form" method="post"> 
	            <div data-options="region:'north',split:true" style="padding:5px">  
	              <!-- <div class="ftitle">维护信息</div>  -->
	              
		            <div class="fitem">
						<label>机构代码:</label>
						<input class="easyui-validatebox"   style="width:155px;" name="company_code"  >	
						<label>机构名称:</label>
		                <input class="easyui-validatebox"  style="width:155px;" name="company_short_name" >	
		           </div>  
		            <div class="fitem">
						<label>机构类型:</label>
						  <input class="easyui-combobox"  style="width:155px;" name="company_type" data-options="
								url:'SYSCODE/COMPANY_TYPE',
								method:'post',
								valueField:'code_value',
								textField:'code_value_name'
								">
					<label>账套:</label>
						  <input class="easyui-combobox"  style="width:155px;" name="set_of_books_id" data-options="
								url:'ToDoGo.do?actionId=query/combox@gld_set_of_books&dataSorce=xml/fnd/FND2000/fnd_company.xml',
								method:'get',
								valueField:'set_of_books_id',
								textField:'set_of_books_desc'
								">		
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
	<table id="company_table_id"  title="机构定义" class="easyui-datagrid" style="width:auto;height:350px"
         data-options="
			  iconCls: 'icon-edit',
			  pagination:true,
		      fitColumns: true,
		     rownumbers:true,
		     collapsible:true
			">
		<thead>
		    <tr><th type='radio' data-options="field:'ck',checkbox:true">ck</th>
		          <th data-options="field:'company_code',sortable:true">机构代码</th>
		          <th data-options="field:'company_type_display',width:100,sortable:true,resizable:true">机构类型</th>
				  <th data-options="field:'company_short_name',width:100,sortable:true,resizable:true">机构简称</th>
				  <th data-options="field:'company_full_name',width:100,sortable:true,resizable:true,align:'center'">机构全称</th>
				  <th data-options="field:'set_of_books_id_display',width:100,sortable:true,resizable:true, align:'center'">帐套</th>
				  <th data-options="field:'company_level_id_display',width:100,sortable:true,resizable:true,align:'center'">级别</th>
				  <th data-options="field:'parent_company_id_display',width:100,sortable:true">父机构</th>
				  <th data-options="field:'start_date_active',width:100,sortable:true">有效期从</th>
				  <th data-options="field:'end_date_active',width:100,sortable:true">有效期至</th>
				  <!--<th data-options="field:'end_date_active',width:100,formatter:ass_role">有效期至</th>  -->
				  <!-- <th data-options="field:'edit',width:100">编辑</th> -->
		       </tr>
		</thead>
	</table>
<script type="text/javascript">
var g_table_record="";
var g_queryForm_id='#queryForm';
var g_table_id='#company_table_id';
var g_table_uri='ToDoGo.do?actionId=query@list&dataSorce=xml/fnd/FND2000/fnd_company.xml';

//var g_combox_url="initPage.shtml?uri=sys/SYS001/employee_comlov";
var g_update_com_url="ToDoGo.do?actionId=update@edit&dataSorce=xml/fnd/FND2000/fnd_company.xml";
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
$(g_table_id).datagrid({url: g_table_uri,
	       // queryParams: {function_id:g_function_id},
	        singleSelect: true,
			onLoadSuccess:function(data){//启用消息提示框   
			    $(g_table_id).datagrid("tooltip");    
			}, 
		     onLoadError : function(err,a) {
		    	 if(alert_flag==0)$.messager.alert("提示", err.responseText+a, "error");
		    	  alert_flag=1;
		       },
		       toolbar : [ {text : '添加', iconCls : 'icon-add',handler : edit_buttion
		       }, '-', {text : '编辑', iconCls : 'icon-edit',handler : edit_buttion
		       } ]
		});
function edit_buttion(callback){
	var action=callback.currentTarget.text;
	if ($.trim(action)=='添加'){
		var records =[];
		//var date=new Date();
		//debugger;
		 records['encrypted_foundation_password']=1;
		 records['encrypted_user_password']=1;
		 openwin(records);
		// $("#company_code").attr('readonly',false);
		 //$("#comb_company_type_id").combobox('enable');
		// $("#company_code").removeClass("i");
		 $("#company_code").readOnly(false);
		 $("#comb_company_type_id").readOnly(false);
		 debugger;
		 
	}else if($.trim(action)=='编辑'){
		var records = Utils.getCheckedRows();
		if (Utils.checkSelectOne(records)){
			openwin(records[0]);
			 $("#company_code").readOnly(true);
			 $("#comb_company_type_id").readOnly(true);
			// $("#comb_company_type_id").addClass("i");
			//编辑状态code不允许编辑
			//$("#company_code").attr("data-options","required:false");
			debugger;
			//$("#company_code").attr('readonly',true);
			//$("#comb_company_type_id").combobox('disable');
			//$("#company_code").addClass("i");
		}	
	
	}
	
}

//readonly="readonly" 设置文本框只读 disabled="disabled" 禁用文本框
//$(".easyui-validatebox").attr("readonly",true);
//$("#name").attr('disabled','disabled');

function openwin(record){
	//debugger;
	$('#editForm').form('reset');
	$('#editForm').form('load',record);
	$('#edit-win').window('open');
	//编辑框加载数据	
}

/*//角色分配
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
}*/
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
	$('#query_text_id').searchbox('setValue',"");
	 querys();
}


</script>    
     <!-- Edit Win&Form -->
     <div id="edit-win" class="easyui-dialog" title="编辑" data-options="closed:true,iconCls:'icon-save',modal:true" style="width:570px;height:380px;">  
     	<form id="editForm" class="ui-form" method="post">  
     		  <!-- 隐藏文本框 -->
     		     <input class="hidden" name="company_id"  id='company_id_id'>
		     	 <input class="hidden" name="company_type"  id='company_type_id'>
		     	 <input class="hidden" name="set_of_books_id"  id='set_of_books_id_id'>
		     	 <input class="hidden" name="company_level_id"  id='company_level_id_id'>
		     	 <input class="hidden" name="parent_company_id"  id='parent_company_id_id'>
     		 <div class="ui-edit">
		     	   <div class="ftitle">公司编辑</div>    
		           <div class="fitem">  
		               <label>机构代码:</label>  
		               <input  class="easyui-validatebox"  type="text" name="company_code" id="company_code" data-options="required:true" > <!-- disabled="true" -->
		               <label>机构名称:</label>  
		               <input class="easyui-validatebox" type="text" name="company_short_name" data-options="required:true">
		                
		           </div>  
		           <div class="fitem" >  
		             <label>机构全称:</label>  
		               <input class="easyui-validatebox" type="text" name="company_full_name"  style="width:370px;">
		           </div> 
		             <div class="fitem">  
		               <label>机构类型:</label>  
		                <input id="comb_company_type_id"  class="easyui-combobox"  name="company_type_display"  data-options="
								url:'SYSCODE/COMPANY_TYPE',
								method:'post',
								valueField:'code_value',
								textField:'code_value_name',
								required:true
								">
		                <label>账套:</label>  
		                <input id="comb_set_of_books_id"   class="easyui-combobox" type="text"  name="set_of_books_id_display"  data-options="
								url:'ToDoGo.do?actionId=query/combox@gld_set_of_books&dataSorce=xml/fnd/FND2000/fnd_company.xml',
								method:'post',
								valueField:'set_of_books_id',
								textField:'set_of_books_desc',
								required:true
								">
		           </div> 
		            <div class="fitem">  
		                <label>机构级别:</label>  
		                <input  id="comb_company_level_id"   class="easyui-combobox" type="text"   name="company_level_id_display"  data-options="
								url:'ToDoGo.do?actionId=query/combox@company_levels&dataSorce=xml/fnd/FND2000/fnd_company.xml',
								method:'post',
								valueField:'company_level_id',
								textField:'description'
								">
		                <label>主岗位:</label>  
		                <input class="easyui-validatebox" type="text"   name="chief_position_id_display" >
		           </div> 
		            <div class="fitem">  
		               <label>父机构:</label>  
		               <input  id="comb_parent_company_id"   class="easyui-combobox"  type="text"  name="parent_company_id_display"  style="width:250px;"data-options="
								url:'ToDoGo.do?actionId=query/combox@list&dataSorce=xml/fnd/FND2000/fnd_company.xml',
								method:'post',
								valueField:'company_id',
								textField:'company_desc'
								">
		           </div> 
		           <div class="fitem">  
		                <label>有效时间从:</label>  
		               <input  class="easyui-datebox" type="text"  name="start_date_active" >
		                <label>有效时间到:</label>  
		                  <input  class="easyui-datebox" type="text"  name="end_date_active" >
		           </div> 
		              <div class="fitem">  
		                <label>地址:</label>  
		               <input  class="easyui-validatebox" type="text"  name="address"  style="width:368px;">
		          
		           </div> 
	         </div>
     	</form>
     	<div id="toolbar"  style="margin-right:50px;margin-top:30px;float:right">  
			<a href="javascript:void(0)" id='addLine_btn' class="easyui-linkbutton" data-options="iconCls:'icon-ok'"  onclick="saveEditWin()">保存</a>  
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

  function saveEditWin(){
	  var formrecord=$('#editForm').form('serialize');
		//校验必输域
		 if(!$('#editForm').form('validate'))
		{
			 EyMs.alert('提示','必输字段不允许为空!','error');  
			return; 
	     }
		debugger;
       var rows="["+JSON.stringify(formrecord)+"]";   //对象数组转换为json
	     $.ajax({
			   type: "POST",
			   async: false, //同步请求
			   url: g_update_com_url,
			   data: { _para:rows},// _para 代表数组json数据传入，为内定参数
			   dataType : 'json', 
			   success: function(data){
				   $.messager.alert("提示", "操作成功!", "info");
					$(g_table_id).datagrid({url: g_table_uri});//刷新grid  定位当前页
					$('#edit-win').window('close');
			   }, error: function(err){
				   EyMs.alert('提示',err.responseText,'error');  
			   }
		});
  }

  
  $('#comb_company_type_id').combobox({  
	  /*   onChange:function(newValue,oldText){
	       if (newValue){//如果有值则不允许维护
				$("#comb_company_type_id").combobox('disable');
			}
	    },*/
	    onSelect:function(record){  //combox 动作赋值
		       $("#company_type_id").val(record.code_value);      
		  }
	}); 
  
  $('#comb_set_of_books_id').combobox({  
	  onSelect:function(record){  //combox 动作赋值
	       $("#set_of_books_id_id").val(record.set_of_books_id);      
	    }
	}); 
  $('#comb_company_level_id').combobox({  
	   /*  onChange:function(newValue,oldText){  //combox 动作赋值
	       $("#company_level_id_id").val(newValue);      
	    }*/
	  onSelect:function(record){  //combox 动作赋值
	      $("#company_level_id_id").val(record.company_level_id);      
	   }
	});  
  
  $('#comb_parent_company_id').combobox({  
	  onSelect:function(record){  //combox 动作赋值
	      $("#parent_company_id_id").val(record.company_id);      
	   }
	   /*  onChange:function(newValue,oldText){  //combox 动作赋值
	       $("#parent_company_id_id").val(newValue);      
	    }*/
	});  
    
    
 /* $('#comb_company_type_id').combobox({
		 onShowPanel:function(){
			 $('#comb_company_type_id').combobox('hidePanel');
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
					       //  $("#comb_company_type_id").combobox('setValue',lov_data['service_name']);
				         }
		             }
		        });
		 }
	});*/
  
</script>    


</body>
</html>