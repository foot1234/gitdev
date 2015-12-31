$package('EyMs');
/* 自定义密码验证*/
$.extend($.fn.validatebox.defaults.rules, {  
    equals: {  
        validator: function(value,param){  
            return value == $(param[0]).val();  
        },  
        message: 'Field do not match.'  
    }  
});  

/*表单转成json数据*/
/*$.fn.serializeObject = function() {
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name]) {
            if (!o[this.name].push) {
                o[this.name] = [ o[this.name] ];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
}*/

/* easyui datagrid 添加和删除按钮方法*/
$.extend($.fn.datagrid.methods, {  
    addToolbarItem: function(jq, items){  
        return jq.each(function(){  
            var toolbar = $(this).parent().prev("div.datagrid-toolbar");
            for(var i = 0;i<items.length;i++){
                var item = items[i];
                if(item === "-"){
                    toolbar.append('<div class="datagrid-btn-separator"></div>');
                }else{
                    var btn=$("<a href=\"javascript:void(0)\"></a>");
                    btn[0].onclick=eval(item.handler||function(){});
                    btn.css("float","left").appendTo(toolbar).linkbutton($.extend({},item,{plain:true}));
                }
            }
            toolbar = null;
        });  
    },
    removeToolbarItem: function(jq, param){  
        return jq.each(function(){  
            var btns = $(this).parent().prev("div.datagrid-toolbar").children("a");
            var cbtn = null;
            if(typeof param == "number"){
                cbtn = btns.eq(param);
            }else if(typeof param == "string"){
                var text = null;
                btns.each(function(){
                    text = $(this).data().linkbutton.options.text;
                    if(text == param){
                        cbtn = $(this);
                        text = null;
                        return;
                    }
                });
            } 
            if(cbtn){
                var prev = cbtn.prev()[0];
                var next = cbtn.next()[0];
                if(prev && next && prev.nodeName == "DIV" && prev.nodeName == next.nodeName){
                    $(prev).remove();
                }else if(next && next.nodeName == "DIV"){
                    $(next).remove();
                }else if(prev && prev.nodeName == "DIV"){
                    $(prev).remove();
                }
                cbtn.remove();    
                cbtn= null;
            }                        
        });  
    }                 
});


//列拖拽实现 2014.3.5
$.extend($.fn.datagrid.methods,{
	_columnMoving: function(jq){
	    return jq.each(function(){
	        var target = this;
	        var cells = $(this).datagrid('getPanel').find('div.datagrid-header td[field]');
	        cells.draggable({
	            revert:true,
	            cursor:'pointer',
	            edge:5,
	            proxy:function(source){
	                var p = $('<div class="tree-node-proxy tree-dnd-no" style="position:absolute;border:1px solid #ff0000"/>').appendTo('body');
	                p.html($(source).text());
	                p.hide();
	                return p;
	            },
	            onBeforeDrag:function(e){
	                e.data.startLeft = $(this).offset().left;
	                e.data.startTop = $(this).offset().top;
	            },
	            onStartDrag: function(){
	                $(this).draggable('proxy').css({
	                    left:-10000,
	                    top:-10000
	                });
	            },
	            onDrag:function(e){
	                $(this).draggable('proxy').show().css({
	                    left:e.pageX+15,
	                    top:e.pageY+15
	                });
	                return false;
	            }
	        }).droppable({
	            accept:'td[field]',
	            onDragOver:function(e,source){
	                $(source).draggable('proxy').removeClass('tree-dnd-no').addClass('tree-dnd-yes');
	                $(this).css('border-left','1px solid #ff0000');
	            },
	            onDragLeave:function(e,source){
	                $(source).draggable('proxy').removeClass('tree-dnd-yes').addClass('tree-dnd-no');
	                $(this).css('border-left',0);
	            },
	            onDrop:function(e,source){
	                $(this).css('border-left',0);
	                var fromField = $(source).attr('field');
	                var toField = $(this).attr('field');
	                setTimeout(function(){
	                    moveField(fromField,toField);
	                    $(target).datagrid();
	                    $(target).datagrid('columnMoving');
	                },0);
	            }
	        });
	         
	        // move field to another location
	        function moveField(from,to){
	            var columns = $(target).datagrid('options').columns;
	            var cc = columns[0];
	            var c = _remove(from);
	            if (c){
	                _insert(to,c);
	            }
	             
	            function _remove(field){
	                for(var i=0; i<cc.length; i++){
	                    if (cc[i].field == field){
	                        var c = cc[i];
	                        cc.splice(i,1);
	                        return c;
	                    }
	                }
	                return null;
	            }
	            function _insert(field,c){
	                var newcc = [];
	                for(var i=0; i<cc.length; i++){
	                    if (cc[i].field == field){
	                        newcc.push(c);
	                    }
	                    newcc.push(cc[i]);
	                }
	                columns[0] = newcc;
	            }
	        }
	    });
	}
	});

/****************************************************************************/
/**
 * JQuery扩展方法，用户对JQuery EasyUI的DataGrid控件进行操作。
 */
//jquery resize div add by duanjian 
(function($,h,c){var a=$([]),e=$.resize=$.extend($.resize,{}),i,k="setTimeout",j="resize",d=j+"-special-event",b="delay",f="throttleWindow";e[b]=250;e[f]=true;$.event.special[j]={setup:function(){if(!e[f]&&this[k]){return false}var l=$(this);a=a.add(l);$.data(this,d,{w:l.width(),h:l.height()});if(a.length===1){g()}},teardown:function(){if(!e[f]&&this[k]){return false}var l=$(this);a=a.not(l);l.removeData(d);if(!a.length){clearTimeout(i)}},add:function(l){if(!e[f]&&this[k]){return false}var n;function m(s,o,p){var q=$(this),r=$.data(this,d);r.w=o!==c?o:q.width();r.h=p!==c?p:q.height();n.apply(this,arguments)}if($.isFunction(l)){n=l;return m}else{n=l.handler;l.handler=m}}};function g(){i=h[k](function(){a.each(function(){var n=$(this),m=n.width(),l=n.height(),o=$.data(this,d);if(m!==o.w||l!==o.h){n.trigger(j,[o.w=m,o.h=l])}});g()},e[b])}})(jQuery,this);
////
$.fn.extend({
 /**
  * 修改DataGrid对象的默认大小，以适应页面宽度。
  * 
  * @param heightMargin
  *            高度对页内边距的距离。
  * @param widthMargin
  *            宽度对页内边距的距离。
  * @param minHeight
  *            最小高度。
  * @param minWidth
  *            最小宽度。
  * 
  */
	resizeDataGrid : function(docWin,heightMargin, widthMargin, minHeight, minWidth) {
		  //var height = $(document.body).height() - heightMargin;
		  //var width = $(document.body).width() - widthMargin;
		 // var height =$(window).height() - heightMargin;
		  //var width = $(window).width() - widthMargin;
		  //alert($('#dgdiv').offset().left);
		  var height =$(docWin).height()-15 - heightMargin;
		  var width = $(docWin).width()-15 - widthMargin;

		  height = height < minHeight ? minHeight : height;
		  width = width < minWidth ? minWidth : width;

		  $(this).datagrid('resize', {
		  // height : height,
		   width : width
		  });
		 }
});



//combox 扩展，实现lov add by duanjian 2015.12.21
var lovdata=null;
$.fn.extend({
	 _setLovdata:function(data){
		 lovdata= data;
	 },
	_gridlov:function(param){
	  lovdata=null;
	  //param{title,id,url,index,field,width,height,callback}
	  var dg=$(this);		
	  var value=dg.datagrid('getRows')[param.index][param.field];
	  var ed = dg.datagrid('getEditor', { index: param.index, field: param.field});//获取角色编辑器
      $(ed.target).combobox({
    	 //required : true,  
    	 textField:'role_code',
      	 onShowPanel:function(){
 			 $(this).combobox('hidePanel');
 			 debugger;
 			  var parentdiv=$('<div></div>');        //创建一个父div
 			  parentdiv.attr('id',param.id);        //给div设置id
 			  
 			 parentdiv.window({
 				 width: param.width,
 		          modal: true,
 		          height: param.height,
 		         title:param.title,
 		         iconCls:'icon-search',
 		         href: param.url,
 		         onClose:function(){ //lov close 时设置值
 		        	 $("#"+param.id).remove();//删除div
 		           //var lov_data=window.lov_record;//接收lov选择的值
 		        	  var lov_data=lovdata;
            		     if( lov_data==null || lov_data==undefined ||lov_data==''){//说明没有选择值，直接关闭
            		    	 //dg.datagrid('getRows')[param.index][param.field] = v_role_code;//直接关闭恢复
            		    	 //dg.datagrid('updateRow',{index: param.index,row: {}});//如果为required：true 则需要更新行
            		     }else{
            		    	 param.callback(param.index,lov_data,ed);//调用回调函数
            		    	/* var v_role_code=dg.datagrid('getRows')[param.index]['role_code'];
            		    	 dg.datagrid('getRows')[param.index]['role_id'] = lov_data['role_id'];//隐藏域设置
            		    	 dg.datagrid('getRows')[param.index]['role_desc'] = lov_data['role_name'];
     		                    
     		                    var ed1=dg.datagrid('getEditor',{index:param.index,field:'role_code'});
  		                        ed1.actions.setValue(ed.target,lov_data['role_code']);//edit 赋值
  		                        
  		                      if(v_role_code==""||v_role_code==null||v_role_code==undefined){
  		                    	dg.datagrid('getRows')[param.index]['role_code'] = lov_data['role_code'];//新增赋值
  		                    	dg.datagrid('updateRow',{index: param.index,row: {}});//如果为required：true 则需要更新行
          		                }*/
            		    	 //$('#dg1we').datagrid('updateRow',{index: rowIndex,row: {}});//如果为required：true 则需要更新行
   			        	     }
            		     debugger;
            		    dg.datagrid('endEdit', param.index);
 		                
 		            }
 			 });
     	 }
     });//替换text为combogrid编辑器，注意如果要根据当前行的某些数据加载不同的内容，需要动态修改配置中的url
     $(ed.target).combobox('setValue',value);//grid lov bug问题解决(点击输入框原内容消失)
    }
});
/**
 * 扩展grid保存 
 *避免前台js太大，太多
 *只支持grid保存
 *add by duanjian 2014.4.9
 */
var grid_initial_data=[];
var dataChanges={};//grid 数据变化对象
$.fn.extend({
	 _initdata:function(data){
		var rows= data.rows;
		for (var i=0;i<rows.length;i++){
        	 var obj2=new Object(); 
        	  for(var p in rows[i]) 
            	{ 
        		  debugger;
            	var name=p;//属性名称 
            	var value=rows[i][p];//属性对应的值 
            	obj2[name]=rows[i][p]; 
            	} 
        	  grid_initial_data.push(obj2);
         }    
	 },
	 _getinitdata:function(){
			return grid_initial_data;
	 },
	 _clearinitdata:function(){
		   grid_initial_data=[];
	},
	_getDataChanges:function(){
			return dataChanges;
	 },
	_checkSave:function(){
		   var dg=$(this);	
		   var initdata=this._getinitdata().slice(0);//获取原始数据		 
	 	   var rows =  dg.datagrid('getRows');
	 	//   debugger;
	 	    //保存验证
	 	            var columns=  dg.datagrid('options').columns[0];
	 		 		var insertData=[];
	 		 		var updateData=[];
	 		 		var deleteData=[];
	 		    	 for(var i=0;i<rows.length;i++){
	 		    		  var alert_field_title=null;
	 		    		  var rowindex=null;
	 		    		   var index=dg.datagrid('getRowIndex', rows[i]);
	 		    		     //dg.datagrid('unselectRow', index);
	 		    		    //dg.datagrid('updateRow',{index: index,row: {}});//如果为required：true 则需要更新行
	 		    		    // dg.datagrid('refreshRow', index);
	 		    		       dg.datagrid('endEdit', index);//关闭编辑行
	 		    		      dg.datagrid('refreshRow', index);//刷新编辑行
	 		    		     // debugger;
		 		 		      for(var j=0;j<columns.length;j++){
				 		    		v_required=false;
				 		    		var field=columns[j].field;
				 		    		var title=columns[j].title;
				 		    		try{
				 		    		   v_required=columns[j].editor.options.required;
				 		    		}catch(e){
				 		    			try{
				 		    		       v_required=columns[j].editor.required;
				 		    		       }catch(e){}
				 		    		}
				 		    		if(v_required){//必输项则校验是否有值
					 		    		//  debugger;
						    		      var value=dg.datagrid('getRows')[index][field] ;
						    		      if(value==""||value==null||value==undefined){
						    		    	 rowindex= index;
						    		    	 alert_field_title=title;
						    		    	break;  
						    		      }
				 		        }
		 		       		}
		 		 		 if(alert_field_title){
					 		 // debugger;
					 		 dg.datagrid('selectRow', rowindex);
					 		 $.messager.alert("提示", "["+alert_field_title+"]为必输字段!", "error");
					 		  return false;
					 		  break;  
					 	    }	
		 		 		 
		 		 		var rn=rows[i]['rn'];
		 		 		if(rn==''||rn==null||rn==undefined){
		 		 			//新增
		 		 			 //debugger;
		 		 			insertData.push(rows[i]);
		 		 		}else{ 
		 		 			//debugger;
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
	 		  var deleted = dg.datagrid('getChanges', "deleted");
	 		   //有变动的数据
	 		    dataChanges={"inserted":insertData,"updated":updateData,"deleted":deleted};
	 		    //debugger;	 
	 		   dg._clearinitdata();//清除原始数据 
	 		 return true;   
	}
});

//grid enableCellEditing ，enableRowEditing编辑器 add by duanjian 2015.12.18
//var editIndex = undefined;//grid row编辑初始化开始
$.extend($.fn.datagrid.methods, {
	editCell: function(jq,param){
		return jq.each(function(){
			var opts = $(this).datagrid('options');
			var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
			for(var i=0; i<fields.length; i++){
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor1 = col.editor;
				if (fields[i] != param.field){
					col.editor = null;
				}
			}
			$(this).datagrid('beginEdit', param.index);
            var ed = $(this).datagrid('getEditor', param);
            if (ed){
                if ($(ed.target).hasClass('textbox-f')){
                    $(ed.target).textbox('textbox').focus();
                } else {
                    $(ed.target).focus();
                }
            }
			for(var i=0; i<fields.length; i++){
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor = col.editor1;
			}
		});
	},
    _enableCellEditing: function(jq){
        return jq.each(function(){
            var dg = $(this);
            var opts = dg.datagrid('options');
            
            dg._clearinitdata();//清除原始数据 
            
            debugger;
            opts.oldOnClickCell = opts.onClickCell;
            opts.onClickCell = function(index, field){
            	
            	// debugger;
                 if(grid_initial_data.length<=0){
             		//编辑前保存历史数据
                 	debugger;
                 	var rows=$(dg).datagrid('getRows');
                 	for (var i=0;i<rows.length;i++){
 	                	 var obj2=new Object(); 
 	                	  for(var p in rows[i]) 
 	                    	{ 
 	                		//  debugger;
 	                    	var name=p;//属性名称 
 	                    	var value=rows[i][p];//属性对应的值 
 	                    	obj2[name]=rows[i][p]; 
 	                    	} 
 	                	  grid_initial_data.push(obj2);
                 	}    
          		 }
                debugger;
            	
                if (opts.editIndex != undefined){
                    if (dg.datagrid('validateRow', opts.editIndex)){
                        dg.datagrid('endEdit', opts.editIndex);
                        opts.editIndex = undefined;
                    } else {
                        return;
                    }
                }
             /* dg.datagrid('editCell', {
                    index: index,
                    field: field
                }).datagrid('selectRow', index);*/
                dg.datagrid('editCell', {
                    index: index,
                    field: field
                });
               
                debugger;
                opts.editIndex = index;
                opts.oldOnClickCell.call(this, index, field);
            }
        });
    },
    _enableRowEditing:function(jq){
        debugger;
        return jq.each(function(){
            var dg = $(this);
            var opts = dg.datagrid('options');
            debugger;
            opts.oldonSelect = opts.onSelect;
            
            dg._clearinitdata();//清除原始数据 
            
            opts.onSelect=function(index, data){
                debugger;
                if(grid_initial_data.length<=0){
            		//编辑前保存历史数据
                //	debugger;
                	var rows=$(dg).datagrid('getRows');
                	for (var i=0;i<rows.length;i++){
	                	 var obj2=new Object(); 
	                	  for(var p in rows[i]) 
	                    	{ 
	                		//  debugger;
	                    	var name=p;//属性名称 
	                    	var value=rows[i][p];//属性对应的值 
	                    	obj2[name]=rows[i][p]; 
	                    	} 
	                	  grid_initial_data.push(obj2);
                	}    
         		 }
                if (opts.editIndex == undefined){
                   opts.editIndex =index;
               	   dg.datagrid('beginEdit', index);
                } else if (dg.datagrid('validateRow', opts.editIndex)){
                		debugger;
                        dg.datagrid('endEdit', opts.editIndex);
                        opts.editIndex = undefined;
                        opts.editIndex =index;
                    	dg.datagrid('beginEdit', index);
                }else{
                  dg.datagrid('selectRow', opts.editIndex);
                }
                opts.oldonSelect.call(this, index, data);
            }

        });
    } 
});  
/*grid 动作处理 新增（add和insert），保存，删除，清除 addby duanjian 2015.12.28*/
$.fn.extend({
	_gridAdd : function(row_init){//新增
		debugger;
		       $(this).datagrid('appendRow',row_init);//{is_access_checked:1,is_login_required:1}  
	},
    _gridInsert : function(row_init){//添加
		       $(this).datagrid('insertRow',{index:0,row:row_init});//{is_access_checked:1,is_login_required:1}  		    }
	},
	_gridSave : function(url,action,alert_flag){
		 var thisGrid=$(this);
		 var return_flag=true;
		  if($(this)._checkSave()){
				  var saveData=$(this)._getDataChanges();//获取
	               var inserted = saveData["inserted"];
			       var deleted = saveData["deleted"];
			       var updated = saveData["updated"];
		           if (deleted.length) {
			        	if(action==null||action==""||action==undefined){
			      			 action="del";
			      		 }
		        	   return_flag=$(this).updatePost(deleted,action,url);// 执行删除
		               }
			      if (updated.length) {
			    	  if(action==null||action==""||action==undefined){
			      			 action="edit";
			      		 }
			    	  return_flag=$(this).updatePost(updated,action,url);// 执行更新
			         }
		          if (inserted.length) {
		        	  if(action==null||action==""||action==undefined){
			      			 action="add";
			      		 }
			        	  for(var i=0;i<inserted.length;i++){
			        		  var $index=$(this).datagrid('getRowIndex', inserted[i]);
			        		  inserted[i]['index_s']=$index;
			        	  }
		        	  return_flag=$(this).updatePost(inserted,action,url,thisGrid);// 执行插入
		        	  }
		          $(this).datagrid('acceptChanges'); //界面数据提交
			  }else{
				  //$.messager.alert("提示", "没有数据需要保存!", "error");
			  }
		 
		  if(return_flag&&alert_flag){
			  $.messager.alert("提示", "操作成功!", "info");
		  }
		  return return_flag;
		},
		updatePost: function(records,action_id,url,thisGrid){
			if(records.length > 0){
				var rows=JSON.stringify(records);   //对象数组转换为json
				var return_s=false;
				debugger;
			     $.ajax({
						   type: "POST",
						   async: false, //同步请求
						   url: "ToDoGo.do?actionId=update/batch@"+action_id+"&dataSorce="+url,
						   data: { _para:rows},// _para 代表数组json数据传入，为内定参数
						   dataType : 'json', 
						   success: function(data){
							   debugger;
							   if(thisGrid==null ||thisGrid==''||thisGrid==undefined){}else{
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
											   $(thisGrid).datagrid('updateRow',{index: index_s,row: rows[i]});
										   }
								   }
								  /* for (var i=0;i<re_data.length;i++){
									  var index_s=re_data[i]['index_s'];
									  var parameter_code=re_data[i]['parameter_code'];
									  var parameter_value=re_data[i]['parameter_value'];
									  var ed = $(thisGrid).datagrid('getEditor', { index: index_s, field: parameter_code });
									 $(thisGrid).datagrid('getRows')[index_s][parameter_code] = parameter_value;
									   $(thisGrid).datagrid('endEdit', index_s);
									 
								   }*/
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
});
/*var editIndex = undefined;//grid 编辑初始化开始
var obj_fun=undefined; //用于combox、 lov  等动态特殊js的处理 
$.fn.extend({
	endEditing : function(){//关闭编辑行
	    if (editIndex == undefined){return true;}
        if ($(this).datagrid('validateRow', editIndex)){
        	if(obj_fun==null||obj_fun==undefined||obj_fun==""){}else//用于combox、 lov  等动态特殊js的处理 
	        	{obj_fun. init(editIndex);}
        	$(this).datagrid('endEdit', editIndex);
            editIndex = undefined;
            return true;
        } else {
            return false;
        }	
	},
	gridAdd : function(row_init,obj){//新增
		 obj_fun=obj;
		 if ($(this).endEditing()){
		       $(this).datagrid('insertRow',{index:0,row:row_init});//{is_access_checked:1,is_login_required:1}  
		    }
		  $(this).datagrid('updateRow',{index:0,row: {}});//实现一次可以多增几行
	},
	gridEdit : function(index,obj){//编辑
		 obj_fun=obj;
		if (editIndex != index){
            if ($(this).endEditing()){
                $(this).datagrid('beginEdit', index);
                editIndex = index;
            } else {
                $(this).datagrid('selectRow', editIndex);
            }
        $(this).datagrid('unselectRow', index);
	  }	
	},
	checkSave:function(){//保存前数据校验,必输项等的校验
		 var rows = $(this).datagrid('getChanges');
		   var flag=false;
		   var check_flag=false;
		    //保存验证
			    for(var i=0;i<rows.length;i++){
			    	var index=$(this).datagrid('getRowIndex', rows[i]);
			    	$(this).datagrid('selectRow', index);
			        if($(this).datagrid('validateRow', index))
			        {
			        	check_flag=true;
			        }else
			        {
			        	check_flag=false;
			        	break;
			        }
			       $(this).datagrid('endEdit', index);
			    }
			    if(check_flag==true){
			    	flag=true;
			    }
		   return flag;
	},
	gridSave : function(url,action){
	 $(this).endEditing();	//关闭编辑行
	 var thisGrid=$(this);
	 var return_flag=true;
	  if($(this).checkSave()){
	        var inserted = $(this).datagrid('getChanges', "inserted");
	        var deleted = $(this).datagrid('getChanges', "deleted");
	        var updated = $(this).datagrid('getChanges', "updated");  
	       
	           if (deleted.length) {
		        	if(action==null||action==""||action==undefined){
		      			 action="del";
		      		 }
	        	   return_flag=$(this).updatePost(deleted,action,url);// 执行删除
	               }
		      if (updated.length) {
		    	  if(action==null||action==""||action==undefined){
		      			 action="edit";
		      		 }
		    	  return_flag=$(this).updatePost(updated,action,url);// 执行更新
		         }
	          if (inserted.length) {
	        	  if(action==null||action==""||action==undefined){
		      			 action="add";
		      		 }
		        	  for(var i=0;i<inserted.length;i++){
		        		  var $index=$(this).datagrid('getRowIndex', inserted[i]);
		        		  inserted[i]['index_s']=$index;
		        	  }
	        	  return_flag=$(this).updatePost(inserted,action,url,thisGrid);// 执行插入
	        	  }
	          $(this).datagrid('acceptChanges'); //界面数据提交
	           if(return_flag){
	        	   editIndex = undefined;
	        	   //$.messager.alert("提示", "操作成功!", "info");
	           }
		  }else{
			  //$.messager.alert("提示", "没有数据需要保存!", "error");
		  }
	  return return_flag;
	},
	updatePost: function(records,action_id,url,thisGrid){
		if(records.length > 0){
			var rows=JSON.stringify(records);   //对象数组转换为json
			var return_s=false;
			debugger;
		     $.ajax({
					   type: "POST",
					   async: false, //同步请求
					   url: "ToDoGo.do?actionId=update/batch@"+action_id+"&dataSorce="+url,
					   data: { _para:rows},// _para 代表数组json数据传入，为内定参数
					   dataType : 'json', 
					   success: function(data){
						   debugger;
						   if(thisGrid==null ||thisGrid==''||thisGrid==undefined){}else{
							   var re_data=data.rows;//返回值赋值
							   for (var i=0;i<re_data.length;i++){
								  var index_s=re_data[i]['index_s'];
								  var parameter_code=re_data[i]['parameter_code'];
								  var parameter_value=re_data[i]['parameter_value'];
								  var ed = $(thisGrid).datagrid('getEditor', { index: index_s, field: parameter_code });
								 $(thisGrid).datagrid('getRows')[index_s][parameter_code] = parameter_value;
								   $(thisGrid).datagrid('endEdit', index_s);
								   //$(thisGrid).datagrid('updateRow',{index: index_s,row: {}});
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
	},
	gridRemove:function(url,action){
		 var rows = $(this).datagrid('getSelections');
		 var thisGrid=$(this);
		 if(action==null||action==""||action==undefined){
			 action="del";
		 }
		 //选择要删除的行
	         if (rows.length > 0) {
	             $.messager.confirm("提示", "你确定要删除吗?", function (cmp) {
	            	if(cmp){
	            		 for(var i=0;i<rows.length;i++){
			        		  var index=thisGrid.datagrid('getRowIndex',rows[i]);
			        		  thisGrid.datagrid('deleteRow', index);
			             }
	            	    //$(g_table_id).datagrid('acceptChanges'); //界面数据提交
	            		 var deleted = thisGrid.datagrid('getChanges', "deleted");
	            		 debugger;
	            		 if (deleted.length) {
	            			 if(thisGrid.updatePost(deleted,action,url)){// 执行删除
		                    	 $.messager.alert("提示", "操作成功!", "info");
		                     } 
	      	               }   
			       }  
	         });
	     }
	     else {
	         $.messager.alert("提示", "请选择要删除的行!", "error");
	     }
	},
	gridClean:function(){
		 var rows = $(this).datagrid('getSelections');
		 var thisGrid=$(this);
		 //选择要删除的行
	         if (rows.length > 0) {
	            		 for(var i=0;i<rows.length;i++){
			        		  var index=thisGrid.datagrid('getRowIndex',rows[i]);
			        		  thisGrid.datagrid('deleteRow', index);
			             } 	
	           }
	  }

});	*/
//end  扩展grid保存

//begin form 保存
var g_old_this_editForm="";
$.fn.extend({
	formLoad:function(row){
		$(this).form('load',row);
		g_old_this_editForm=$(this).form('serialize');////获取form的全部数据,保存历史数据用于头行保存校验 
    },
	formSave:function(uri,action_id){
	debugger;
	var form=this;
	var save_url="ToDoGo.do?actionId=update@"+action_id+"&dataSorce="+uri;
	var v_return=false;
	//1校验必输域
	 if(!$(form).form('validate'))
	{
		return; 
     }
	 var formrecord=$(form).form('serialize');//form数据
	 
	 //查看数据是否有变化
	 var equal=equalObject(formrecord,g_old_this_editForm,true);//判断头数据是否有改变
	 if(equal){ //无变化直接返回
		 v_return=true;
	 }
	 else{
		  var rows="["+JSON.stringify(formrecord)+"]";   //对象数组转换为json
		     $.ajax({
				   type: "POST",
				   async: false, //同步请求
				   url: save_url,
				   data: { _para:rows},// _para 代表数组json数据传入，为内定参数
				   dataType : 'json', 
				   success: function(data){
					   v_return=true;
				   }, error: function(err){
					   v_return=err.responseText;
					   EyMs.alert('提示',err.responseText,'error');  
				   }
			});	
	   }
	     return v_return;   
    }
});
//end form 保存


//扩展formgetValue
$.extend($.fn.form.methods, {  
    serialize: function(jq){  
        var arrayValue = $(jq[0]).serializeArray();
        var json = {};
        debugger;
//------------------------------------------------------------------------------//
        $.each(arrayValue, function() {
        	//debugger;
            var item = this;
            if (json[item["name"]]) {
                json[item["name"]] = json[item["name"]] + "," + item["value"];
            } else {
                json[item["name"]] = item["value"];
            }
        });
       
        return json; 
    },
    getValue:function(jq,name){  
        var jsonValue = $(jq[0]).form("serialize");
        return jsonValue[name]; 
    },
    setValue:function(jq,name,value){
        return jq.each(function () {
                //_b(this, _29);
                var data = {};
                //data[name] = value;
                data = name;
                //debugger;
                $(this).form("load",data);
        });
    }   
});
/*用法
 * $('form').form('serialize');
$('form').form('getValue','a'); //获取表单中name=a 的元素值 
$('form').form('setValue',{'name':'a'}); //赋值给表单中name=a 的元素值
*/

//控制只能输入大写
$.extend($.fn.validatebox.defaults.rules, {    
    checkUpper: {    
        validator: function(value){  
            var reg = /^[A-Z_0-9]+$/  
            return reg.test(value);    
        },    
        message: '只能输入大写字母和数字'   
    }
});   

  
/*  
 * Datagrid扩展方法tooltip 基于Easyui 1.3.3，可用于Easyui1.3.3+  
 * 简单实现，如需高级功能，可以自由修改  
 * 使用说明:  
 *   在easyui.min.js之后导入本js  
 *   代码案例:  
 *      $("#dg").datagrid({....}).datagrid('tooltip'); 所有列  
 *      $("#dg").datagrid({....}).datagrid('tooltip',['productid','listprice']); 指定列  
 * @author ____′↘夏悸  
 */ 

$.extend($.fn.datagrid.methods, {  
    tooltip : function (jq, fields) {  
        return jq.each(function () {  
            var panel = $(this).datagrid('getPanel');  
            if (fields && typeof fields == 'object' && fields.sort) {  
                $.each(fields, function () {  
                    var field = this;  
                    bindEvent($('.datagrid-body td[field=' + field + '] .datagrid-cell', panel));  
                });  
            } else {  
                bindEvent($(".datagrid-body .datagrid-cell", panel));  
            }  
        });    
function bindEvent(jqs) {  
        jqs.mouseover(function () {  
               var content = $(this).text();  
               if(content){
		                $(this).tooltip({  
		                    content : content, 
		                      trackMouse : true,
		                     onHide : function () {  
		                        $(this).tooltip('destroy');  
		                    }, 
		                    //hideEvent: 'none',
		                    showDelay:1000,
		                    onShow: function(){
		                        $(this).tooltip('tip').css({
		                            backgroundColor: '#9393FF',
		                            borderColor: '#666'
		                        });
		                    }
		                  /*  onShow: function(){
		                        var t = $(this);
		                        t.tooltip('tip').focus().unbind().bind('blur',function(){
		                            t.tooltip('hide');
		                        });
		                    }*/
		                }).tooltip('show');  
		        }    
        });  
        }  
    }  
}); 

//只读和非只读扩展 add by duanjian 2015.12.17
$.fn.extend({
	 readOnly:function(value){
		// alert(12);
		 debugger;
		 var v_class= $(this).attr("class");
		 var reg = /combo/g;//匹配中间有combo的单词。g为模式增强符，表示全局匹配
		  //var v=v_class.match(reg);
		  if(v_class.match(reg)){//combox 设置只读和非只读
			  if(!value){
			    $(this).combobox('enable');
			    $(this).removeClass("readonly");
			 }else{
				$(this).combobox('disable');
				$(this).addClass("readonly");
			 }
		  }else{//input 设置只读 class -->readonly 在base.css
			 $(this).attr('readonly',value);
			 if(value){
				 $(this).attr("data-options","required:false");//取消必输
		         $(this).addClass("readonly");
			 }else{
			   $(this).removeClass("readonly");
			 }
		 }
		 debugger;
	},
	_gridRead:function(index,field){
		 var cellEdit = $(this).datagrid('getEditor', { index:index, field: field});//获取角色编辑器
		   debugger;
			 if(cellEdit){
				 var $input = cellEdit.target;
	            // $input.prop('readonly',true); // 设值只读  
	             //$input.combobox('disable'); // 设值只读  
				 return $input;
	             //$input.readOnly(true);
			  }else{
				  return $(this);
			  }
			 
	}
});	
