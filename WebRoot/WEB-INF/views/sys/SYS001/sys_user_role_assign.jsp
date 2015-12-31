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
		              <label>用户名:</label>
		              <input class="easyui-validatebox" type="text" style="width:155px;" name="user_name"  disabled="true">
		              <label>描述:</label>
		             	<input class="easyui-validatebox" type="text" style="width:155px;" name="description"  disabled="true">
		           </div>  
	            <div id="toolbar12"  style="margin-left:20px;margin-bottom:10px;margin-top:30px;">  
			               <a href="javascript:void(0)" id='addLine_btn' class="easyui-linkbutton" data-options="iconCls:'icon-back'"  onclick="closeBack()" >返回</a>  
			    </div> 
	         </form>
			 	<table id="dg1we" class="easyui-datagrid" title="页面分配" style="width:auto;height:300px">
		        <thead>
		            <tr>
		             <th data-options="field:'user_role_group_id',checkbox:true">user_role_group_id</th>
		             <th data-options="field:'user_id',hidden:true">user_id</th>
		             <th data-options="field:'role_id',hidden:true">role_id</th>
		             <th data-options="field:'company_id',hidden:true">company_id</th>
		              <th data-options="field:'role_code',width:100,editor:{type:'combobox',options: { required: true} }">角色代码</th><!--editor:'text'  -->
				     <th data-options="field:'role_desc',width:200">角色说明</th>
				     <th data-options="field:'company_code',width:100,editor:{type:'combobox',options: { required: true} }">机构代码</th><!--editor:'text'  -->
				     <th data-options="field:'company_desc',width:200">机构说明</th>
				      <th data-options="field:'start_date',width:100,editor:{type:'datebox' ,options: { required: true} }">启用日期</th><!--editor:'text'  -->
				     <th data-options="field:'end_date',width:100,editor:{type:'datebox'}">结束日期</th>
					 <!--<th data-options="field:'title',width:100,editor: { type: 'validatebox', options: { required: true} }">标题</th>  -->
		            </tr>
		        </thead>
		    </table>


 		
 <script type="text/javascript">
  var g_user_id= '<%=request.getParameter("user_id")%>';
  var g_record=window.g_table_record;
  var g_sub_table_id="#dg1we";
  var g_role_data='ToDoGo.do?actionId=query@load&dataSorce=xml/sys/SYS001/sys_role_groups.xml';
  var g_role_combox_url="initPage.shtml?uri=sys/SYS001/sys_role_comlov";
  var g_com_combox_url="initPage.shtml?uri=sys/SYS001/fnd_com_comlov";
$(function() {  
	//form初始化
	$('#showForm').form('load',g_record);
	  var alert_flag1=0; 
	  $("#dg1we").datagrid({
		     url: g_role_data,
		     method: 'get',
	         queryParams: {user_id:g_user_id},
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
		    }, '-', {text : '清除', iconCls : 'icon-remove',handler : add_edit12
		    }]
		});   
  });
  function add_edit12(callback){
	var action=callback.currentTarget.text;
		if ($.trim(action)=='添加'){
			   append();
		}else if ($.trim(action)=='保存'){
			endEditing();//关闭最后一个编辑行
			  if(check_save()){
		       // var inserted = $(g_sub_table_id).datagrid('getChanges', "inserted");
		      //  var deleted = $(g_sub_table_id).datagrid('getChanges', "deleted");
		       // var updated = $(g_sub_table_id).datagrid('getChanges', "updated");  
		       var inserted = dataChanges["inserted"];
		       var deleted =  dataChanges["deleted"];
		       var updated =  dataChanges["updated"];
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
		}else if ($.trim(action)=='清除'){
			 var rows = $('#dg1we').datagrid('getChecked');
			  for(var i=0;i<rows.length;i++){
        		  var index=$('#dg1we').datagrid('getRowIndex',rows[i]);
        		  $('#dg1we').datagrid('deleteRow', index);
              }
          // $('#dg1we').datagrid('acceptChanges'); //界面数据提交
		}
			
   }
  

  
  
  
 /* function check_save()
  {
	  
	  //$(g_sub_table_id).datagrid('acceptChanges');
 	   //var rows = $(g_sub_table_id).datagrid('getRows');
 	   var rows = $(g_sub_table_id).datagrid('getChanges');
 	   debugger;
 	   var flag=false;
 	   var check_flag=false;
 	    //保存验证
 		    for(var i=0;i<rows.length;i++){
 		    	var index=$(g_sub_table_id).datagrid('getRowIndex', rows[i]);
 		    //	$(g_sub_table_id).datagrid('selectRow', index);
 		        if($(g_sub_table_id).datagrid('validateRow', index))
 		        {
 		        	check_flag=true;
 		        }else
 		        {
 		        	check_flag=false;
 		        	 $.messager.alert("提示", "有必输字段未填!", "error");
 		        	break;
 		        }
 		       $(g_sub_table_id).datagrid('endEdit', index);
 		    }
 		    if(check_flag==true){
 		    	flag=true;
 		    }
 	   return flag;
  }  */
	var dataChanges={};
  function check_save()
  {
	  
	  //$(g_sub_table_id).datagrid('acceptChanges');
	  var initdata=$(g_sub_table_id).getinitdata();//获取原始数据
 	   var rows = $(g_sub_table_id).datagrid('getRows');
 	   //var rows = $(g_sub_table_id).datagrid('getChanges');
 	   debugger;
 	   var flag=false;
 	   var check_flag=false;
 	    //保存验证
 		    	var columns=  $(g_sub_table_id).datagrid('options').columns[0];
 		 		var insertData=[];
 		 		var updateData=[];
 		 		var deleteData=[];
 		    	 for(var i=0;i<rows.length;i++){
 		    		  var alert_field_title=null;
 		    		  var rowindex=null;
	 		 		      for(var j=0;j<columns.length;j++){
			 		    		v_required=false;
			 		    		var field=columns[j].field;
			 		    		var title=columns[j].title;
			 		    		try{
			 		    		  var v_required=columns[j].editor.options.required;
			 		    		}catch(e){}
			 		    		if(v_required){//必输项则校验是否有值
				 		    		//  debugger;
				 		    		 var index=$('#dg1we').datagrid('getRowIndex', rows[i]);
					    		      var value=$('#dg1we').datagrid('getRows')[index][field] ;
					    		      if(value==""||value==null||value==undefined){
					    		    	 rowindex= index;
					    		    	 alert_field_title=title;
					    		    	break;  
					    		      }
			 		        }
	 		       		}
	 		 		 if(alert_field_title){
				 		  debugger;
				 		 $(g_sub_table_id).datagrid('selectRow', rowindex);
				 		 $.messager.alert("提示", "["+alert_field_title+"]为必输字段!", "error");
				 		  return false;
				 		  break;  
				 	    }	
	 		 		 
	 		 		var rn=rows[i]['rn'];
	 		 		if(rn==''||rn==null||rn==undefined){
	 		 			//新增
	 		 			 debugger;
	 		 			insertData.push(rows[i]);
	 		 		}else{ 
	 		 		//	debugger;
	 		 			for (var k in initdata) {//对比不同数据
	 		 			var initrn=initdata[k]['rn'];
	 		 		         if (rn==initrn){
	 		 		        	
	 		 		        	 for(file in initdata[k]){
	 		 		        		if(!(initdata[k][file]==rows[i][file])){
		 		 		        		 //修改
		 		 		        		updateData.push(rows[i]);
		 		 		        		 break;
		 		 		        	 } 
	 		 		        	 } 
	 		 		         }
	 		 		     }
	 		 		 }
	    		}
 		   //删除的数据
 		  var deleted = $(g_sub_table_id).datagrid('getChanges', "deleted");
 		   //有变动的数据
 		    dataChanges={"inserted":insertData,"updated":updateData,"deleted":deleted};
 		    debugger;	 
 		     $(g_sub_table_id).clearinitdata();//清除原始数据 
 		 return true;   
  } 
  


  function update_post(records,action_id){
		if(records.length > 0){
				var rows=JSON.stringify(records);   //对象数组转换为json
				var return_s=false;
				debugger;
			    $.ajax({
						   type: "POST",
						   async: false, //同步请求
						   url: "ToDoGo.do?actionId=update/batch@"+action_id+"&dataSorce=xml/sys/SYS001/sys_role_groups.xml",
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
  
  
  
  //**begin gridedit lovcombox************************************************************************//    
  
  var editIndex = undefined;//grid row编辑初始化开始
  function endEditing(){
      if (editIndex == undefined){return true}
      if ($('#dg1we').datagrid('validateRow', editIndex)){
          $('#dg1we').datagrid('endEdit', editIndex);
          editIndex = undefined;
          return true;
      } else {
          return false;
      }
  }

  
         $('#dg1we').datagrid({
         	onSelect: function(index,data){
         		debugger;
 	                   if (endEditing()){
 	                        $('#dg1we').datagrid('beginEdit', index);
 	                        editIndex = index;
 	                    } else {
 	                        $('#dg1we').datagrid('selectRow', editIndex);
 	                    }
 	               onSelectRow(index,data['role_code']);
 	              // $('#dg1we').datagrid('unselectRow', index);
         	},
			onClickCell:function(index, field, value){
				/*if (editIndex != index){
					if (endEditing()){
						$('#dg1we').datagrid('selectRow', index)
								.datagrid('beginEdit', index);
						var ed = $('#dg1we').datagrid('getEditor', {index:index,field:field});
						if (ed){
							($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
						}
						editIndex = index;
					} else {
						$('#dg1we').datagrid('selectRow', editIndex);
					}
				}*/
				 //value=$('#dg1we').datagrid('getRows')[index][field];
			     // onSelectRow(index,value);
			}
         });
       
  /***********************************************************************/   


 function onSelectRow(index,value){
    /* var ed = $('#dg1we').datagrid('getEditor', { index: index, field: 'role_code' });//获取角色编辑器
      $(ed.target).combobox({
    	 required : true,  
    	 textField:'role_code',
      	 onShowPanel:function(){
 			 $(this).combobox('hidePanel');
 			  var parentdiv=$('<div></div>');        //创建一个父div
 			   parentdiv.attr('id','role_lov_id');        //给div设置id
 			   parentdiv.window({
 				 width: 580,
 		          modal: true,
 		          height: 490,
 		         title:"lov查询",
 		         iconCls:'icon-search',
 		         href: g_role_combox_url,
 		         onClose:function(){ //lov close 时设置值
 		        	 $("#role_lov_id").remove();//删除div
 		           var lov_data=window.lov_record;//接收lov选择的值
 		               var v_role_code=$('#dg1we').datagrid('getRows')[index]['role_code'];
            		     if( lov_data==null || lov_data==undefined ||lov_data==''){//说明没有选择值，直接关闭
            		     $('#dg1we').datagrid('getRows')[index]['role_code'] = v_role_code;//直接关闭恢复
 		                 $('#dg1we').datagrid('updateRow',{index: index,row: {}});//如果为required：true 则需要更新行
            		     }else{
   			        		   // $('#dg1we').datagrid('getRows')[index]['user_id'] = g_user_id; //隐藏域设置
     		                    $('#dg1we').datagrid('getRows')[index]['role_id'] = lov_data['role_id'];//隐藏域设置
     		                    $('#dg1we').datagrid('getRows')[index]['role_desc'] = lov_data['role_name'];
     		                    
     		                    var ed1=$('#dg1we').datagrid('getEditor',{index:index,field:'role_code'});
  		                        ed1.actions.setValue(ed.target,lov_data['role_code']);//edit 赋值
  		                        
  		                      if(v_role_code==""||v_role_code==null||v_role_code==undefined){
          		                 $('#dg1we').datagrid('getRows')[index]['role_code'] = lov_data['role_code'];//新增赋值
          		                 $('#dg1we').datagrid('updateRow',{index: index,row: {}});//如果为required：true 则需要更新行
          		                }
   			        	     }
 		                 $('#dg1we').datagrid('endEdit', index);
 		                
 		            }
 			 });
     	 }
     });//替换text为combogrid编辑器，注意如果要根据当前行的某些数据加载不同的内容，需要动态修改配置中的url
     $(ed.target).combobox('setValue',value);//grid lov bug问题解决(点击输入框原内容消失)*/
     //角色选择
     $('#dg1we')._gridlov({
		  title:"lov查询",
		  id:"role_lov_id",
		  url:"initPage.shtml?uri=sys/SYS001/sys_role_comlov",
		  index:index,
		  field:'role_code',
		  width:540,
		  height:490,
		  callback:function(rowIndex,calldata,edit){
			 debugger; 
              var lov_data=calldata;//接收lov选择的值

		        		 $('#dg1we').datagrid('getRows')[index]['user_id'] = g_user_id; //隐藏域设置
	                  //  $('#dg1we').datagrid('getRows')[index]['role_id'] = lov_data['role_id'];//隐藏域设置
	                 //   $('#dg1we').datagrid('getRows')[index]['role_desc'] = lov_data['role_name'];
	                 //   $('#dg1we').datagrid('getRows')[index]['role_code'] = lov_data['role_code'];
	                    ////var ed1=$('#dg1we').datagrid('getEditor',{index:index,field:'role_code'});
	                       // ed1.actions.setValue(ed1.target,lov_data['role_code']);//edit 赋值
	                       // edit.actions.setValue(edit.target,lov_data['role_code']);//edit 赋值 注意lov显示列一定要用lov赋值
	              // $('#dg1we').datagrid('updateRow',{index: -1,row: {}});        
	           $('#dg1we').datagrid('updateRow',{index: rowIndex,row: {role_id:lov_data['role_id'],role_code: lov_data['role_code'],role_desc:lov_data['role_name']}});
			
		  }
	  }); 
 /*************************************************************************************************************************************/    
    //机构选择 
  /*  var edcom =$('#dg1we').datagrid('getEditor', { index: index, field: 'company_code'});//获取机构编辑器
     $(edcom.target).combobox({
    	 required : true,  
    	 textField:'company_code',
      	 onShowPanel:function(){
 			 $(this).combobox('hidePanel');
 			  var parentdiv=$('<div></div>');        //创建一个父div
			   parentdiv.attr('id','com_lov_id');        //给div设置id
			   parentdiv.window({
 				 width: 580,
 		          modal: true,
 		          height: 490,
 		         title:"lov查询",
 		         iconCls:'icon-search',
 		         href: g_com_combox_url,
 		         onClose:function(){ //lov close 时设置值
 		       	 $("#com_lov_id").remove();//删除div
 		           var lov_data=window.lov_record;//接收lov选择的值
 		           debugger;
 		               var v_company_code=$('#dg1we').datagrid('getRows')[index]['company_code'];
            		     if( lov_data==null || lov_data==undefined ||lov_data==''){//说明没有选择值，直接关闭
            		     $('#dg1we').datagrid('getRows')[index]['company_code'] = v_company_code;//直接关闭恢复
 		                 $('#dg1we').datagrid('updateRow',{index: index,row: {}});//如果为required：true 则需要更新行
            		     }else{
     		                    $('#dg1we').datagrid('getRows')[index]['company_id'] = lov_data['company_id'];//隐藏域设置
     		                    $('#dg1we').datagrid('getRows')[index]['company_desc'] = lov_data['company_short_name'];
     		                    
     		                   edcom.actions.setValue(edcom.target,lov_data['company_code']);//edit 赋值
     		                   
     		                  if(v_company_code==""||v_company_code==null||v_company_code==undefined){
           		                 $('#dg1we').datagrid('getRows')[index]['company_code'] = lov_data['company_code'];//新增赋值
           		                 $('#dg1we').datagrid('updateRow',{index: index,row: {}});//如果为required：true 则需要更新行
           		                }
     		                   
   			        	     }
 		                 $('#dg1we').datagrid('endEdit', index);  
 		            }
 			 });
     	 }
     });//替换text为combogrid编辑器，注意如果要根据当前行的某些数据加载不同的内容，需要动态修改配置中的url
     $(edcom.target).combobox('setValue',data['company_code']);//grid lov bug问题解决(点击输入框原内容消失)*/
 	//公司选择列
     $('#dg1we')._gridlov({
		  title:"lov查询",
		  id:"com_lov_id",
		  url:"initPage.shtml?uri=sys/SYS001/fnd_com_comlov",
		  index:index,
		  field:"company_code",
		  width:540,
		  height:490,
		  callback:function(rowIndex,calldata,edit){
			 debugger; 
			 var lov_data=calldata;

             $('#dg1we').datagrid('getRows')[index]['company_id'] = lov_data['company_id'];//隐藏域设置
             $('#dg1we').datagrid('getRows')[index]['company_code'] = lov_data['company_code'];
             $('#dg1we').datagrid('getRows')[index]['company_desc'] = lov_data['company_short_name'];
             //$('#dg1we').datagrid('getRows')[index]['company_code'] = lov_data['company_code'];
             ////var ed1=$('#dg1we').datagrid('getEditor',{index:index,field:'role_code'});
                // ed1.actions.setValue(ed1.target,lov_data['role_code']);//edit 赋值
             // edit.actions.setValue(edit.target,lov_data['company_code']);//edit 赋值 注意lov显示列一定要用lov赋值 
              //$('#dg1we').datagrid('endEdit', index);
              
             // $('#dg1we').datagrid('unselectRow', index);
             //$(edit.target).combobox('setValue',lov_data['company_code']);
             $('#dg1we').datagrid('refreshRow',index);
		  }
	  }); 
}

 
 function append(){
	// $('#dg1we').datagrid('insertRow',{index:0,row:{user_id:g_user_id}});
	 $('#dg1we').datagrid('appendRow',{user_id:g_user_id});
	 
	   // if (endEditing()){
	        //$('#dg').datagrid('appendRow',{function_id:g_function_id});
	    //    $('#dg1we').datagrid('insertRow',{index:0,row:{user_id:g_user_id}
	   //       });
	//    }
	//    $('#dg1we').datagrid('updateRow',{index:0,row: {}});//实现一次可以多增几行
	}
  
  function closeBack()//返回
   {
	 $("#edit_role").dialog('close'); 
	}	  
    </script>    
</body>
</html>