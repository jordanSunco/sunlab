/*
 * Copyright
 */

package dao.impl.ibatis2;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractTransactionalJUnit4SpringContextTests;

import dao.Dao;

/**
 * 
 * @author Sun
 * @version DaoImplTest.java 2010-10-14 下午04:22:38
 */
@ContextConfiguration(locations = { "classpath:spring/applicationContext.xml",
        "classpath:spring/applicationContextDao.xml" })
public class DaoImplTest extends AbstractTransactionalJUnit4SpringContextTests {
    @Autowired
    private Dao dao;

    @Test
    public void testTest() {
        this.dao.test();
    }
}
