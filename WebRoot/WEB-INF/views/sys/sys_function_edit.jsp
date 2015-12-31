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
  <!--   <div id="edit-win" class="easyui-window"  title="维护" data-options="closed:true,iconCls:'icon-edit',modal:true,resizable:true"  collapsible="true"  style="width:650px;height:550px;"> --> 
     	<form id="editForm" class="ui-form" method="post"> 
     	 <!-- 隐藏文本框 -->
		     	 <input class="hidden" name="function_id">
		     	 <input class="hidden" name="function_type"  id='function_type_id'>
		    	 <input class="hidden" name="parent_function_id" id='parent_function_id'>
		    	 <input class="hidden" name="service_id" id='service_id_id'>
    	 
	            <div data-options="region:'north',split:true" style="height:120px;padding:10px">  
	              <!-- <div class="ftitle">维护信息</div>  --> 
		           <div  class="fitem">
		              <label>上级节点:</label>
		              <input id="parent_function_select_id" class="easyui-combobox"  style="width:155px;" name="parent_function_desc" data-options="
								url:'ToDoGo.do?actionId=query/combox@load&dataSorce=xml/sys/sys_function.xml?function_type=G',
								method:'post',
								valueField:'function_id',
								textField:'description'
								">
		              <label>排序号:</label>
		              <input class="easyui-numberbox" type="text"  value="0" style="width:155px;" name="sequence" data-options="required:true,min:0,max:9999,missingMessage:'数字域必须填写0~9999之间的数'">
		           </div>  
		           <div class="fitem">
		              <label>功能代码:</label>
		              <input class="easyui-validatebox" type="text" style="width:155px;" name="function_code" data-options="required:true,validType:'checkUpper'">
		              <label>功能类型:</label>
		               <input id="function_type_select_id" class="easyui-combobox"  style="width:155px;" name="function_type_desc" data-options="
								url:'SYSCODE/FUNCTION_TYPE',
								method:'post',
								valueField:'code_value',
								textField:'code_value_name',
								required:true
								">
		           </div>  
		            <div class="fitem"><label>功能描述:</label>
		              <input class="easyui-validatebox" type="text" style="width:416px;height: 40px;" name="description"  data-options="required:true">
		           </div>
                    <div class="fitem"><label>入口主页面:</label>
	                  <input id="service_name_id" style="width:416px;"  name="service_name"  class="easyui-validatebox"  >
	               </div>
	            </div>
	            <div id="toolbar"  style="margin-left:20px;margin-bottom:10px;">  
						   <a href="javascript:void(0)" id='addLine_btn' class="easyui-linkbutton" data-options="iconCls:'icon-ok'"  onclick="saveAll()">保存</a>  
			               <a href="javascript:void(0)" id='addLine_btn' class="easyui-linkbutton" data-options="iconCls:'icon-back'"  onclick="closeBack()" >返回</a>  
			    </div> 
	         </form>
			 <div id="dgdiv" >
			 	<table id="dg" class="easyui-datagrid" title="页面分配" style="width:auto;height:300px">
		        <thead>
		            <tr>
		             <th data-options="field:'function_id',checkbox:true">function_id</th>
		             <th data-options="field:'old_service_id',hidden:true">old_service_id</th>
		             <th data-options="field:'service_id',hidden:true">service_id</th>
				     <th data-options="field:'service_name',width:200,editor:{
                            type:'combobox'
                            }">页面</th><!--editor:'text'  -->
				     <th data-options="field:'title',width:100,editor: { type: 'validatebox'}">标题</th>
					 <!--<th data-options="field:'title',width:100,editor: { type: 'validatebox', options: { required: true} }">标题</th>  -->
		            </tr>
		        </thead>
		    </table>
			    <div id="tb" style="height:auto">
				        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append()">新增</a>
				        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit()">删除</a>
			    		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="saveChanges()">保存</a>
			    </div>
        </div> 

<!-- lov面板 -->	
<div id="edit_test_open" title="lov" ></div>
 <!-- end lov面板 -->
 		
 <script type="text/javascript">
  var g_function_id= '<%=request.getParameter("function_id")%>';
  var g_record=window.g_temp_record;
  var g_combox_url="initPage.shtml?uri=sys/sys_service_comlov";
 function init(){
		//form初始化
	 $('#editForm').form('load',g_record);
		
	//页面分配 初始化 
	 var alert_flag=0;
	 $("#dg").datagrid({url: 'ToDoGo.do?actionId=query@load_service&dataSorce=xml/sys/sys_function.xml',
	 	        queryParams: {function_id:g_function_id},
	 		    iconCls: 'icon-edit',
	 		     pagination:true,
	 		     fitColumns: true,
	 		     rownumbers:true,
	 		     collapsible:true,
	 		     toolbar: '#tb',
	 		     method: 'get',
	 		     onLoadError : function(err,a) {
	 		    	 //debugger;
	 		    	 if(alert_flag==0)$.messager.alert("提示", err.responseText+a, "error");
	 		    	  alert_flag=1;
	 		       }
	 		});
	
	 setTimeout(function () {//注意要延时执行，要不会报错，可能combogrid作为编辑器和datagrid有冲突
		 $("#service_name_id").combobox('setValue',g_record['service_name']);//form lov bug问题解决
	  if (g_record['function_type']=='G'){//如果是目录，则没有主页维护
				$("#service_name_id").combobox('disable');
			}else{
				$("#service_name_id").combobox('enable');
			}
	   //
       }, 10);
	
 }

 init();//编辑控制初始化
 
var g_old_editFormrecord=$('#editForm').form('serialize');////获取form的全部数据,保存历史数据用于头行保存校验 	

    
  //指定上级combox设置
 $('#parent_function_select_id').combobox({  
       onChange:function(newValue,oldText){  //combox 动作赋值
         $("#parent_function_id").val(newValue);
      }
});
  
  
 $('#service_name_id').combobox({
	 onShowPanel:function(){
		 $('#service_name_id').combobox('hidePanel');
		 $("#edit_test_open").window({
	         width: 580,
	          modal: true,
	          height: 500,
	         title:"lov查询",
	         iconCls:'icon-search',
	         href: g_combox_url,
	         onClose:function(){ 
	        	 var lov_data=window.lov_record;//接收lov选择的值
			        	if( lov_data==null || lov_data==undefined ||lov_data==''){}//说明没有选择值，直接关闭
			        	 else{
				         $("#service_id_id").val(lov_data['service_id']);
				         $("#service_name_id").combobox('setValue',lov_data['service_name']);
			         }
	             }
	        });
	 }
});
  
 $('#function_type_select_id').combobox({  
     onChange:function(newValue,oldText){  //combox 动作赋值
       $("#function_type_id").val(newValue);      
       if (newValue=='G'){//如果是目录，则没有主页维护
			$("#service_name_id").combobox('disable');
		}else
		{
			$("#service_name_id").combobox('enable');
		}
    }
}); 
 
 //**begin gridedit lovcombox************************************************************************//    
//  启用行编辑
// $('#dg').datagrid('enableCellEditing');
 //新增
function append(){
     $('#dg').datagrid('insertRow',{index:0,row:{function_id:g_function_id,service_name:""}});
}
 var editIndex = undefined;//grid 初始化开始
    /*    $('#dg').datagrid({
        	onSelect: function(index,data){
	         		if (editIndex != index){
	                    if (endEditing()){
	                        $('#dg').datagrid('beginEdit', index);
	                        editIndex = index;
	                    } else {
	                        $('#dg').datagrid('selectRow', editIndex);
	                    }
	               onSelectRow(index,data);
	               $('#dg').datagrid('unselectRow', index);
	        	  }
        	}		
        });*/
 
        $('#dg').datagrid({
        	/*onSelect: function(index,data){
        		  debugger;
	             onSelectRow(index,data);
	              //$('#dg').datagrid('unselectRow', index);
        	}*/
        	onClickCell:function(rowIndex, field, value){
      		  debugger;
      		  if(field=='service_name'){//lov列
      			  //value 为null 重新获取
      			value=$('#dg').datagrid('getRows')[rowIndex][field];
                  onSelectRow(rowIndex,value);
      		    }
      		  }
              // $('#dg').datagrid('unselectRow', index);
        }).datagrid('_enableCellEditing');//启用编辑器
    
 /***********************************************************************/   
function endEditing(){
            if (editIndex == undefined){return true}
            if ($('#dg').datagrid('validateRow', editIndex)){
                $('#dg').datagrid('endEdit', editIndex);
                editIndex = undefined;
                return true;
            } else {
                return false;
            }
        }


 
  function onSelectRow(index,value){

	       //  $('#dg').datagrid('editCell', { index: index, field: 'service_name' });
             var ed = $('#dg').datagrid('getEditor', { index: index, field: 'service_name' });//获取产品名称text编辑器
           // debugger;
              $(ed.target).combobox({
            	 required : true,  
            	 textField:'service_name',
              	 onShowPanel:function(){
              		 debugger;
         			 $(this).combobox('hidePanel');
         			 $("#edit_test_open").window({
         				 width: 580,
         		          modal: true,
         		          height: 500,
         		         title:"lov查询",
         		         iconCls:'icon-search',
         		         href: g_combox_url,
         		         onClose:function(){ //lov close 时设置值
         		        	 debugger;
         		           var lov_data=window.lov_record;//接收lov选择的值
         		               var v_service_name=$('#dg').datagrid('getRows')[index]['service_name'];
                    		     if( lov_data==null || lov_data==undefined ||lov_data==''){//说明没有选择值，直接关闭
                    		     $('#dg').datagrid('getRows')[index]['service_name'] = v_service_name;//直接关闭恢复
         		                 $('#dg').datagrid('updateRow',{index: index,row: {}});//如果为required：true 则需要更新行
                    		     }else{
           			        		    $('#dg').datagrid('getRows')[index]['function_id'] = g_function_id//隐藏域设置
           			        		    $('#dg').datagrid('getRows')[index]['old_service_id'] = $('#dg').datagrid('getRows')[index]['service_id'];//隐藏域设置
             		                    $('#dg').datagrid('getRows')[index]['service_id'] = lov_data['service_id'];//隐藏域设置
             		                    $('#dg').datagrid('getRows')[index]['title'] = lov_data['title'];
             		                    var ed1=$('#dg').datagrid('getEditor',{index:index,field:'service_name'});
          		                        ed1.actions.setValue(ed.target,lov_data['service_name']);//edit 赋值
	             		              
          		                        if(v_service_name==""||v_service_name==null||v_service_name==undefined){
	             		                 $('#dg').datagrid('getRows')[index]['service_name'] = lov_data['service_name'];//新增赋值
	             		                 $('#dg').datagrid('updateRow',{index: index,row: {}});//如果为required：true 则需要更新行
	             		                }
	             		            
           			        	     }
         		                 $('#dg').datagrid('endEdit', index);
         		                
         		            }
         			 });
             	 }
             });//替换text为combogrid编辑器，注意如果要根据当前行的某些数据加载不同的内容，需要动态修改配置中的url 
            // $(ed.target).combobox('setValue',data['service_name']);//grid lov bug问题解决
            $(ed.target).combobox('setValue',value);//grid lov bug问题解决
     }
        
     
  
        
 //*全部保存***************************************************************//
 function saveAll(){
	 var editFormrecord=$('#editForm').form('serialize');//获取form的全部数据;
	var equal=equalObject(editFormrecord,g_old_editFormrecord,true);//判断头数据是否有改变
	var flag= $('#editForm').form('validate');//表单校验
	if(!flag) return;
	if(flag&&(!equal)){
		var action_id="";
		if(g_function_id==null||g_function_id==undefined||g_function_id==''){
		 //新增
			action_id="fun_add";
		}else
		{//修改
			action_id="fun_update";
		}
		//执行请求
			$.ajax({
					   type: "POST",
					   async: false, //同步请求
					   url: "ToDoGo.do?actionId=update@"+action_id+"&dataSorce=xml/sys/sys_function.xml",//form 提交
					   data: {
						   function_id:      editFormrecord.function_id,
						   function_code:      editFormrecord.function_code,
						   function_type:       editFormrecord.function_type,
						   parent_function_id:editFormrecord.parent_function_id,
						   sequence:			  editFormrecord.sequence,
						   service_id:			  editFormrecord.service_id,
						   description:		  editFormrecord.description
						   },
					   dataType : 'json', 
					   success: function(data){
						   debugger;
					      if(g_function_id==null||g_function_id==undefined||g_function_id==''){   
							 var function_id =data.rows[0]['function_id'];
							   g_function_id=function_id;//全局变量赋值
						   }
						    //头保存成功，开始保存行
						    saveChanges();
						  // EyMs.alert('提示',data.rows[0]['function_id'],'info');    
						  // debugger;
					   }, error: function(err){
						   EyMs.alert('提示',err.responseText,'error');    
					   }
				});
	    }else
	    {
	    	//只有行改变，则只保存行
	    	 saveChanges();
	    }
 }
        
/****************************************************************/
  function update_post(records,action_id){
	if(records.length > 0){
			var rows=JSON.stringify(records);   //对象数组转换为json
			var return_s=false;
		     $.ajax({
					   type: "POST",
					   async: false, //同步请求
					   url: "ToDoGo.do?actionId=update/batch@"+action_id+"&dataSorce=xml/sys/sys_function.xml",
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
 /****************************************************************/ 
        function removeit(){
        	 var rows = $('#dg').datagrid('getChecked');
        	 debugger;
        	 //选择要删除的行
	             if (rows.length > 0) {
	                 $.messager.confirm("提示", "你确定要删除吗?", function (cmp) {
	                	if(cmp){
		                	var data =[];
		                	 for(var i=0;i<rows.length;i++){
		                		var function_id= rows[i]['function_id'];
		                		var service_id= rows[i]['service_id'];
				        		 if((function_id==null||function_id==""||function_id==undefined)||
				        		     (service_id==null||service_id==""||service_id==undefined)){//剔除数据库不存在的数据
				        		 }else{
				        			 data.push(rows[i]);
				        		 }
				        	  }
			                    if(update_post(data,'del')){// 执行删除
			                    	 $.messager.alert("提示", "操作成功!", "info");
			                    }
					       for(var i=0;i<rows.length;i++){
					        		  var index=$('#dg').datagrid('getRowIndex',rows[i]);
					        		  $('#dg').datagrid('deleteRow', index);
					        }
					       $('#dg').datagrid('acceptChanges'); //界面数据提交
				       }  
	             });
	         }
	         else {
	             $.messager.alert("提示", "请选择要删除的行!", "error");
	         }
        }
 
 //grid保存
        function saveChanges(){
            var rows = $('#dg').datagrid('getChanges');
            var inserted = $('#dg').datagrid('getChanges', "inserted");
            var deleted = $('#dg').datagrid('getChanges', "deleted");
            var updated = $('#dg').datagrid('getChanges', "updated");  
            debugger;
        var return_flag=true;
           if (deleted.length) {
        	   return_flag=update_post(deleted,'del');// 执行删除
               }
	      if (updated.length) {
	    	  return_flag=update_post(updated,'edit');// 执行更新
	         }
          if (inserted.length) {
        	  for(var i=0;i<inserted.length;i++){//头行一起新增时保存赋值
        		  inserted[i]['function_id']=g_function_id;
        	  }
        	  return_flag=update_post(inserted,'add');// 执行插入
        	  }
          $('#dg').datagrid('acceptChanges'); //界面数据提交
           if(return_flag){
        	   $.messager.alert("提示", "操作成功!", "info");
           }
        }
        
  function closeBack()//返回
   	 {
   		   $("#edit_test").dialog('close'); 
   	 }
        
    </script>    
  <!--</div>     -->	
 <!--end Edit Win&From -->	
</body>
</html>