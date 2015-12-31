<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>费用报销管理系统</title>
<%@include file="/view/base/resource.jsp"%>
<!-- <link rel="stylesheet" type="text/css" href="${msUrl}/css/main.css">  -->
<link rel="stylesheet"
	href="css/zTree-css-v3.5.15/zTreeStyle/zTreeStyle.css" type="text/css">
<!-- ztree css -->
<style type="text/css">
.ui-header {
	background: url("images/layout-browser-hd-bg.gif") repeat-x center;
	font-family: 'lucida grande', tahoma, arial, sans-serif;
	font-weight: bold;
	color: white;
}

.ui-header h1 {
	background: url("images/logo/component.png") no-repeat left;
	font-size: 16px;
	color: white;
	font-weight: normal;
	padding: 5px 10px;
	float: left;
	font-weight: bold;
	margin-left: 10px;
	text-indent: 20px
}

.ui-login {
	float: right;
	padding: 10px;
	/*margin-right: 10px;*/
}

.ui-query {
	float: right;
	padding: 6px;
}

.ui-login a {
	color: #D7E8F7
}

.ui-login .ui-login-bar {
	text-align: right;
}
</style>
<!--  <script type="text/javascript" src="${msUrl}/js/ux/main/main.js"></script> -->
<!-- <script type="text/javascript" src="${msUrl}/js/zTree-js-v3.5.15/jquery-1.4.4.min.js"></script> ztree js -->
<script type="text/javascript"
	src="js/zTree-js-v3.5.15/jquery.ztree.core-3.5.js"></script>
<!-- ztree js -->
<script type="text/javascript">
	var zTree;
	/* 	var demoIframe;
	 var g_treeId; */
	var g_nodes;
	var g_treeNode;
	var setting = {
		view : {
			dblClickExpand : false,
			showLine : true,
			selectedMulti : false
		},
		data : {
			key : {
				title : 'function_code' //设置鼠标悬停显示function_code
			},
			simpleData : {
				enable : true,
				idKey : "id",
				pIdKey : "pid",
				rootPId : ""
			}
		},
		callback : {
			beforeClick : function(treeId, treeNode) {
				zTree = $.fn.zTree.getZTreeObj("tree");
				g_treeNode = treeNode;
				if (treeNode.isParent) {
					zTree.expandNode(treeNode);
					return false;
				} else {
					//demoIframe.attr("src",treeNode.file + ".html");
					//功能页以tab的形式展示
					content_view(treeNode);

					/*	var boxId1 = '#tab-box';
						var _title=treeNode.function_code;
					var _url="initPage.shtml?uri="+treeNode.files;
					if($(boxId1).tabs('exists',_title) ){
							var tab = $(boxId1).tabs('getTab',_title);
							var index = $(boxId1).tabs('getTabIndex',tab);
							$(boxId1).tabs('select',index);
							if(tab && tab.find('iframe').length > 0){  
								 var _refresh_ifram = tab.find('iframe')[0];  
							     _refresh_ifram.contentWindow.location.href=_url;  
						    } 
						}else{		
							var _content1 ="<iframe id='testIframe' scrolling='auto' frameborder='0' src='"+_url+"' style='width:100%; height:100%'></iframe>";
							$(boxId1).tabs('add',{
								    title:_title,
								    content:_content1,
								    closable:true}); 
						    }*/

					return true;
				}
			}
		}
	};
	//功能展开逻辑
	function content_view(treeNode) {
		var boxId1 = '#tab-box';
		var _title = treeNode.function_code;
		var _url = "initPage.shtml?uri=" + treeNode.files;
		if ($(boxId1).tabs('exists', _title)) {
			var tab = $(boxId1).tabs('getTab', _title);
			var index = $(boxId1).tabs('getTabIndex', tab);
			$(boxId1).tabs('select', index);
			if (tab && tab.find('iframe').length > 0) {
				var _refresh_ifram = tab.find('iframe')[0];
				_refresh_ifram.contentWindow.location.href = _url;
			}
		} else {
			var _content1 = "<iframe id='testIframe' scrolling='auto' frameborder='0' src='"
					+ _url + "' style='width:100%; height:100%'></iframe>";
			$(boxId1).tabs('add', {
				title : _title,
				content : _content1,
				closable : true
			});
		}
	}

	var main_init = function() {
		//头信息取得
		$.ajax({
					type : "POST",
					url : "ToDoGo.do?actionId=query/form@user&dataSorce=xml/sys_menu_main.xml",
					data : {},
					dataType : 'json',
					success : function(msg) {
						var rows = msg;
						//debugger;
						document.getElementById("nickName_id").innerHTML = rows['description'];
						document.getElementById("loginCount_id").innerHTML = rows['logincount'];
						//document.getElementById("user_id").innerHTML=rows[0]['user_id'];
					},
					error : function(msg) {
						debugger;
						$.messager.alert("提示", msg.responseText, "error");
					}
				});
		//角色选择//初始化
		$.ajax({
					type : "POST",
					url : "ToDoGo.do?actionId=query/form@list&dataSorce=xml/sys_user_last_login_info.xml",
					data : {},
					dataType : 'json',
					success : function(msg) {
						var rows = msg;
						//debugger; id="role_name_id" 
						$("#role_name_id").combobox('setValue',
								rows['role_company_name']);//
						$("#role_id_id").val(rows['role_id']);
						$("#company_id_id").val(rows['company_id']);
					},
					error : function(msg) {
						$.messager.alert("提示", msg.responseText, "error");
					}
				});
		//导航菜单
		var t = $("#tree");
		$.ajax({
					type : "POST",
					url : "ToDoGo.do?actionId=query@ztree&dataSorce=xml/sys_menu_main.xml",
					data : {
						page : 1,
						rows : 1000
					},
					dataType : 'json',
					success : function(msg) {
						var nodes = msg.rows;
						g_nodes = nodes;
						$.fn.zTree.init(t, setting, nodes);
					},
					error : function(msg) {
						$.messager.alert("提示", msg.responseText, "error");
					}
				});
	
	}

	var modifyInit = {
		modifyPwd : function() {
			var pwdForm = $("#pwdForm");
			if (pwdForm.form('validate')) {
				var newPwd = $('#newPwd').val();
				var rpwd = $('#rpwd').val();
				if (newPwd != rpwd) {
					EyMs.alert('提示', '新密码输入不一致!', 'error');
					return;
				}
				EyMs.saveForm(pwdForm, function(data) {
					EyMs.alert('提示', '修改成功!', 'info');
					$('#modify-pwd-win').dialog('close');
					pwdForm.resetForm();
				});
			}
		},
		init : function() {
			//修改密码绑定事件
			$('.modify-pwd-btn').click(function() {
				$('#modify-pwd-win').dialog('open');
			});
			$('#btn-pwd-close').click(function() {
				$('#modify-pwd-win').dialog('close');
			});
			$('#btn-pwd-submit').click(this.modifyPwd);

		}
	};
	//zNodes =[{"id":"3","pid":"null","open":"false","name":"公司级基础数据定义","files":"null","rn":"1"},{"id":"7","pid":"null","open":"false","name":"基础设置","files":"null","rn":"2"},{"id":"8","pid":"null","open":"false","name":"系统设置","files":"null","rn":"3"},{"id":"15","pid":"null","open":"false","name":"组织架构设置","files":"null","rn":"4"},{"id":"18","pid":"null","open":"false","name":"事件设置","files":"null","rn":"5"},{"id":"19","pid":"null","open":"false","name":"JOB计划设置","files":"null","rn":"6"},{"id":"31","pid":"15","open":"false","name":"员工定义","files":"modules/exp/EXP1050/exp_employees.screen","rn":"7"},{"id":"33","pid":"15","open":"false","name":"员工级别定义","files":"modules/exp/EXP1030/employee_level_definition.screen","rn":"8"},{"id":"37","pid":"8","open":"false","name":"邮件服务器设置","files":"modules/sys/SYS1030/sys_mail_server.screen","rn":"9"},{"id":"38","pid":"8","open":"false","name":"参数指定-用户","files":"modules/sys/SYS1130/sys_parameter_value_for_user.screen","rn":"10"},{"id":"41","pid":"7","open":"false","name":"币种定义","files":"modules/gld/FND1070/gld_currency.screen","rn":"11"},{"id":"42","pid":"15","open":"false","name":"员工组定义","files":"modules/exp/EXP1060/exp_employee_group.screen","rn":"12"},{"id":"51","pid":"3","open":"false","name":"公司级物品主文件定义","files":"modules/fnd/FND2320/fnd_company_items.screen","rn":"13"},{"id":"73","pid":"8","open":"false","name":"系统日志","files":"modules/sys/SYS1009/sys_log.screen","rn":"14"},{"id":"75","pid":"8","open":"false","name":"系统分析","files":"modules/sys/SYS2520/sys_analytics.screen","rn":"15"},{"id":"79","pid":"8","open":"false","name":"BM测试","files":"modules/debug/bm.screen","rn":"16"},{"id":"84","pid":"8","open":"false","name":"个性化集维护","files":"modules/sys/SYS2510/sys_customization_head_maintain.screen","rn":"17"},{"id":"113","pid":"8","open":"false","name":"报表定义","files":"modules/sys/SYS2850/sys_report.screen","rn":"18"},{"id":"122","pid":"15","open":"false","name":"跨公司部门层级关系维护","files":"modules/fnd/FND2000/fnd_inter_company_unit.screen","rn":"19"},{"id":"143","pid":"3","open":"false","name":"公司级维值定义","files":"modules/fnd/FND2230/fnd_company_dimension_value.screen","rn":"20"},{"id":"145","pid":"15","open":"false","name":"员工查询","files":"modules/exp/EXP3050/exp_employee_s_query.screen","rn":"21"},{"id":"154","pid":"18","open":"false","name":"事件消息模板维护","files":"modules/sys/SYS2020/sys_notify.screen","rn":"22"},{"id":"155","pid":"3","open":"false","name":"经营单位定义","files":"modules/fnd/FND2030/fnd_operation_units.screen","rn":"23"},{"id":"156","pid":"15","open":"false","name":"级别系列定义","files":"modules/exp/EXP1200/exp_level_series.screen","rn":"24"},{"id":"157","pid":"3","open":"false","name":"责任中心定义","files":"modules/fnd/FND2110/fnd_responsibility_centers.screen","rn":"25"},{"id":"158","pid":"15","open":"false","name":"岗位组定义","files":"modules/exp/EXP1100/exp_position_groups.screen","rn":"26"},{"id":"159","pid":"15","open":"false","name":"部门定义","files":"modules/exp/EXP1010/exp_org_unit.screen","rn":"27"},{"id":"163","pid":"8","open":"false","name":"页面注册","files":"modules/sys/SYS8040/sys_service.screen","rn":"28"},{"id":"164","pid":"8","open":"false","name":"功能定义","files":"modules/sys/SYS8010/sys_function.screen","rn":"29"},{"id":"165","pid":"8","open":"false","name":"功能分配","files":"modules/sys/SYS1003/sys_role_function.screen","rn":"30"},{"id":"166","pid":"8","open":"false","name":"用户定义","files":"modules/sys/SYS8210/sys_user.screen","rn":"31"},{"id":"167","pid":"8","open":"false","name":"角色定义","files":"modules/sys/SYS8110/sys_role.screen","rn":"32"},{"id":"168","pid":"8","open":"false","name":"模块定义","files":"modules/sys/SYS8030/sys_module.screen","rn":"33"},{"id":"169","pid":"8","open":"false","name":"消息代码维护","files":"modules/sys/SYS1020/sys_messages.screen","rn":"34"},{"id":"170","pid":"18","open":"false","name":"事件维护","files":"modules/sys/EVT2010/evt_event.screen","rn":"35"},{"id":"173","pid":"15","open":"false","name":"部门级别定义","files":"modules/exp/EXP1120/exp_org_unit_levels.screen","rn":"36"},{"id":"174","pid":"15","open":"false","name":"部门类型定义","files":"modules/exp/EXP1011/exp_org_unit_types.screen","rn":"37"},{"id":"175","pid":"15","open":"false","name":"员工类型定义","files":"modules/exp/EXP1210/exp_employee_types.screen","rn":"38"},{"id":"176","pid":"15","open":"false","name":"部门组定义","files":"modules/exp/EXP1110/exp_org_unit_groups.screen","rn":"39"},{"id":"177","pid":"15","open":"false","name":"员工职务定义","files":"modules/exp/EXP1040/exp_employee_jobs.screen","rn":"40"},{"id":"178","pid":"15","open":"false","name":"岗位定义","files":"modules/exp/EXP1020/exp_org_position.screen","rn":"41"},{"id":"183","pid":"7","open":"false","name":"编码规则定义","files":"modules/fnd/FND1910/fnd_coding_rule_objects.screen","rn":"42"},{"id":"189","pid":"8","open":"false","name":"系统描述","files":"modules/sys/SYS1004/sys_prompt.screen","rn":"43"},{"id":"190","pid":"8","open":"false","name":"系统代码维护","files":"modules/sys/SYS1010/sys_code.screen","rn":"44"},{"id":"224","pid":"7","open":"false","name":"帐套定义","files":"modules/gld/FND2010/gld_set_of_books.screen","rn":"45"},{"id":"225","pid":"7","open":"false","name":"公司定义","files":"modules/fnd/FND2020/fnd_company.screen","rn":"46"},{"id":"239","pid":"8","open":"false","name":"参数定义","files":"modules/sys/SYS1110/sys_parameter.screen","rn":"47"},{"id":"255","pid":"8","open":"false","name":"Cache数据重载","files":"modules/sys/SYS1040/reload.screen","rn":"48"},{"id":"256","pid":"3","open":"false","name":"公司级客户主文件定义","files":"modules/fnd/FND2520/fnd_company_customers.screen","rn":"49"},{"id":"264","pid":"18","open":"false","name":"接收者类型维护","files":"modules/sys/SYS2010/sys_notify_recipient_type_new.screen","rn":"50"},{"id":"276","pid":"8","open":"false","name":"参数指定","files":"modules/sys/SYS1120/sys_parameter_values.screen","rn":"51"},{"id":"277","pid":"7","open":"false","name":"国家定义","files":"modules/fnd/FND1020/fnd_country_code.screen","rn":"52"},{"id":"278","pid":"7","open":"false","name":"地区定义","files":"modules/fnd/FND1030/fnd_region_code.screen","rn":"53"},{"id":"279","pid":"19","open":"false","name":"任务定义及授权","files":"modules/sys/SYS2030/sys_alert_rules.screen","rn":"54"},{"id":"281","pid":"19","open":"false","name":"JOB计划定义","files":"modules/sys/SYS2040/sys_alert_rule_job_codes.screen","rn":"55"},{"id":"287","pid":"8","open":"false","name":"系统配置向导维护","files":"modules/sys/SYS2860/sys_system_config_plan.screen","rn":"56"},{"id":"289","pid":"7","open":"false","name":"帐套级责任中心定义","files":"modules/fnd/FND2510/fnd_set_book_responsibility_centers.screen","rn":"57"},{"id":"295","pid":"8","open":"false","name":"系统配置向导","files":"modules/sys/SYS2870/sys_system_config_plan_list.screen","rn":"58"},{"id":"300","pid":"null","open":"false","name":"报表管理","files":"null","rn":"59"},{"id":"303","pid":"300","open":"false","name":"报表头参数定义","files":"modules/grm/GRM1010/grm_rept_tmpl_paras.screen","rn":"60"},{"id":"304","pid":"300","open":"false","name":"报表模板定义","files":"modules/grm/GRM1020/grm_rept_tmpl_new.screen","rn":"61"},{"id":"305","pid":"300","open":"false","name":"报表元数据定义","files":"modules/grm/GRM1030/grm_rept_meta_data.screen","rn":"62"},{"id":"306","pid":"300","open":"false","name":"上报指令模版定义","files":"modules/grm/GRM2010/gms_rept_order_define.screen","rn":"63"},{"id":"321","pid":"null","open":"false","name":"投资管理","files":"null","rn":"64"},{"id":"322","pid":"321","open":"false","name":"投资类别定义","files":"modules/im/IM1010/im_investment_types_define.screen","rn":"65"},{"id":"323","pid":"null","open":"false","name":"资产管理","files":"null","rn":"66"},{"id":"324","pid":"323","open":"false","name":"建筑物类别定义","files":"modules/fa/FA1020/fa_construction_category.screen","rn":"67"},{"id":"325","pid":"300","open":"false","name":"报表元数据字段定义","files":"modules/grm/GRM1040/grm_rept_meta_data_fields.screen","rn":"68"},{"id":"326","pid":"323","open":"false","name":"建筑物信息填报","files":"modules/fa/FA5020/fa_construction_data_submit.screen","rn":"69"},{"id":"329","pid":"7","open":"false","name":"组织结构定义","files":"modules/os/OS1010/fnd_organization_define.screen","rn":"70"},{"id":"342","pid":"673","open":"false","name":"公司物品编码模板定义","files":"modules/mda/MDA1010/mda_materials_tmpl_define.screen","rn":"71"},{"id":"343","pid":"323","open":"false","name":"建筑物信息查询","files":"modules/fa/FA7030/fa_construction_data_query.screen","rn":"72"},{"id":"344","pid":"323","open":"false","name":"建筑物信息汇总查询","files":"modules/fa/FA7040/fa_construction_data_total_query.screen","rn":"73"},{"id":"361","pid":"673","open":"false","name":"物品申请创建","files":"modules/mda/MDA5010/mda_item_requisition_type_choice.screen","rn":"74"},{"id":"362","pid":"323","open":"false","name":"效益及资产状况维护","files":"modules/fa/FA5030/fa_efficiency_asset_maintain.screen","rn":"75"},{"id":"363","pid":"673","open":"false","name":"外部系统定义","files":"modules/mda/MDA1020/mda_external_systems.screen","rn":"76"},{"id":"369","pid":"null","open":"false","name":"统购物品模块","files":"null","rn":"77"},{"id":"371","pid":"323","open":"false","name":"效益及资产状况查询","files":"modules/fa/FA7050/fa_efficiency_asset_query.screen","rn":"78"},{"id":"372","pid":"321","open":"false","name":"投资计划填报","files":"modules/im/IM5010/im_investment_plan_headers_query.screen","rn":"79"},{"id":"373","pid":"323","open":"false","name":"效益及资产状况汇总查询","files":"modules/fa/FA7060/fa_efficiency_asset_gather_query.screen","rn":"80"},{"id":"374","pid":"369","open":"false","name":"统购物品单据类型定义","files":"modules/qtm/QTM1020/qtm_document_types.screen","rn":"81"},{"id":"375","pid":"300","open":"false","name":"报表上报","files":"modules/grm/GRM5010/gms_rept_crud.screen","rn":"82"},{"id":"376","pid":"321","open":"false","name":"大规模项目前期方案填报","files":"modules/im/IM5050/im_investment_project_detail_write.screen","rn":"83"},{"id":"377","pid":"321","open":"false","name":"大规模项目概算填报","files":"modules/im/IM5060/im_appoximation_ls_main.screen","rn":"84"},{"id":"381","pid":"321","open":"false","name":"弹性域定义","files":"modules/im/IM1020/im_investment_flexfield_define.screen","rn":"85"},{"id":"382","pid":"323","open":"false","name":"能源与环保信息填报 ","files":"modules/fa/FA5040/fa_energy_envir_maintain.screen","rn":"86"},{"id":"383","pid":"321","open":"false","name":"投资计划查询","files":"modules/im/IM7010/im_investment_plan_query.screen","rn":"87"},{"id":"384","pid":"321","open":"false","name":"大规模项目前期方案查询","files":"modules/im/IM7050/im_fore_proposal_headers_query.screen","rn":"88"},{"id":"385","pid":"323","open":"false","name":"能源与环保信息查询","files":"modules/fa/FA7070/fa_energy_envir_query.screen","rn":"89"},{"id":"386","pid":"321","open":"false","name":"投资计划汇总查询","files":"modules/im/IM7020/im_investment_collect_query.screen","rn":"90"},{"id":"387","pid":"323","open":"false","name":"能源与环保信息汇总查询","files":"modules/fa/FA7080/fa_energy_envir_gather_query.screen","rn":"91"},{"id":"388","pid":"321","open":"false","name":"大规模项目立项","files":"modules/im/IM5020/im_project_establishment_query.screen","rn":"92"},{"id":"393","pid":"null","open":"true","name":"工作流设置","files":"null","rn":"93"},{"id":"394","pid":"393","open":"false","name":"工作流类型定义","files":"modules/zjwfl/zj_wfl_workflow_type.screen","rn":"94"},{"id":"395","pid":"393","open":"false","name":"工作流过程定义","files":"modules/zjwfl/zj_wfl_workflow_procedure.screen","rn":"95"},{"id":"396","pid":"393","open":"false","name":"工作流页面定义","files":"modules/zjwfl/zj_wfl_workflow_service.screen","rn":"96"},{"id":"397","pid":"393","open":"false","name":"邮件模板定义","files":"modules/zjsys/zj_sys_notify_template.screen","rn":"97"},{"id":"398","pid":"393","open":"false","name":"工作流定义","files":"modules/zjwfl/zj_wfl_workflow.screen","rn":"98"},{"id":"399","pid":"393","open":"false","name":"工作流分配","files":"modules/zjwfl/zj_wfl_workflow_assign.screen","rn":"99"},{"id":"400","pid":"393","open":"false","name":"工作流审批人定义","files":"modules/zjwfl/zj_wfl_workflow_assign_approve.screen","rn":"100"},{"id":"401","pid":"393","open":"false","name":"公司级工作流审批人定义","files":"modules/zjwfl/zj_wfl_workflow_com_assign_approve.screen","rn":"101"},{"id":"402","pid":"393","open":"false","name":"工作流业务规则参数定义","files":"modules/zjwfl/WFL2020/zj_wfl_business_rule_parameter_define.screen","rn":"102"},{"id":"403","pid":"393","open":"false","name":"工作流业务规则定义","files":"modules/zjwfl/WFL2030/zj_wfl_business_rules_define.screen","rn":"103"},{"id":"404","pid":"393","open":"false","name":"工作流业务规则分配","files":"modules/zjwfl/WFL2040/zj_wfl_node_recipient_set_rules_workflow_list.screen","rn":"104"},{"id":"405","pid":"393","open":"false","name":"公司级工作流业务规则分配","files":"modules/zjwfl/WFL2040/zj_wfl_com_node_recipient_set_rules_workflow_list.screen","rn":"105"},{"id":"406","pid":"435","open":"false","name":"工作流待办事项","files":"modules/zjwfl/zj_wfl_instance_node_recipient.screen","rn":"106"},{"id":"407","pid":"393","open":"false","name":"业务工作流指定","files":"modules/zjwfl/EXP1960/zj_exp_wfl_workflow_transaction.screen","rn":"107"},{"id":"408","pid":"393","open":"false","name":"工作流监控","files":"modules/zjwfl/zj_wfl_monitoring_query.screen","rn":"108"},{"id":"409","pid":"435","open":"false","name":"我参与的工作流","files":"modules/zjwfl/zj_wfl_mypartake_query.screen","rn":"109"},{"id":"410","pid":"435","open":"false","name":"工作流转交设置","files":"modules/zjwfl/WFL2110/zj_wfl_workflow_deliver_create.screen","rn":"110"},{"id":"411","pid":"435","open":"false","name":"单据工作流查询","files":"modules/zjwfl/WFL4000/zj_wfl_mypartake_query_ds.screen","rn":"111"},{"id":"412","pid":"435","open":"false","name":"工作流进度查询","files":"modules/zjwfl/zj_wfl_progress_query.screen","rn":"112"},{"id":"414","pid":"435","open":"false","name":"公司级单据工作流查询","files":"modules/zjwfl/WFL4000/zj_wfl_mypartake_query_com_ds.screen","rn":"113"},{"id":"415","pid":"393","open":"false","name":"工作流监控（所有公司）","files":"modules/zjwfl/zj_wfl_monitoring_company_query.screen","rn":"114"},{"id":"418","pid":"323","open":"false","name":"土地信息填报","files":"modules/fa/FA5010/fa_land_data_save.screen","rn":"115"},{"id":"421","pid":"321","open":"false","name":"大规模项目概算查询","files":"modules/im/IM7060/im_appoximation_header_query.screen","rn":"116"},{"id":"422","pid":"321","open":"false","name":"大规模项目立项查询","files":"modules/im/IM7070/im_establishment_query.screen","rn":"117"},{"id":"423","pid":"323","open":"false","name":"土地信息查询","files":"modules/fa/FA7010/fa_land_data_query.screen","rn":"118"},{"id":"424","pid":"369","open":"false","name":"统购物品管理员角色定义","files":"modules/qtm/QTM1010/qtm_admin_roles.screen","rn":"119"},{"id":"425","pid":"321","open":"false","name":"技改项目调整","files":"modules/im/IM5030/im_project_ajustment_main.screen","rn":"120"},{"id":"426","pid":"300","open":"false","name":"已审批报表查询","files":"modules/grm/GRM5010/gms_rept_query.screen","rn":"121"},{"id":"427","pid":"673","open":"false","name":"集团物品实物分类定义","files":"modules/mda/MDA1030/mda_group_item_classes.screen","rn":"122"},{"id":"428","pid":"674","open":"false","name":"集团级供应商类型定义","files":"modules/mda/MDA1040/mda_group_vender_types.screen","rn":"123"},{"id":"429","pid":"321","open":"false","name":"投资项目查询","files":"modules/im/IM7030/im_investment_project_detail_query.screen","rn":"124"},{"id":"430","pid":"323","open":"false","name":"土地信息汇总查询","files":"modules/fa/FA7020/fa_land_data_total_query.screen","rn":"125"},{"id":"431","pid":"321","open":"false","name":"投资项目汇总查询","files":"modules/im/IM7040/im_investment_project_summary_query.screen","rn":"126"},{"id":"435","pid":"null","open":"false","name":"我的工作流","files":"null","rn":"127"},{"id":"436","pid":"null","open":"false","name":"项目管理","files":"null","rn":"128"},{"id":"437","pid":"436","open":"false","name":"备案项目启动","files":"modules/pm/PM5010/pm_project_initiaction_detail.screen","rn":"129"},{"id":"438","pid":"369","open":"false","name":"统购物品管理策略定义","files":"modules/qtm/QTM1030/qtm_management_policies.screen","rn":"130"},{"id":"439","pid":"436","open":"false","name":"技改项目执行情况跟踪填报","files":"modules/pm/PM5020/pm_investment_prj_tt_track_main.screen","rn":"131"},{"id":"440","pid":"null","open":"false","name":"资产分析报表","files":"null","rn":"132"},{"id":"441","pid":"440","open":"false","name":"土地资源利用综合分析查询","files":"modules/ra/RA7040/ra_land_resource_analyse_query.screen","rn":"133"},{"id":"442","pid":"440","open":"false","name":"土地建筑物信息汇总查询","files":"modules/ra/RA7010/ra_land_construction_total_query.screen","rn":"134"},{"id":"462","pid":"436","open":"false","name":"大规模项目后评价信息填报","files":"modules/pm/PM5050/pm_ls_evaluate_headers_query.screen","rn":"135"},{"id":"463","pid":"436","open":"false","name":"技改项目执行情况跟踪查询","files":"modules/pm/PM7010/pm_investment_prj_tt_track_query.screen","rn":"136"},{"id":"465","pid":"436","open":"false","name":"大规模项目月报维护","files":"modules/pm/PM5030/pm_ls_month_report_edit.screen","rn":"137"},{"id":"466","pid":"440","open":"false","name":"资产现状分析查询","files":"modules/ra/RA7050/ra_assets_status_analyze_query.screen","rn":"138"},{"id":"467","pid":"300","open":"false","name":"报表上报批量查询","files":"modules/grm/GRM5010/gms_rept_batch_query_para.screen","rn":"139"},{"id":"481","pid":"436","open":"false","name":"大规模项目合同信息维护","files":"modules/pm/PM5060/pm_contract_manage.screen","rn":"140"},{"id":"482","pid":"436","open":"false","name":"大规模项目后评价信息查询","files":"modules/pm/PM7050/pm_ls_evaluate_headers_rd_query.screen","rn":"141"},{"id":"483","pid":"436","open":"false","name":"大规模项目月报查询","files":"modules/pm/PM7030/pm_ls_month_report_query.screen","rn":"142"},{"id":"484","pid":"436","open":"false","name":"大规模项目合同信息查询","files":"modules/pm/PM7060/pm_contract_query.screen","rn":"143"},{"id":"485","pid":"436","open":"false","name":"大规模项目合同决算维护","files":"modules/pm/PM5070/pm_contract_final_cost.screen","rn":"144"},{"id":"505","pid":"436","open":"false","name":"大规模项目合同决算查询","files":"modules/pm/PM7070/pm_contract_final_query.screen","rn":"145"},{"id":"525","pid":"321","open":"false","name":"技改项目明细查询","files":"modules/im/IM7080/im_project_ajustment_query.screen","rn":"146"},{"id":"545","pid":"674","open":"false","name":"供应商主数据维护申请创建","files":"modules/mda/MDA6020/mda_sys_vender_basics_edit.screen","rn":"147"},{"id":"546","pid":"674","open":"false","name":"供应商引入申请维护","files":"modules/mda/MDA6030/mda_vender_application_edit.screen","rn":"148"},{"id":"547","pid":"674","open":"false","name":"供应商引入申请查询","files":"modules/mda/MDA7010/mda_vender_application_query.screen","rn":"149"},{"id":"548","pid":"674","open":"false","name":"供应商引入申请创建","files":"modules/mda/MDA6010/mda_vender_application_create.screen","rn":"150"},{"id":"565","pid":"436","open":"false","name":"项目完工","files":"modules/pm/PM5080/pm_project_completion.screen","rn":"151"},{"id":"566","pid":"673","open":"false","name":"物品申请维护","files":"modules/mda/MDA5020/mda_item_application_edit.screen","rn":"152"},{"id":"585","pid":"300","open":"false","name":"公司级上报批量查询","files":"modules/grm/GRM5010/gms_rept_batch_query_para_com.screen","rn":"153"},{"id":"605","pid":"300","open":"false","name":"管理员报表查询","files":"modules/grm/GRM5010/gms_rept_all_info.screen","rn":"154"},{"id":"625","pid":"321","open":"false","name":"投资计划产业层汇总","files":"modules/im/IM7020/zj_im_investment_collect_approve.screen","rn":"155"},{"id":"626","pid":"369","open":"false","name":"额度申请查询","files":"modules/qtm/QTM7010/qtm_quota_application_query.screen","rn":"156"},{"id":"627","pid":"369","open":"false","name":"额度修正控制","files":"modules/qtm/QTM5050/qtm_quota_application_revise.screen","rn":"157"},{"id":"628","pid":"369","open":"false","name":"额度申请维护","files":"modules/qtm/QTM5030/qtm_quota_application.screen","rn":"158"},{"id":"629","pid":"369","open":"false","name":"额度需求申请创建","files":"modules/qtm/QTM5020/qtm_quota_require_app_create.screen","rn":"159"},{"id":"630","pid":"369","open":"false","name":"额度分配申请创建","files":"modules/qtm/QTM5010/qtm_quota_application_create.screen","rn":"160"},{"id":"631","pid":"673","open":"false","name":"物品申请查询","files":"modules/mda/MDA5030/mda_item_application_query.screen","rn":"161"},{"id":"632","pid":"674","open":"false","name":"供应商申请管理员查询","files":"modules/mda/MDA8020/mda_vender_application_query.screen","rn":"162"},{"id":"645","pid":"673","open":"false","name":"集团物品编码模板定义","files":"modules/mda/MDA1008/mda_materials_tmpl_define.screen","rn":"163"},{"id":"646","pid":"673","open":"false","name":"产业物品编码模板定义","files":"modules/mda/MDA1009/mda_materials_tmpl_define.screen","rn":"164"},{"id":"665","pid":"673","open":"false","name":"物品模板通用属性定义","files":"modules/mda/MDA1011/mda_item_tmpl_general_fields.screen","rn":"165"},{"id":"666","pid":"673","open":"false","name":"能化产成品管理属性维护","files":"modules/mda/MDA5040/mda_item_basic_maintain.screen","rn":"166"},{"id":"667","pid":"673","open":"false","name":"物品主数据综合查询","files":"modules/mda/MDA7030/mda_item_basic_maintain.screen","rn":"167"},{"id":"668","pid":"673","open":"false","name":"能化产成品管理属性查询","files":"modules/mda/MDA7040/mda_item_basic_maintain.screen","rn":"168"},{"id":"669","pid":"673","open":"false","name":"能化产成品管理属性审批","files":"modules/mda/MDA7050/mda_item_basic_maintain.screen","rn":"169"},{"id":"670","pid":"673","open":"false","name":"物品属性明细维护申请","files":"modules/mda/MDA7060/mda_item_detail_mt_tmpl_choice.screen","rn":"170"},{"id":"671","pid":"673","open":"false","name":"物品属性明细申请维护","files":"modules/mda/MDA7070/mda_item_detail_mt_app_query.screen","rn":"171"},{"id":"672","pid":"673","open":"false","name":"物品属性明细申请查询","files":"modules/mda/MDA7080/mda_item_detail_mt_app_readonly_query.screen","rn":"172"},{"id":"673","pid":"null","open":"false","name":"物品主数据管理","files":"null","rn":"173"},{"id":"674","pid":"null","open":"false","name":"供应商主数据管理","files":"null","rn":"174"} ];
	$(document).ready(function() {
		main_init();//导航
		modifyInit.init();//修改密码
	});
	//alert('${json}');
	function querys() {
		var fun_code = $('#query_text_id').searchbox('getValue');
		fun_code=fun_code.toUpperCase();
		var node_tree;
		var err_pag = false;
		for ( var i = 0; i < g_nodes.length; i++) {
			var node = g_nodes[i];
			if (node.function_code == fun_code) {
				if (!node.files) {
					err_pag = true;
					$.messager.alert("提示", "功能目录不允许直接索引!", "error");
					break;
				} else {
					node_tree = node;
					break;
				}
			}
		}
		//debugger;
		if (node_tree)
			content_view(node_tree);
		if (!err_pag && !node_tree)
			$.messager.alert("提示", "权限不足,或此功能不存在!", "error");
	}
</script>
</head>
<body class="easyui-layout">
	<div class="ui-header"
		data-options="region:'north',split:true,border:false"
		style="height: 40px; overflow: hidden;">
		<h1>Test demo</h1>
	   <div  class="ui-login">
		 		欢迎 <span class="orange" id="nickName_id">nickName</span> 第[<span class="orange" id="loginCount_id">loginCount</span>]次登录系统 
		 		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		 		<a class="modify-pwd-btn"  href="javascript:void(0);">修改密码</a> |
	 			<a class="logout-btn" href="${msUrl}/logout.do">退出</a>
	 	</div>
		<input class="hidden" name="role_id" id="role_id_id"> <input
			class="hidden" name="company_id" id="company_id_id"> <a
			class="ui-query"><input id="role_name_id" class="easyui-combobox"
			style="width: 155px;" name="role_company_name"
			data-options="
							url:'ToDoGo.do?actionId=query/combox@user_role&dataSorce=xml/sys_menu_main.xml',    
						    method:'post',
						    required:true,
						    panelWidth: 350,
						    valueField:'user_role_group_id',    
						    textField:'role_company_name' 
						"></a>
		<a class="ui-query"><input id="query_text_id"
			class="easyui-searchbox" name="query_text"
			data-options="width:90,searcher:querys,prompt:'功能号索引'" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a>
	</div>
	<!-- 树形菜单 -->
	<div id="treeCloseOpenId"
		data-options="region:'west',split:true,title:'导航区'"
		style="width: 200px;">
		<ul id="tree" class="ztree" style="width: 260px; overflow: auto;"></ul>
	</div>
	<!-- 中间内容页面 -->
	<div data-options="region:'center'">
		<div class="easyui-tabs" id="tab-box"
			data-options="fit:true,border:false">
			<div title="Welcome" style="padding: 20px; overflow: hidden;">
				<div style="margin-top: 20px;">
					<h3>简要说明</h3>
					<ul>
						<li>使用Java平台,采用SpringMVC等主流框架</li>
						<li>数据库:使用mysql数据库</li>
						<li>前端:使用Jquery、Easyui 、zTtree 等流行的js框架技术.</li>
						<li>权限:对所有链接地址，请求地址进行控制</li>
						<li>拦截:对所有无权限URL进行拦截,确保系统全性更好.</li>
						<li>数据传送:前台与后台通过json 数据格式进行传送</li>
						<li>目前支持火狐、谷歌、,IE8~IE11 等主流浏览器</li>
					</ul>
				</div>
			</div>
			<!-- <iframe id="testIframe" Name="testIframe" FRAMEBORDER=0 SCROLLING=AUTO width=100%  height=600px  src="#">
	     </iframe> -->
		</div>
	</div>
	<div data-options="region:'south',split:true,border:false"
		style="height: 30px; overflow: hidden;">
		<div class="panel-header" style="border: none; text-align: center;">CopyRight
			&copy; 2013 jqspring 版权所有. &nbsp;&nbsp;</div>
	</div>
	<!--  modify password start -->
	<div id="modify-pwd-win" class="easyui-dialog" buttons="#editPwdbtn"
		title="修改用户密码"
		data-options="closed:true,iconCls:'icon-save',modal:true"
		style="width: 350px; height: 200px;">
		<form id="pwdForm"
			action="ToDoGo.do?actionId=update@password&dataSorce=xml/sys_menu_main.xml"
			class="ui-form" method="post">
			<input class="hidden" name="user_id" id="user_id">
			<div class="ui-edit">
				<div class="fitem">
					<label>旧密码:</label> <input id="oldPwd" name="oldPwd"
						type="password" class="easyui-validatebox"
						data-options="required:true" />
				</div>
				<div class="fitem">
					<label>新密码:</label> <input id="newPwd" name="newPwd"
						type="password" class="easyui-validatebox"
						data-options="required:true" />
				</div>
				<div class="fitem">
					<label>重复密码:</label> <input id="rpwd" name="rpwd" type="password"
						class="easyui-validatebox" required="required"
						validType="equals['#newPwd']" />
				</div>
			</div>
		</form>
		<div id="editPwdbtn" class="dialog-button">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				id="btn-pwd-submit">提交</a> <a href="javascript:void(0)"
				class="easyui-linkbutton" id="btn-pwd-close">关闭</a>
		</div>
	</div>
	<script type="text/javascript">
		//角色切换
		/*$('#role_name_id').combobox({    
		    url:'ToDoGo.do?actionId=query/combox@user_role&dataSorce=xml/sys_menu_main.xml',    
		    method:'post',
		    valueField:'role_id',    
		    textField:'role_company_name'   
		});  */
		$('#role_name_id').combobox(
						{
							onSelect : function(res) {
								$('#role_name_id').combobox('hidePanel');
								$.ajax({
											type : "POST",
											async : false, //同步请求
											url : "ToDoGo.do?actionId=update@sys_role_select&dataSorce=xml/sys_user_sql.xml",
											data : {
												role_id : res.role_id,
												company_id : res.company_id
											},// _para 代表数组json数据传入，为内定参数
											dataType : 'json',
											success : function(data) {
												if (data.success) {
													window.location.href = "initPage.shtml?uri=main/main";
												}
											},
											error : function(err) {
												$.messager.alert("提示",
														err.responseText,
														"error");
											}
										});
							}
						});
	</script>
	<!-- modify password end  -->
</body>
</html>
