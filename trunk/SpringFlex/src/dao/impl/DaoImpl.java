/*
 * Copyright
 */

package dao.impl;

import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import dao.Dao;

/**
 * 
 * @author Sun
 * @version DaoImpl.java 2010-9-21 上午10:58:00
 */
public class DaoImpl extends SqlMapClientDaoSupport implements Dao {
    public void test() {
        System.out.println(this.getSqlMapClientTemplate().queryForObject("dao.find"));
    }
}
