<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@include file="/view/base/resource.jsp" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>数据初始化重载</title>
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
   <div  style="margin-left:30px;margin-top:30px;">  
    <font >数据重载页面!</font> <br><br>
			<a href="javascript:void(0)" id='addLine_btn' class="easyui-linkbutton"  onclick="reload()"  >重载</a>  
	</div> 
 </div>
 </div>
 <script type="text/javascript">
 function reload()
 {
		 $.ajax({
			   async: false, //同步请求
			   url: "redoSysInit.do",
			   success: function(data){   
				   $.messager.alert("提示", "重载成功!", "info");
			   }, error: function(err){
				  $.messager.alert("提示", err.responseText, "error");
			   }
		});
 }
</script>    
</body>
</html>