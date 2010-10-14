/*
 * Copyright
 */

package dao.impl.ibatis2;

import org.springframework.dao.DataAccessException;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

import dao.Dao;

/**
 * 
 * @author Sun
 * @version DaoImpl.java 2010-10-14 下午04:17:34
 */
public class DaoImpl extends SqlMapClientDaoSupport implements Dao {
    public void test() throws DataAccessException {
        System.out.println(this.getSqlMapClientTemplate().queryForObject(
                "Dao.find"));
    }
}
