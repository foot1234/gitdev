<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3c.org/TR/1999/REC-html401-19991224/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>jqspring用户登录</title>
<%@include file="/view/base/resource.jsp"%>
<LINK rel=stylesheet type=text/css
	href="${msUrl}/css/login/images/login.css">
<style type="text/css">
.vc-text {
	width: 90px;
}

.vc-pic {
	vertical-align: middle;
	margin-bottom: 0px !important;
	margin-left: 0px !important;
	cursor: pointer;
}
</style>
</head>
<BODY style="BACKGROUND-COLOR: #f4f7f9">
	<DIV class=login>
		<P class=pl></P>
		<DIV class=l></DIV>
		<DIV class=c>
			<FORM method=post name=myform id="loginForm">
				<DIV class=to>
					<SPAN class=tol><A class=v href="/" target=_blank></A></SPAN><SPAN
						class=tor></SPAN>
				</DIV>
				<DIV class=in>
					<DL>
						<DT>用户名</DT>
						<DD>
							<INPUT style="WIDTH: 150px" type=text name=user_name>
						</DD>
						<DD class=e></DD>
					</DL>
					<DL>
						<DT>密 码</DT>
						<DD>
							<INPUT style="WIDTH: 150px" type=password name=user_password>
						</DD>
						<DD class=e></DD>
					</DL>
					<DL>
						<DT>验证码</DT>
						<DD>
							<INPUT style="WIDTH: 80px" type=text name=verifyCode>
							<!--<input class="vc-text easyui-validatebox" data-options="required:true,missingMessage:'验证码不能为空.'" maxlength="4" type="text" name="verifyCode">  -->
						</DD>
						<DD style="PADDING-TOP: 5px">
							<img id="img_id"
								style="WIDTH: 58px; HEIGHT: 25px; CURSOR: pointer"
								title="图片看不清？点击重新得到验证码"
								src="ImageServlet?time=new Date().getTime()">

							<!--<IMG style="WIDTH: 58px; HEIGHT: 25px; CURSOR: hand"
								onclick=this.src+=Math.random() alt=图片看不清？点击重新得到验证码
								src="images/checkcode.gif">  -->
						</DD>
						<DD class=e></DD>
					</DL>
				</DIV>
				<DIV class=su>
					<SPAN><INPUT id="btnAjaxSubmit" class=go type=submit
						value=""></SPAN><A href="#" target=_blank>忘记密码？</A> | <A href="#"
						target=_blank>密码重置</A>
				</DIV>
					<input name="user_language"  style="display:none;" value="ZHS">
			</FORM>
		</DIV>
		<DIV class=r></DIV>
		<P class=pr></P>
	</DIV>
	<script type="text/javascript">
		$(document).ready(
						function() {
							$("#btnAjaxSubmit").click(
											function() {
												var form = $("#loginForm");
												if (form.form('validate')) {
													var formrecord = $(form).form('serialize');
													EyMs.progress('Please waiting','Loading...');
													var options = {
														url : "toLogin.do?actionId=update@login&dataSorce=xml/sys_user_sql.xml",//form 提交
														type : 'post',
														dataType : 'text',
														//data: $("#loginForm").serialize(),
														data : {
															user_name : formrecord['user_name'],
															user_password : formrecord['user_password'],
															verifyCode : formrecord['verifyCode'],
															user_language : formrecord['user_language']
														},
														success : function(data) {
															EyMs.closeProgress();
															login.loadVrifyCode();//刷新验证码
															//a=JSON.parse(data);
															debugger;
															try{
																 var a=eval('('+data+')');
																if (a.success){
																	window.location.href = "initPage.shtml?uri=sys/sys_role_select";
																}else{
																	EyMs.alert('提示',a.msg,'error');
																}
															}catch(e){
																EyMs.alert('提示',data,'error');
															}
														},
														error : function(err) {
															EyMs.closeProgress();
															EyMs.alert('提示',err.responseText,'error');
														}
													};
													$.ajax(options);
												}
												return false;
							});
		      });

		login = function() {
			return {
				loadVrifyCode : function() {//刷新验证码
					var _url = "ImageServlet?time=" + new Date().getTime();//new Date().getTime()为了兼容ie
					//var _url = "ImageServlet";
					$("#img_id").attr('src', _url);
				},
				init : function() {
					if (window.top != window.self) {
						window.top.location = window.self.location;
					}
					//验证码图片绑定点击事件
					$("#img_id").click(this.loadVrifyCode);

					var form = $("#loginForm");
					//form.submit(this.toLogin);
				}
			}
		}();
		$(function() {
			login.init();
		});
	</script>
</body>
</html>
