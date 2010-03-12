/*
 * Copyright
 */

package test;

import org.apache.commons.logging.LogFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import test.service.IUserService;

/**
 * 
 * @author Sun
 * @version TestMain.java 2010-3-11 下午04:20:39
 */
public class TestMain {
    public static void main(String[] args) {
        ClassPathXmlApplicationContext beanFactory = new ClassPathXmlApplicationContext(
                "applicationContext*.xml");

        IUserService userService = (IUserService) beanFactory
                .getBean("userService");

        LogFactory.getLog(TestMain.class).info(userService.getUserById(1).getName());
    }
}
