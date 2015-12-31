package com.me.utils;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;

public class PostProcessorInit implements BeanPostProcessor {


	@Override
	public Object postProcessBeforeInitialization(Object obj, String arg1)
			throws BeansException {
//		if(obj instanceof SysServiceUrlUtils)//SysServiceUrlUtils为类名   
//        {   
			//SysServiceUrlUtils.sys_service_init();//sys_service_init为SysServiceUrlUtils的方法   
//        }  
		return obj;
	}

	@Override
	public Object postProcessAfterInitialization(Object obj, String arg1)
			throws BeansException {
		if(obj instanceof SysServiceUrlUtils)//SysServiceUrlUtils为类名   
        {   
			try {
				SysServiceUrlUtils.sys_service_init();//sys_service_init为SysServiceUrlUtils的方法   
				SysServiceUrlUtils.sys_code_init();
				SysServiceUrlUtils.sys_function_init();
				SysServiceUrlUtils.initlogurl();
			} catch (Exception e) {
				e.printStackTrace();
			}	
        }   

		return obj;
	}

}
