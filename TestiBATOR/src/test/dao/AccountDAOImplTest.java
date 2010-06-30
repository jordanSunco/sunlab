/*
 * Copyright
 */

package dao;

import java.sql.SQLException;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;

/**
 * 
 * @author Sun
 * @version AccountDAOImplTest.java 2010-5-25 下午04:02:37
 */
public class AccountDAOImplTest {
    private static final String SQL_MAP_CONFIG = "domain/sqlMapConfig.xml";
    private static SqlMapClient sqlMapClient;
    private AccountDAOImpl accountDAOImpl;

    /**
     * 
     * @throws java.lang.Exception
     */
    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        sqlMapClient = SqlMapClientBuilder.buildSqlMapClient(Resources
                .getResourceAsReader(SQL_MAP_CONFIG));
    }

    /**
     * 
     * @throws java.lang.Exception
     */
    @AfterClass
    public static void tearDownAfterClass() throws Exception {
        sqlMapClient = null;
    }

    /**
     * 
     * @throws java.lang.Exception
     */
    @Before
    public void setUp() throws Exception {
        this.accountDAOImpl = new AccountDAOImpl(sqlMapClient);
    }

    /**
     * 
     * @throws java.lang.Exception
     */
    @After
    public void tearDown() throws Exception {
        this.accountDAOImpl = null;
    }

    /**
     * Test method for {@link dao.AccountDAOImpl#read()}.
     * 
     * @throws SQLException
     */
    @Test
    public void testRead() throws SQLException {
        System.out.println(this.accountDAOImpl.selectByPrimaryKey(1));
    }
}
