/*
 * Copyright
 */

package test.jws.cxf;

import org.apache.cxf.interceptor.LoggingInInterceptor;
import org.apache.cxf.interceptor.LoggingOutInterceptor;
import org.apache.cxf.jaxws.JaxWsProxyFactoryBean;

import test.jws.service.HelloWorld;

/**
 * CXF jaxws factory bean 更简单的实现客户端
 * 
 * @author Sun
 * @version Client.java 2010-10-15 下午05:41:50
 * @see "http://cxf.apache.org/docs/a-simple-jax-ws-service.html"
 */
public class Client {
    public static void main(String args[]) throws Exception {
        JaxWsProxyFactoryBean factory = new JaxWsProxyFactoryBean();
        factory.getInInterceptors().add(new LoggingInInterceptor());
        factory.getOutInterceptors().add(new LoggingOutInterceptor());

        factory.setAddress("http://localhost:9000/helloWorld");
        factory.setServiceClass(HelloWorld.class);

        HelloWorld client = (HelloWorld) factory.create();
        System.out.println(client.sayHi("World"));
    }
}
