/*
 * Copyright
 */

package test.bean.advice;

import java.lang.reflect.Method;

import org.springframework.aop.MethodBeforeAdvice;
import org.springframework.stereotype.Service;

/**
 * AOP
 * 
 * @author Sun
 * @version ServiceBeforeAdvice.java 2010-3-10 下午03:00:35
 */
@Service
public class ServiceBeforeAdvice implements MethodBeforeAdvice {
    /**
     * 前置增强(MethodBeforeAdvice) 目标方法调用前执行
     */
    public void before(Method method, Object[] args, Object obj)
            throws Throwable {
        System.out.println("advice before method " + obj.getClass().getName()
                + "." + method.getName() + "().");
    }
}
