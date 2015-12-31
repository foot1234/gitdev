-- Create table
create global temporary table FUN_OUT_PARAMETER_TMP
(
  HTTP_SESSION_ID     VARCHAR2(100) not null,
  SQL_XML_PATH_ACTION VARCHAR2(1000) not null,
  PARAMETER_CODE      VARCHAR2(1000),
  PARAMETER_VALUE     VARCHAR2(4000),
  INDEX_S             NUMBER
)
on commit preserve rows;
-- Add comments to the columns 
comment on column FUN_OUT_PARAMETER_TMP.HTTP_SESSION_ID
  is 'HTTP session id';
comment on column FUN_OUT_PARAMETER_TMP.SQL_XML_PATH_ACTION
  is 'xml path';
comment on column FUN_OUT_PARAMETER_TMP.PARAMETER_CODE
  is '需要输出的参数code';
comment on column FUN_OUT_PARAMETER_TMP.PARAMETER_VALUE
  is '需要输出的参数值';
comment on column FUN_OUT_PARAMETER_TMP.INDEX_S
  is 'grid行索引';
-- Create/Recreate indexes 
create index FUN_OUT_PARAMETER_TMP_N1 on FUN_OUT_PARAMETER_TMP (HTTP_SESSION_ID, SQL_XML_PATH_ACTION);