/*
 * Copyright
 */

package service.impl;

import static org.junit.Assert.assertEquals;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractTransactionalJUnit4SpringContextTests;

import service.DomainService;

/**
 * service单元测试
 * 
 * @author Sun
 * @version DomainServiceImplTest.java 2010-9-28 上午11:51:12
 */
@ContextConfiguration(locations = { "classpath:applicationContext.xml" })
public class DomainServiceImplTest extends
        AbstractTransactionalJUnit4SpringContextTests {
    @Autowired
    private DomainService domainService;

    @Test
    public void testGetDomain() {
        assertEquals(1, this.domainService.getDomain(1).getId());
    }
}
