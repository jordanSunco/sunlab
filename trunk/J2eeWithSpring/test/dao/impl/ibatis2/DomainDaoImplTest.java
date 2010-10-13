/*
 * Copyright
 */

package dao.impl.ibatis2;

import static org.junit.Assert.assertEquals;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractTransactionalJUnit4SpringContextTests;

import dao.DomainDao;

/**
 * DAO单元测试
 * 
 * @author Sun
 * @version DomainDaoImplTest.java 2010-9-28 上午11:51:47
 */
@ContextConfiguration(locations = { "classpath:applicationContext.xml" })
public class DomainDaoImplTest extends
        AbstractTransactionalJUnit4SpringContextTests {
    @Autowired
    private DomainDao domainDao;

    @Test
    public void testRead() {
        assertEquals(1, this.domainDao.read(1).getId());
    }
}
