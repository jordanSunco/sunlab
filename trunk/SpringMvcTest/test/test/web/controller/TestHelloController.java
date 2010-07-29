/*
 * Copyright
 */

package test.web.controller;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;

/**
 * Spring 2.5.6 结合 JUint 4.4 完成单元测试
 * 
 * @author Sun
 * @version TestHelloController.java 2010-7-28 上午09:52:35
 */
@ContextConfiguration(locations = { "classpath:applicationContext.xml",
        "classpath:spring-mvc-servlet.xml" })
public class TestHelloController extends AbstractJUnit4SpringContextTests {
    @Autowired
    private HelloController helloController;

    /**
     * Test method for
     * {@link test.web.controller.HelloController#handleRequest(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)}
     * .
     * 
     * @throws Exception
     */
    @Test
    public void testHandleRequest() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();

        this.helloController.handleRequest(request, response);
    }
}
