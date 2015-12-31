$package('EyMs');
var lov_record;//lov全局变量,用来保存lov选择的record
var EyMs={
	/*Json 工具类*/
	isJson:function(str){
		var obj = null; 
		try{
			obj = EyMs.paserJson(str);
		}catch(e){
			return false;
		}
		var result = typeof(obj) == "object" && Object.prototype.toString.call(obj).toLowerCase() == "[object object]" && !obj.length; 
		return result;
	},
	paserJson:function(str){
		return eval("("+str+")");
	},
	/*弹出框*/
	alert:function(title, msg, icon, callback){
		$.messager.alert(title,msg,icon,callback);
	},
	/*弹出框*/
	confirm:function(title, msg,callback){
		$.messager.confirm(title,msg,callback);
	},
	progress:function(title,msg){
		 var win = $.messager.progress({  
            title: title ||'Please waiting',  
            msg: msg ||'Loading data...'  
         }); 
	},
	closeProgress:function(){
		$.messager.progress('close');
	},
	/*重新登录页面*/
	toLogin:function(){
		window.top.location= urls['msUrl']+"/login.shtml";
	},
	checkLogin:function(data){//检查是否登录超时
		if(data.logoutFlag){
			EyMs.closeProgress();
			EyMs.alert('提示',"登录超时,点击确定重新登录.",'error',EyMs.toLogin);
			return false;
		}
		return true;
	},
	ajaxSubmit:function(form,option){
		form.ajaxSubmit(option);
	},
	ajaxJson: function(url,option,callback){
		$.ajax(url,{
			type:'post',
			 	dataType:'json',
			 	data:option,
			 	success:function(data){
			 		//坚持登录
			 		if(!EyMs.checkLogin(data)){
			 			return false;
			 		}		 	
			 		if($.isFunction(callback)){
			 			callback(data);
			 		}
			 	},
			 	error:function(response, textStatus, errorThrown){
			 		try{
			 			EyMs.closeProgress();
			 			var data = $.parseJSON(response.responseText);
				 		//检查登录
				 		if(!EyMs.checkLogin(data)){
				 			return false;
				 		}else{
					 		EyMs.alert('提示', data.msg || "请求出现异常,请联系管理员",'error');
					 	}
			 		}catch(e){
			 			alert(e);
			 			EyMs.alert('提示',"请求出现异常,请联系管理员1",'error');
			 		}
			 	},
			 	complete:function(){
			 	
			 	}
		});
	},
	submitForm:function(form,callback,dataType){
			var option =
			{
			 	type:'post',
			 	dataType: dataType||'json',
			 	success:function(data){
			 		if($.isFunction(callback)){
			 			callback(data);
			 		}
			 	},
			 	error:function(response, textStatus, errorThrown){
			 		try{
			 			EyMs.closeProgress();
			 			var data = $.parseJSON(response.responseText);
				 		//检查登录
				 		if(!EyMs.checkLogin(data)){
				 			return false;
				 		}else{
					 		EyMs.alert('提示', data.msg || "请求出现异常,请联系管理员",'error');
					 	}
			 		}catch(e){
			 			alert(e);
			 			EyMs.alert('提示',"请求出现异常,请联系管理员1",'error');
			 		}
			 	},
			 	complete:function(){
			 	
			 	}
			 }
			 EyMs.ajaxSubmit(form,option);
	},
	saveForm:function(form,callback){
		if(form.form('validate')){
			EyMs.progress('Please waiting','Save ing...');
			//ajax提交form
			EyMs.submitForm(form,function(data){
				EyMs.closeProgress();
			 	if(data.success){
			 		if(callback){
				       	callback(data);
				    }else{
			       		EyMs.alert('提示','保存成功.','info');
			        } 
		        }else{
		       	   EyMs.alert('提示',data.msg,'error');  
		        }
			});
		 }
	},
	/**
	 * 
	 * @param {} url
	 * @param {} option {id:''} 
	 */
	getById:function(url,option,callback){
		EyMs.progress();
		EyMs.ajaxJson(url,option,function(data){
			EyMs.closeProgress();
			if(data.success){
				if(callback){
			       	callback(data);
			    }
			}else{
				EyMs.alert('提示',data.msg,'error');  
			}
		});
	},
	deleteForm:function(url,option,callback){
		EyMs.progress();
		EyMs.ajaxJson(url,option,function(data){
				EyMs.closeProgress();
				if(data.success){
					if(callback){
				       	callback(data);
				    }
				}else{
					EyMs.alert('提示',result.msg,'error');  
				}
		});
	}
}