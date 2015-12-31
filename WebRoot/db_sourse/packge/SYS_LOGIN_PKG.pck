CREATE OR REPLACE PACKAGE "SYS_LOGIN_PKG" is

  -- Author  : xiaoguojun
  -- Created : 2009-3-30 09:33:59
  -- Purpose : 系统登录

  --增加SSO登陆处理程序 Alan Lee 2010-06-17

  --***********************************************************/*
  --  异常
  --        e_password_null      密码为空
  --        e_password_failure   密码错误
  --        e_user_faulure       用户失效
  --        e_user_null          用户不存在
  --        e_frozen_failure     用户已被冻结
  --        e_password_expired   密码到期需要设定新密码
  --        e_first_login_change_password 首次登陆必须修改密码
  --***********************************************************/*
  e_user_failure exception;
  e_user_null exception;
  e_password_null exception;
  e_password_failure exception;
  e_frozen_failure exception;
  e_password_expired exception;
  e_password_rule_check_invalid exception;
  e_language_null exception;
  e_role_null exception;
  e_first_login_change_password exception;
  /********************** 用户登录
         支持多语言登录界面
         通过登录页面参数，通过XML资源配置，实现多语言登录界面。
         处理用户登录的合法性校验
         用户名的合法性
         用户名的时间有效
         用户名冻结状态
         密码的合法性
         登录次数的限制
         登录时间的限制
         密码修改的要求校验
         处理登录日志
         记录登录用户的相关日志信息
         登录会话
         记录登录机器码、用户、角色、组织、登录时间、登出时间、会话语言
         记录登录服务器IP，客户端IP
         登录操作明细
         记录登录操作功能、处理类型、开始处理时间、结束处理时间
         处理全局参数
         根据规则获取系统SESSION等
  
         返回值为加密的SESSION_ID
  ******************************/
  function md5(p_password in varchar2) return varchar2;

  procedure login(p_user_name           in varchar2,
                  p_password            in varchar2,
                  p_language            in varchar2,
                  p_ip                  in varchar2,
                  p_session_id          out number,
                  p_encryted_session_id out varchar2,
                  p_error_message       out varchar2);

  --************************************************************
  -- SSO用户登录
  -- parameter :
  --             p_encrypted_sso_session_id SSO登录加密的SESSION_ID
  --             p_error_message 登录出错时，界面返回的消息内容
  -- exception :
  --             e_password_null     密码为空
  --             e_password_failure  密码错误
  --             e_user_null         用户不存在
  --             e_user_faulure      用户失效
  --             e_language_null     语言不存在
  --             e_role_null exception 未分配角色
  --************************************************************
  procedure sso_login(p_encrypted_sso_session_id in varchar2,
                      p_session_id               out number,
                      p_encrypted_session_id     out varchar2,
                      p_error_message            out varchar2);

  procedure zj_ad_login(p_user_name           in varchar2,
                        p_password            in varchar2,
                        p_language            in varchar2,
                        p_ip                  in varchar2,
                        p_session_id          out number,
                        p_encryted_session_id out varchar2,
                        p_error_message       out varchar2);

  /********************* 角色选择
          选择作业角色
          根据用户的有效角色、组织授权信息，提供作业角色、组织列表选择界面
          只能选择一个角色、组织组合进行作业
          必须选择一个角色、组织组合才能进行作业
          处理全局参数
          处理角色、组织为全局参数
  ********************************/
  procedure role_select(p_encryted_session_id varchar2,
                        p_role_id             number,
                        p_company_id          number,
                        p_app_ip_address      varchar2,
                        p_client_ip_address   varchar2,
                        p_description         varchar2 default null);

  --************************************************************
  -- AD用户登录
  -- parameter :
  --            p_user_name            in varchar2, 用户名
  --            p_role_code            in varchar2, 角色code
  --            p_ip                   in varchar2,客户端IP
  --            p_session_id           out number,返回session_id
  --            p_user_id              out number,返回user_id
  --            p_role_id              out number,返回role_id
  --            p_company_id           out number,  返回company_id
  --            p_encrypted_session_id out varchar2,返回加密session_id
  --************************************************************
  procedure ad_login(p_user_name                in varchar2,
                     p_ip                       in varchar2,
                     p_session_id               out number,
                     p_user_id                  out number,
                     p_role_id                  out number,
                     p_company_id               out number,
                     p_lang                     out varchar2,
                     p_old_encrypted_session_id in varchar2,
                     p_encrypted_session_id     out varchar2);

  /********************* 主界面
          提供作业操作的主界面
          多语支持作业言界面
          根据用户及用户登录选择的角色组织信息，提供两级菜单，功能组和功能
          点击功能组菜单可以收起和展开功能菜单明细
          点击功能菜单，可以打开对应的应用程序
          应用程序在业务操作部分打开
  *********************************/

  /*******************  功能菜单
          提供作业操作的主界面
          多语支持作业言界面
          根据用户及用户登录选择的角色组织信息，提供两级菜单，功能组和功能
          点击功能组菜单可以收起和展开功能菜单明细
          点击功能菜单，可以打开对应的应用程序
          应用程序在业务操作部分打开
  *********************************/

  procedure logout(p_session_id number);

end sys_login_pkg;
/
CREATE OR REPLACE PACKAGE BODY "SYS_LOGIN_PKG" is

  --************************************************************
  --MD5密码转换
  -- parameter :
  -- p_password  原密码
  -- return    :
  -- md5后的密码
  --************************************************************

  function md5(p_password in varchar2) return varchar2 is
    retval varchar2(32);
  begin
    retval := utl_raw.cast_to_raw(dbms_obfuscation_toolkit.md5(input_string => p_password));
    return retval;
  end md5;
  --************************************************************
  -- 校验用户有效性
  -- parameter :
  -- p_user_name 登录用户名
  -- exception :
  -- e_user_null     用户失效
  --************************************************************
  procedure validate_user(p_sys_user sys_user%rowtype) is
  begin
    if trunc(p_sys_user.start_date) > trunc(sysdate) then
      raise e_user_failure;
    end if;
    if p_sys_user.end_date is not null and
       trunc(p_sys_user.end_date) < trunc(sysdate) then
      raise e_user_failure;
    end if;
  end validate_user;

  --校验配角色有效性
  procedure validate_role(p_sys_user sys_user%rowtype) is
    v_exists  number;
    v_sysdate date := trunc(sysdate);
    v_count   number;
  begin
  
    --判断是否已经存在公司
    select count(1) into v_count from fnd_companies a;
  
    if v_count > 0 then
      --如果已经存在公司，则一定要分配公司
      select 1
        into v_exists
        from dual
       where exists
       (select *
                from sys_user_role_groups g
               where g.user_id = p_sys_user.user_id
                 and g.start_date <= v_sysdate
                 and (g.end_date >= v_sysdate or g.end_date is null));
    end if;
  
  exception
    when no_data_found then
      raise e_role_null;
  end validate_role;

  --************************************************************
  -- 校验用户是否被冻结
  --************************************************************

  procedure validate_frozen_flag(p_sys_user sys_user%rowtype) is
  begin
    if p_sys_user.frozen_flag = 'Y' then
      raise e_frozen_failure;
    end if;
  end validate_frozen_flag;

  --************************************************************
  -- 校验密码有效性
  -- parameter :
  --             p_user_name 登录用户名
  --             p_password  输入的密码
  -- exception :
  --             e_password_null     密码为空
  --             e_password_failure  密码错误
  --************************************************************
  procedure validate_password(p_sys_user sys_user%rowtype,
                              p_password varchar2) is
  begin
    if p_password is null then
      raise e_password_null;
    end if;
  
    if p_sys_user.encrypted_user_password <> md5(p_password) then
      raise e_password_failure;
    end if;
  
    --密码规则校验
    sys_user_pkg.password_rule_check(p_password);
  
  exception
    when sys_user_pkg.e_password_complex_control then
      raise e_password_rule_check_invalid;
    when sys_user_pkg.e_password_min_length then
      raise e_password_rule_check_invalid;
    
  end validate_password;

  --************************************************************
  -- 校验密码是否到期
  -- parameter :
  --             p_user_name 登录用户名
  -- exception :
  --             e_password_expired     密码到期
  --************************************************************
  procedure expired_password(p_sys_user sys_user%rowtype) is
    v_login_time                number;
    v_pwd_changed_date          date;
    v_validate_date             number;
    v_user_password_useful_life number;
  begin
  
    --判断密码的有效期，如果不在有效期内，则弹出密码修改界面，强制修改密码！
    v_user_password_useful_life := nvl(sys_parameter_pkg.value('USER_PASSWORD_USEFUL_LIFE'),
                                       0);
    if v_user_password_useful_life > 0 then
      --如果设置了密码有效期天数，则判断密码的有效期
      select (to_date(to_char(p_sys_user.password_start_date, 'YYYYMMDD'),
                      'YYYYMMDD') + v_user_password_useful_life) -
             to_date(to_char(sysdate, 'YYYYMMDD'), 'YYYYMMDD')
        into v_validate_date
        from dual;
      if v_validate_date <= 0 then
        raise e_password_expired;
      end if;
    end if;
  
    if p_sys_user.password_lifespan_days is not null or
       p_sys_user.password_lifespan_access is not null then
      begin
        select max(trunc(supcl.creation_date))
          into v_pwd_changed_date
          from sys_user_pwd_changed_logs supcl
         where supcl.changed_user_id = p_sys_user.user_id;
      exception
        when others then
          v_pwd_changed_date := null;
      end;
      if v_pwd_changed_date is null then
        v_pwd_changed_date := trunc(p_sys_user.creation_date);
      end if;
    end if;
    --密码天数限制
    if p_sys_user.password_lifespan_days is not null then
      if p_sys_user.password_lifespan_days <
         (trunc(sysdate) - v_pwd_changed_date) then
        raise e_password_expired;
      end if;
    end if;
    --密码次数限制
    if p_sys_user.password_lifespan_access is not null then
      select count(sul.login_time)
        into v_login_time
        from sys_user_logins sul
       where sul.user_id = p_sys_user.user_id
         and trunc(sul.login_time) > v_pwd_changed_date;
      if p_sys_user.password_lifespan_access <= v_login_time then
        raise e_password_expired;
      end if;
    end if;
  
  end expired_password;

  --************************************************************
  -- 校验首次登陆必须修改密码
  -- parameter :
  --             p_user_name 登录用户名
  -- exception :
  --             e_first_login_change_password     首次登陆必须修改密码
  --************************************************************
  procedure first_login_change_password(p_sys_user sys_user%rowtype) is
    v_pwd_changed_times           number;
    v_first_login_change_password varchar2(1);
  begin
  
    --判断是否首次登陆必须修改密码，如果没有修改过密码，则弹出密码修改界面，强制修改密码！
    v_first_login_change_password := nvl(sys_parameter_pkg.value('FIRST_LOGIN_CHANGE_PASSWORD'),
                                         'N');
    if v_first_login_change_password = 'Y' then
      --如果设置首次登陆必须修改密码，则判断密码的有效期
      select count(1)
        into v_pwd_changed_times
        from sys_user_pwd_changed_logs supcl
       where supcl.changed_user_id = p_sys_user.user_id;
      if v_pwd_changed_times < 1 then
        raise e_first_login_change_password;
      end if;
    end if;
  
  end first_login_change_password;

  function get_user_login_id return number is
    result number;
  begin
    select sys_user_logins_s.nextval into result from dual;
    return result;
  end get_user_login_id;

  --************************************************************
  -- 创建登录日志
  --************************************************************
  procedure create_login(p_sys_user_id         number,
                         p_role_id             number,
                         p_company_id          number,
                         p_session_id          number,
                         p_encryted_session_id varchar2,
                         p_client_ip_address   varchar2,
                         p_app_ip_address      varchar2,
                         p_description         varchar2) is
    v_user_login_id number;
  begin
  
    v_user_login_id := get_user_login_id;
  
    insert into sys_user_logins
      (login_id,
       user_id,
       role_id,
       company_id,
       session_id,
       encrypted_session_id,
       nls_language,
       machine_serial,
       client_ip_address,
       app_ip_address,
       login_time,
       logout_time,
       last_active_time,
       description,
       last_update_date,
       last_updated_by,
       creation_date,
       created_by)
    values
      (v_user_login_id,
       p_sys_user_id,
       p_role_id,
       p_company_id,
       p_session_id,
       p_encryted_session_id,
       userenv('lang'),
       'UNDIFINE',
       p_client_ip_address,
       p_app_ip_address,
       sysdate,
       null,
       sysdate,
       p_description,
       sysdate,
       p_sys_user_id,
       sysdate,
       p_sys_user_id);
  
  end create_login;

  --************************************************************
  -- 创建登出日志
  --************************************************************
  procedure logout(p_session_id number) is
  begin
  
    update sys_user_logins
       set logout_time = sysdate
     where session_id = p_session_id;
  
    delete from sys_session where session_id = p_session_id;
  
  end logout;

  --************************************************************
  -- 创建操作明细日志
  --************************************************************
  procedure create_login_details(p_sys_user_id   number,
                                 p_user_login_id number,
                                 p_function_id   number,
                                 p_action_code   varchar2,
                                 p_description   varchar2) is
    v_detail_line_id number;
  begin
    select sys_user_login_details_s.nextval
      into v_detail_line_id
      from dual;
    insert into sys_user_login_details
      (detail_line_id,
       login_id,
       function_id,
       action_code,
       in_time,
       out_time,
       description,
       last_update_date,
       last_updated_by,
       creation_date,
       created_by)
    values
      (v_detail_line_id,
       p_user_login_id,
       p_function_id,
       p_action_code,
       sysdate,
       null,
       p_description,
       sysdate,
       p_sys_user_id,
       sysdate,
       p_sys_user_id);
  
  end create_login_details;

  --************************************************************
  -- 创建操作明细登出日志
  --************************************************************
  procedure create_logout_details(p_detail_line_id number) is
  begin
  
    update sys_user_login_details
       set out_time = sysdate
     where detail_line_id = p_detail_line_id;
  
  end create_logout_details;

  --************************************************************
  -- 登录成功后，更新登录信息
  -- parameter :
  --             p_user_name 登录用户名
  --************************************************************
  function post_login(p_user_name varchar2,
                      p_password  varchar2,
                      p_ip        varchar2) return varchar2 is
    v_encryted_session_id varchar2(100);
    v_last_logincount     number;
  begin
    select nvl(max(s.logincount), 0) + 1
      into v_last_logincount
      from sys_user s
     where s.user_name = p_user_name;
    --更新最后日期
    update sys_user
       set last_logon_date  = sysdate,
           last_update_date = sysdate,
           logincount       = v_last_logincount
     where user_name = p_user_name;
  
    --插入session表
    v_encryted_session_id := sys_session_pkg.create_session(p_user_name => p_user_name,
                                                            p_password  => p_password,
                                                            p_ip        => p_ip);
    return v_encryted_session_id;
  end post_login;

  --************************************************************
  -- SSO登录成功后，更新登录信息
  -- parameter :
  --             p_user_name 登录用户名
  --************************************************************
  function post_sso_login(p_user_name          varchar2,
                          p_encrypted_password varchar2,
                          p_ip                 varchar2) return varchar2 is
    v_encryted_session_id varchar2(100);
  begin
    --更新最后日期
    update sys_user
       set last_logon_date = sysdate, last_update_date = sysdate
     where user_name = p_user_name;
  
    --插入session表
    v_encryted_session_id := sys_session_pkg.create_session(p_user_name => p_user_name,
                                                            p_password  => p_encrypted_password,
                                                            p_ip        => p_ip);
    return v_encryted_session_id;
  end post_sso_login;

  --************************************************************
  -- 用户登录
  -- parameter :
  --             p_user_name 登录用户名
  --             p_password  输入的密码
  --             p_language  语言（'ZHS','US')
  --             p_error_message 登录出错时，界面返回的消息内容
  -- exception :
  --             e_password_null     密码为空
  --             e_password_failure  密码错误
  --             e_user_null         用户不存在
  --             e_user_faulure      用户失效
  --             e_language_null     语言不存在
  --             e_role_null exception 未分配角色
  --************************************************************
  procedure login(p_user_name           in varchar2,
                  p_password            in varchar2,
                  p_language            in varchar2,
                  p_ip                  in varchar2,
                  p_session_id          out number,
                  p_encryted_session_id out varchar2,
                  p_error_message       out varchar2) is
    r_sys_user            sys_user%rowtype;
    v_encryted_session_id varchar2(100);
    v_language            varchar2(100);
    v_sql                 varchar2(20000);
  begin
  
    begin
      select *
        into r_sys_user
        from sys_user
       where user_name = upper(p_user_name);
    exception
      when no_data_found then
        raise e_user_null;
    end;
    begin
      select t.nls_language
        into v_language
        from sys_languages t, fnd_language_code f
       where t.language_code = f.language_code
         and t.language_code = p_language
         and f.installed_flag = 'Y';
    exception
      when no_data_found then
        raise e_language_null;
    end;
  
    v_sql := 'alter session set nls_language =' || chr(39) || v_language ||
             chr(39);
    execute immediate v_sql;
  
    --校验用户有效性
    validate_user(p_sys_user => r_sys_user);
  
    --校验配角色有效性
    validate_role(p_sys_user => r_sys_user);
  
    --校验用户是否被冻结
    validate_frozen_flag(p_sys_user => r_sys_user);
  
    --校验密码有效性
    validate_password(p_sys_user => r_sys_user, p_password => p_password);
  
    --校验密码是否到期
    expired_password(p_sys_user => r_sys_user);
  
    --校验首次登陆必须修改密码
    first_login_change_password(p_sys_user => r_sys_user);
  
    v_encryted_session_id := post_login(p_user_name => upper(p_user_name),
                                        p_password  => p_password,
                                        p_ip        => p_ip);
  
    p_encryted_session_id := v_encryted_session_id;
    if p_encryted_session_id is not null then
      p_session_id := sys_session_pkg.get_session_id(p_encryted_session_id);
    end if;
    p_error_message := ' ';
    --return v_encryted_session_id;
  exception
    when e_role_null then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_USER_ROLE_NULL', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    when e_language_null then
      --自定义异常
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_LANGUAGE_NULL', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    when e_password_failure then
      --自定义异常
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_PASSWORD_FAILURE', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    when e_password_null then
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_PASSWORD_NULL', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    when e_user_failure then
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_USER_FAILURE', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    when e_user_null then
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_USER_NULL', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    when e_frozen_failure then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_FROZEN_FAILURE', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    when e_password_expired then
      p_session_id          := -1; --你的密码已经过期，请修改密码
      p_encryted_session_id := 'ERROR';
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_USER_PASSWORD_EXPIRED',
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
    
      sys_raise_app_error_pkg.get_sys_raise_app_error(p_app_error_line_id => sys_raise_app_error_pkg.g_err_line_id,
                                                      p_message           => p_error_message);
    
    when e_first_login_change_password then
      p_session_id          := -1; --首次登陆必须修改密码，请修改密码
      p_encryted_session_id := 'ERROR';
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_FIRST_LOGIN_CHANGE_PASSWORD',
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
    
      sys_raise_app_error_pkg.get_sys_raise_app_error(p_app_error_line_id => sys_raise_app_error_pkg.g_err_line_id,
                                                      p_message           => p_error_message);
    
    when e_password_rule_check_invalid then
      p_session_id          := -1; --你的密码不符合系统设定的密码规则定义，请重新修改密码
      p_encryted_session_id := 'ERROR';
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_USER_PASSWORD_RULE_CHECK_INVALID',
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
    
      sys_raise_app_error_pkg.get_sys_raise_app_error(p_app_error_line_id => sys_raise_app_error_pkg.g_err_line_id,
                                                      p_message           => p_error_message);
    
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(sqlerrm,
                                                     p_created_by              => 0,
                                                     p_package_name            => 'SYS_login_PKG',
                                                     p_procedure_function_name => 'login');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  end login;

  --************************************************************
  -- 用户登录
  -- parameter :
  --             p_user_name 登录用户名
  --             p_password  输入的密码
  --             p_language  语言（'ZHS','US')
  --             p_error_message 登录出错时，界面返回的消息内容
  -- exception :
  --             e_password_null     密码为空
  --             e_password_failure  密码错误
  --             e_user_null         用户不存在
  --             e_user_faulure      用户失效
  --             e_language_null     语言不存在
  --             e_role_null exception 未分配角色
  --************************************************************
  procedure zj_ad_login(p_user_name           in varchar2,
                        p_password            in varchar2,
                        p_language            in varchar2,
                        p_ip                  in varchar2,
                        p_session_id          out number,
                        p_encryted_session_id out varchar2,
                        p_error_message       out varchar2) is
    r_sys_user            sys_user%rowtype;
    v_encryted_session_id varchar2(100);
    v_language            varchar2(100);
    v_sql                 varchar2(20000);
  begin
  
    begin
      select *
        into r_sys_user
        from sys_user
       where user_name = upper(p_user_name);
    exception
      when no_data_found then
        raise e_user_null;
    end;
    begin
      select t.nls_language
        into v_language
        from sys_languages t, fnd_language_code f
       where t.language_code = f.language_code
         and t.language_code = p_language
         and f.installed_flag = 'Y';
    exception
      when no_data_found then
        raise e_language_null;
    end;
  
    v_sql := 'alter session set nls_language =' || chr(39) || v_language ||
             chr(39);
    execute immediate v_sql;
  
    --校验用户有效性
    validate_user(p_sys_user => r_sys_user);
  
    --校验配角色有效性
    validate_role(p_sys_user => r_sys_user);
  
    --校验用户是否被冻结
    validate_frozen_flag(p_sys_user => r_sys_user);
  
    --校验密码有效性
    --validate_password(p_sys_user => r_sys_user, p_password => p_password);
  
    --校验密码是否到期
    --expired_password(p_sys_user => r_sys_user);
  
    --校验首次登陆必须修改密码
    --first_login_change_password(p_sys_user => r_sys_user);
  
    v_encryted_session_id := post_login(p_user_name => upper(p_user_name),
                                        p_password  => p_password,
                                        p_ip        => p_ip);
  
    p_encryted_session_id := v_encryted_session_id;
    if p_encryted_session_id is not null then
      p_session_id := sys_session_pkg.get_session_id(p_encryted_session_id);
    end if;
    p_error_message := ' ';
    --return v_encryted_session_id;
  exception
    when e_role_null then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_USER_ROLE_NULL', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    when e_language_null then
      --自定义异常
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_LANGUAGE_NULL', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    when e_password_failure then
      --自定义异常
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_PASSWORD_FAILURE', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    when e_password_null then
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_PASSWORD_NULL', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    when e_user_failure then
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_USER_FAILURE', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    when e_user_null then
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_USER_NULL', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    when e_frozen_failure then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_FROZEN_FAILURE', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    when e_password_expired then
      p_session_id          := -1; --你的密码已经过期，请修改密码
      p_encryted_session_id := 'ERROR';
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_USER_PASSWORD_EXPIRED',
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
    
      sys_raise_app_error_pkg.get_sys_raise_app_error(p_app_error_line_id => sys_raise_app_error_pkg.g_err_line_id,
                                                      p_message           => p_error_message);
    
    when e_first_login_change_password then
      p_session_id          := -1; --首次登陆必须修改密码，请修改密码
      p_encryted_session_id := 'ERROR';
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_FIRST_LOGIN_CHANGE_PASSWORD',
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
    
      sys_raise_app_error_pkg.get_sys_raise_app_error(p_app_error_line_id => sys_raise_app_error_pkg.g_err_line_id,
                                                      p_message           => p_error_message);
    
    when e_password_rule_check_invalid then
      p_session_id          := -1; --你的密码不符合系统设定的密码规则定义，请重新修改密码
      p_encryted_session_id := 'ERROR';
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_USER_PASSWORD_RULE_CHECK_INVALID',
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
    
      sys_raise_app_error_pkg.get_sys_raise_app_error(p_app_error_line_id => sys_raise_app_error_pkg.g_err_line_id,
                                                      p_message           => p_error_message);
    
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(sqlerrm,
                                                     p_created_by              => 0,
                                                     p_package_name            => 'SYS_login_PKG',
                                                     p_procedure_function_name => 'login');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  end zj_ad_login;

  --************************************************************
  -- SSO用户登录
  -- parameter :
  --             p_encrypted_sso_session_id SSO登录加密的SESSION_ID
  --             p_error_message 登录出错时，界面返回的消息内容
  -- exception :
  --             e_password_null     密码为空
  --             e_password_failure  密码错误
  --             e_user_null         用户不存在
  --             e_user_faulure      用户失效
  --             e_language_null     语言不存在
  --             e_role_null exception 未分配角色
  --************************************************************
  procedure sso_login(p_encrypted_sso_session_id in varchar2,
                      p_session_id               out number,
                      p_encrypted_session_id     out varchar2,
                      p_error_message            out varchar2) is
    r_sys_user                sys_user%rowtype;
    v_encrypted_session_id    varchar2(100);
    v_language                varchar2(100);
    v_sql                     varchar2(20000);
    v_user_id                 number;
    v_role_id                 number;
    v_company_id              number;
    v_user_language           varchar2(4);
    v_client_ip_address       varchar2(30);
    v_user_name               varchar2(100);
    v_encrypted_user_password varchar2(100);
  begin
  
    begin
      select a.user_id,
             a.role_id,
             a.company_id,
             a.user_language,
             a.client_ip_address
        into v_user_id,
             v_role_id,
             v_company_id,
             v_user_language,
             v_client_ip_address
        from sys_sso_login_session a
       where a.encrypted_sso_session_id = p_encrypted_sso_session_id;
    exception
      when no_data_found then
        null;
    end;
  
    begin
      select user_name, encrypted_user_password
        into v_user_name, v_encrypted_user_password
        from sys_user
       where user_id = upper(v_user_id);
    exception
      when no_data_found then
        null;
    end;
  
    begin
      select *
        into r_sys_user
        from sys_user
       where user_name = upper(v_user_name);
    exception
      when no_data_found then
        raise e_user_null;
    end;
    begin
      select t.nls_language
        into v_language
        from sys_languages t, fnd_language_code f
       where t.language_code = f.language_code
         and t.language_code = v_user_language
         and f.installed_flag = 'Y';
    exception
      when no_data_found then
        raise e_language_null;
    end;
  
    v_sql := 'alter session set nls_language =' || chr(39) || v_language ||
             chr(39);
    execute immediate v_sql;
  
    --校验用户有效性
    validate_user(p_sys_user => r_sys_user);
  
    --校验配角色有效性
    validate_role(p_sys_user => r_sys_user);
  
    --校验用户是否被冻结
    validate_frozen_flag(p_sys_user => r_sys_user);
  
    --校验密码有效性
    --先不检查密码
    /*validate_password(p_sys_user => r_sys_user,
    p_password => p_password);*/
  
    --校验密码是否到期
    expired_password(p_sys_user => r_sys_user);
  
    --校验首次登陆必须修改密码
    first_login_change_password(p_sys_user => r_sys_user);
  
    v_encrypted_session_id := post_sso_login(p_user_name          => upper(v_user_name),
                                             p_encrypted_password => v_encrypted_user_password,
                                             p_ip                 => v_client_ip_address);
  
    p_encrypted_session_id := v_encrypted_session_id;
    if p_encrypted_session_id is not null then
      p_session_id := sys_session_pkg.get_session_id(p_encrypted_session_id);
    end if;
  
    --角色选择
    role_select(p_encryted_session_id => p_encrypted_session_id,
                p_role_id             => v_role_id,
                p_company_id          => v_company_id,
                p_app_ip_address      => null,
                p_client_ip_address   => v_client_ip_address,
                p_description         => null);
  
    --删除SSO登陆SESSION记录
    sys_sso_login_session_pkg.delete_sso_login_session(p_encrypted_sso_session_id => p_encrypted_sso_session_id);
  
    p_error_message := ' ';
  
  exception
    when e_role_null then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_USER_ROLE_NULL', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'SSO_LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    when e_language_null then
      --自定义异常
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_LANGUAGE_NULL', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'SSO_LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    when e_password_failure then
      --自定义异常
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_PASSWORD_FAILURE', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'SSO_LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    when e_password_null then
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_PASSWORD_NULL', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'SSO_LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    when e_user_failure then
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_USER_FAILURE', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'SSO_LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    when e_user_null then
    
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_USER_NULL', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'SSO_LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    when e_frozen_failure then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_FROZEN_FAILURE', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'SSO_LOGIN');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
    when e_password_expired then
      p_session_id           := -1; --你的密码已经过期，请修改密码
      p_encrypted_session_id := 'ERROR';
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_USER_PASSWORD_EXPIRED',
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'SSO_LOGIN');
    
      sys_raise_app_error_pkg.get_sys_raise_app_error(p_app_error_line_id => sys_raise_app_error_pkg.g_err_line_id,
                                                      p_message           => p_error_message);
    
    when e_first_login_change_password then
      p_session_id           := -1; --首次登陆必须修改密码，请修改密码
      p_encrypted_session_id := 'ERROR';
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_FIRST_LOGIN_CHANGE_PASSWORD',
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'LOGIN');
    
      sys_raise_app_error_pkg.get_sys_raise_app_error(p_app_error_line_id => sys_raise_app_error_pkg.g_err_line_id,
                                                      p_message           => p_error_message);
    
    when e_password_rule_check_invalid then
      p_session_id           := -1; --你的密码不符合系统设定的密码规则定义，请重新修改密码
      p_encrypted_session_id := 'ERROR';
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_USER_PASSWORD_RULE_CHECK_INVALID',
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'SSO_LOGIN');
    
      sys_raise_app_error_pkg.get_sys_raise_app_error(p_app_error_line_id => sys_raise_app_error_pkg.g_err_line_id,
                                                      p_message           => p_error_message);
    
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(sqlerrm,
                                                     p_created_by              => 0,
                                                     p_package_name            => 'SYS_LOGIN_PKG',
                                                     p_procedure_function_name => 'SSO_LOGIN');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  end sso_login;

  --************************************************************
  -- 角色选择
  --************************************************************
  procedure role_select(p_encryted_session_id varchar2,
                        p_role_id             number,
                        p_company_id          number,
                        p_app_ip_address      varchar2,
                        p_client_ip_address   varchar2,
                        p_description         varchar2 default null) is
    v_session_id  number;
    v_sys_user_id number;
    v_count       number;
  begin
  
    if p_role_id is null or p_company_id is null then
      if p_role_id is not null then
        --判断是否已经存在公司
        select count(1) into v_count from fnd_companies a;
      
        if v_count > 0 then
          --如果已经存在公司，则一定要分配公司
          raise e_role_null;
        end if;
      
      else
        raise e_role_null;
      end if;
    end if;
  
    v_session_id := sys_session_pkg.get_session_id(p_encryted_session_id);
  
    -- 更新SESSION 信息
    update sys_session t
       set t.role_id           = p_role_id,
           t.company_id        = p_company_id,
           t.app_ip_address    = p_app_ip_address,
           t.client_ip_address = p_client_ip_address
     where t.session_id = v_session_id;
  
    --创建登录日志
    select t.user_id
      into v_sys_user_id
      from sys_session t
     where t.session_id = v_session_id;
  
    create_login(p_sys_user_id         => v_sys_user_id,
                 p_role_id             => p_role_id,
                 p_company_id          => p_company_id,
                 p_session_id          => v_session_id,
                 p_encryted_session_id => p_encryted_session_id,
                 p_client_ip_address   => p_client_ip_address,
                 p_app_ip_address      => p_app_ip_address,
                 p_description         => p_description);
  
  exception
    when e_role_null then
      sys_raise_app_error_pkg.raise_user_define_error(p_message_code            => 'SYS_USER_ROLE_NULL', --自定义的错误消息
                                                      p_created_by              => 0,
                                                      p_package_name            => 'SYS_LOGIN_PKG',
                                                      p_procedure_function_name => 'role_select');
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    when others then
      sys_raise_app_error_pkg.raise_sys_others_error(sqlerrm,
                                                     p_created_by              => 0,
                                                     p_package_name            => 'SYS_LOGIN_PKG',
                                                     p_procedure_function_name => 'role_select');
    
      raise_application_error(sys_raise_app_error_pkg.c_error_number,
                              sys_raise_app_error_pkg.g_err_line_id);
    
  end role_select;
  --标准实现
  procedure ad_login_standard(p_user_name                in varchar2,
                              p_ip                       in varchar2,
                              p_session_id               out number,
                              p_user_id                  out number,
                              p_role_id                  out number,
                              p_company_id               out number,
                              p_lang                     out varchar2,
                              p_old_encrypted_session_id in varchar2,
                              p_encrypted_session_id     out varchar2) is
    l_max_last_active_time date;
  begin
    --获取user_id
    begin
      p_user_id    := -1;
      p_role_id    := -1;
      p_company_id := -1;
      select user_id
        into p_user_id
        from sys_user
       where user_name = p_user_name
         and trunc(start_date) <= trunc(sysdate)
         and (trunc(end_date) >= trunc(sysdate) or end_date is null);
    
      --更新最后日期
      update sys_user
         set last_logon_date = sysdate, last_update_date = sysdate
       where user_id = p_user_id;
      --check session
      begin
        select last_active_time
          into l_max_last_active_time
          from (select last_active_time
                  from sys_user_logins
                 where encrypted_session_id = p_old_encrypted_session_id
                 order by last_active_time desc)
         where rownum = 1;
      
        select role_id, company_id, nls_language, session_id
          into p_role_id, p_company_id, p_lang, p_session_id
          from sys_user_logins
         where encrypted_session_id = p_old_encrypted_session_id
           and last_active_time = l_max_last_active_time;
        p_encrypted_session_id := p_old_encrypted_session_id;
      exception
        when no_data_found then
          select sys_session_s.nextval into p_session_id from dual;
          p_encrypted_session_id := sys_crypt.des_encrypt(to_char(p_session_id));
          p_lang                 := userenv('lang');
      end;
      --create session
    
      insert into sys_session
        (session_id,
         encrypted_session_id,
         user_id,
         role_id,
         company_id,
         user_language,
         app_ip_address,
         client_ip_address,
         login_time,
         logout_time,
         last_active_time,
         note,
         last_update_date,
         last_updated_by,
         creation_date,
         created_by)
      values
        (p_session_id,
         p_encrypted_session_id,
         p_user_id,
         p_role_id,
         p_company_id,
         p_lang,
         null,
         p_ip,
         sysdate,
         null,
         sysdate,
         null,
         sysdate,
         p_user_id,
         sysdate,
         p_user_id);
    end;
    commit;
  end ad_login_standard;
  --************************************************************
  -- AD用户登录
  -- parameter :
  --            p_user_name            in varchar2, 用户名
  --            p_role_code            in varchar2, 角色code
  --            p_company_code         in varchar2,公司code
  --            p_session_id           out number,返回session_id
  --            p_user_id              out number,返回user_id
  --            p_role_id              out number,返回role_id
  --            p_company_id           out number,  返回company_id
  --            p_encrypted_session_id out varchar2,返回加密session_id
  --************************************************************
  procedure ad_login(p_user_name                in varchar2,
                     p_ip                       in varchar2,
                     p_session_id               out number,
                     p_user_id                  out number,
                     p_role_id                  out number,
                     p_company_id               out number,
                     p_lang                     out varchar2,
                     p_old_encrypted_session_id in varchar2,
                     p_encrypted_session_id     out varchar2) is
  begin
    --调用标准实现
    ad_login_standard(p_user_name                => p_user_name,
                      p_ip                       => p_ip,
                      p_session_id               => p_session_id,
                      p_user_id                  => p_user_id,
                      p_role_id                  => p_role_id,
                      p_company_id               => p_company_id,
                      p_lang                     => p_lang,
                      p_old_encrypted_session_id => p_old_encrypted_session_id,
                      p_encrypted_session_id     => p_encrypted_session_id);
  end ad_login;
end sys_login_pkg;
/
