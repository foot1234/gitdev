<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@include file="/view/base/resource.jsp" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>角色选择</title>
<style type="text/css">
#wrap {
					width: 200px;/*元素的宽度*/
					height:200px;/*元素的高度*/
					position: absolute;
					left: 37%;/*配合margin-left的负值实现水平居中*/
					margin-left: -100px;/*值的大小等于元素宽度的一半*/
					top:40%;/*配合margin-top的负值实现垂直居中*/
					margin-top: -100px;/*值的大小等于元素高度的一半*/
				}
</style>
</head>
<body> 
<div id="wrap">
<div class="easyui-panel" title="角色选择" style="width:530px;height:300px">
 	<form id="editForm" class="ui-form"> 
 	 <!-- 隐藏文本框 -->
		<input class="hidden" name="role_id">
		<input class="hidden" name="company_id" >
	 	<div data-options="region:'north',split:true" style="padding-top:100px">  
		      <div class="fitem">
		        <label>角色选择:</label>
			        <input id="cc" class="easyui-combobox"  style="width:300px;" name="role_company_name" >
			</div>  
		</div>  	
 </form> 
   <div  style="margin-right:150px;margin-top:30px; float:right">  
			<a href="javascript:void(0)" id='addLine_btn' class="easyui-linkbutton"  onclick="back()" style="margin-right:100px;">返回</a>  
			<a href="javascript:void(0)" id='addLine_btn' class="easyui-linkbutton"  onclick="gomian()"  >前进</a>  
	</div> 
 </div>
 </div>
 <script type="text/javascript">
 //上次登录信息
 //$('#editForm').form('load',"ToDoGo.do?actionId=query/form@list&dataSorce=xml/sys_user_last_login_info.xml");
	$.ajax({
		type: "POST",
		   url: "ToDoGo.do?actionId=query/form@list&dataSorce=xml/sys_user_last_login_info.xml",
		   data: {},
		   dataType : 'json', 
		   success: function(msg){
			var rows=msg;
			 $('#editForm').form('load',rows);
			 if(rows['counts']==1){//只有一个角色，直接进入
				 gomian();
			 }
		   }, error: function(msg){
			   //debugger;
			   //$.messager.alert("提示",msg, "error");
		   }
});  
 
 
 $('#cc').combobox({    
	 url:'ToDoGo.do?actionId=query/combox@user_role&dataSorce=xml/sys_menu_main.xml',   
	    required:true,
	    method:'get',
		valueField:'user_role_group_id',    
		textField:'role_company_name' ,
	    panelWidth: 350,
	    panelHeight: 'auto',
	    multiple:false,
	    onSelect: function (res) {
	    	debugger;
	    	 $('#cc').combobox('hidePanel');
	    	 $('#editForm').form('setValue',{'role_id':res.role_id,'company_id':res.company_id}); //隐藏域赋值
	    }
	}); 
 function gomian()
 {
	if($('#editForm').form('validate')){
		var editFormrecord=$('#editForm').form('serialize');//获取form对象
		var records="["+JSON.stringify(editFormrecord)+"]";//转换为json对象//form 需要加上[]
		 $.ajax({
			   type: "POST",
			   async: false, //同步请求
			   url: "ToDoGo.do?actionId=update@sys_role_select&dataSorce=xml/sys_user_sql.xml",
			   data: {_para:records},// _para 代表数组json数据传入，为内定参数
			   dataType : 'json', 
			   success: function(data){   
				   if(data.success){
				       window.location.href = "initPage.shtml?uri=main/main";
				   }else
					   {
					   $.messager.alert("提示", data.msg, "error");
					   }
			   }, error: function(err){
				  $.messager.alert("提示", err.responseText, "error");
			   }
		});
	}
 }

 function back()
 {
	 //window.location.href = "uncheckPage.shtml?uri=login";
	 window.location.href ="${msUrl}/logout.do";
 }
</script>    
</body>
</html>