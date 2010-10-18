/*
 * Copyright
 */

package test.jws;

import static org.junit.Assert.assertEquals;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;

import test.jws.service.HelloWorld;

/**
 * 
 * @author Sun
 * @version ClientTest.java 2010-10-18 上午10:52:51
 */
@ContextConfiguration(locations = { "classpath:applicationContext.xml" })
public class ClientTest extends AbstractJUnit4SpringContextTests {
    @Autowired
    private HelloWorld helloWorld;

    @Test
    public void testSayHi() {
        assertEquals("Hello World", this.helloWorld.sayHi("World"));
    }
}
