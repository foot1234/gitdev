#syscode 导入
  CALL init_sys_code('COMPANY_TYPE','公司类型','Y','Y',1);
  CALL init_sys_code_value('COMPANY_TYPE','1','业务实体','Y',1);
  CALL init_sys_code_value('COMPANY_TYPE','2','汇总公司','Y',1);
  CALL init_sys_code_value('COMPANY_TYPE','3','合并公司','Y',1);
  CALL init_sys_code_value('COMPANY_TYPE','4','调整公司','Y',1);