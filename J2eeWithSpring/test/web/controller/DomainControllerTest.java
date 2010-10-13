/*
 * Copyright
 */

package web.controller;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractTransactionalJUnit4SpringContextTests;
import org.springframework.ui.ExtendedModelMap;

/**
 * controller单元测试
 * 
 * @author Sun
 * @version DomainControllerTest.java 2010-9-21 上午10:30:23
 */
@ContextConfiguration(locations = { "classpath:applicationContext.xml" })
public class DomainControllerTest extends
        AbstractTransactionalJUnit4SpringContextTests {
    @Autowired
    private DomainController modelController;

    @Test
    public void testList() throws Exception {
        this.modelController.list(1, new ExtendedModelMap());
    }
}
