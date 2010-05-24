/*
 * Copyright
 */

package dao;

import org.springframework.jdbc.core.support.JdbcDaoSupport;

/**
 * 测试
 * 
 * @author Sun
 * @version TestDao.java 2010-5-24 下午02:32:40
 */
public class TestDao extends JdbcDaoSupport {
    /**
     * 测试连接数据库
     */
    public void test() {
        System.out.println(this.getJdbcTemplate().queryForList("SELECT * FROM INFORMATION_SCHEMA.TABLES"));
    }
}
