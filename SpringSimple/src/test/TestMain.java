/*
 * Copyright
 */

package test;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.aop.framework.ProxyFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import test.bean.S;
import test.bean.advice.ServiceAfterRunningAdvice;
import test.bean.advice.ServiceBeforeAdvice;
import test.bean.advice.ServiceInterceptor;

/**
 * 
 * @author Sun
 * @version TestMain.java 2010-3-10 下午02:13:07
 */
public class TestMain {
    /**
     * 使用log4j来记录日志
     */
    private Log log = LogFactory.getLog(TestMain.class);

    /**
     * 简单情况下可以使用BeanFactory
     * BeanFactory beanFactory = new XmlBeanFactory(new ClassPathResource("applicationContext.xml"));
     * 当使用到PropertyPlaceholderConfigurer加载properties配置文件时必须用ApplicationContext
     */
    private ClassPathXmlApplicationContext beanFactory = new ClassPathXmlApplicationContext(
            "applicationContext.xml");

    public static void main(String[] args) {
        TestMain testMain = new TestMain();
        
        testMain.testProxyFactory();
//        testMain.testConfigProxy();
//        testMain.testBeanNameAutoProxy();
    }
    
    /**
     * 测试 ProxyFactory 编码方式实现 AOP
     */
    public void testProxyFactory() {
        this.log.info("测试 ProxyFactory 编码方式实现 AOP");
        
        // IoC容器中取出 服务实现对象
        S s = (S) this.beanFactory.getBean("s");
        // 前置增强
        ServiceBeforeAdvice serviceBeforeAdvice = (ServiceBeforeAdvice) this.beanFactory
                .getBean("serviceBeforeAdvice");
        // 后置增强
        ServiceAfterRunningAdvice serviceAfterRunningAdvice = (ServiceAfterRunningAdvice) this.beanFactory
                .getBean("serviceAfterRunningAdvice");
        // 环绕增强
        ServiceInterceptor serviceInterceptor = (ServiceInterceptor) this.beanFactory
                .getBean("serviceInterceptor");

        ProxyFactory pf = new ProxyFactory();
        pf.setTarget(s);
        pf.addAdvice(serviceBeforeAdvice);
//        pf.addAdvice(serviceAfterRunningAdvice);
//        pf.addAdvice(serviceInterceptor);
        // 取出增加后的代理类
        IS is = (IS) pf.getProxy();
        is.orz();
        is.zro();
    }
    
    /**
     * 测试以配置形式使用AOP
     */
    public void testConfigProxy() {
        this.log.info("测试以配置形式使用AOP");
        
        IS is = (IS) this.beanFactory.getBean("proxyS");
        is.orz();
        is.zro();
    }
    
    /**
     * 测试AOP自动代理
     */
    public void testBeanNameAutoProxy() {
        this.log.info("测试AOP自动代理");
        
        IS is = (IS) this.beanFactory.getBean("s");
        is.orz();
        is.zro();
    }
}
