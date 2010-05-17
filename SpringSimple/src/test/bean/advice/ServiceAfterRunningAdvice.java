/*
 * Copyright
 */

package test.bean.advice;

import java.lang.reflect.Method;

import org.springframework.aop.AfterReturningAdvice;
import org.springframework.stereotype.Service;

/**
 * AOP概念
 * 连接点(Joinpoint): 程序执行的某个特定位置, 比如方法调用前后, 类初始化前,异常抛出之后.
 * 增强(Advice): 植入到目标类的连接点上的程序代码.
 * 目标对象(Target): 需要被增强的类.
 * 代理(Proxy): 被植入增强之后产生的结果类.
 * 
 * @author Sun
 * @version ServiceAfterRunningAdvice.java 2010-3-10 下午03:01:41
 */
@Service
public class ServiceAfterRunningAdvice implements AfterReturningAdvice {
    /**
     * 后置增强(AfterReturningAdvice) 目标方法调用后执行
     */
    public void afterReturning(Object returnObj, Method method, Object[] args,
            Object target) throws Throwable {
        System.out.println("method " + target.getClass().getName() + "."
                + method.getName() + "() has been executed.");
    }
}
