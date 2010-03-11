/*
 * Copyright
 */

package test.bean.advice;

import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;
import org.springframework.stereotype.Service;

/**
 * AOP
 * 
 * @author Sun
 * @version ServiceInterceptor.java 2010-3-10 下午03:02:55
 */
@Service
public class ServiceInterceptor implements MethodInterceptor {
    /**
     * 环绕增强(MethodInterceptor) 方法前后都会执行
     */
    public Object invoke(MethodInvocation invocation) throws Throwable {
        // 目标方法的参数
        Object[] args = invocation.getArguments();

        System.out.println("the method "
                + invocation.getThis().getClass().getName() + "."
                + invocation.getMethod().getName() + "() arguments: "
                + args.length + " will be executed.");

        // 执行目标方法
        Object obj = invocation.proceed();

        System.out.println("the method "
                + invocation.getThis().getClass().getName() + "."
                + invocation.getMethod().getName() + "() has been executed.");

        return obj;
    }
}
