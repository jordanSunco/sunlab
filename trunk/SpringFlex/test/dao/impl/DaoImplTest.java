/*
 * Copyright
 */

package dao.impl;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractTransactionalJUnit4SpringContextTests;

import dao.Dao;

/**
 * 
 * @author Sun
 * @version DaoImplTest.java 2010-9-21 上午10:30:23
 */
@ContextConfiguration(locations = { "classpath:spring/applicationContext.xml",
        "classpath:spring/applicationContextProject.xml" })
public class DaoImplTest extends AbstractTransactionalJUnit4SpringContextTests {
    @Autowired
    private Dao dao;

    @Test
    public void testTest() {
        this.dao.test();
    }
}
