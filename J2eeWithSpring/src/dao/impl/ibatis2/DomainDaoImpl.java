/*
 * Copyright
 */

package dao.impl.ibatis2;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;
import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;

import dao.DomainDao;
import domain.Domain;

/**
 * 基于iBATIS的DAO实现
 * 
 * @author Sun
 * @version DomainDaoImpl.java 2010-9-27 下午04:19:54
 */
@Repository
public class DomainDaoImpl extends SqlMapClientDaoSupport implements DomainDao {
    /**
     * 构造函数自动注入SqlMapClient, 否则必须通过spring bean来配置
     * 
     * @param sqlMapClient iBATIS SQL map client
     */
    @Autowired
    public DomainDaoImpl(SqlMapClient sqlMapClient) {
        this.setSqlMapClient(sqlMapClient);
    }

    public Domain read(int id) throws DataAccessException {
        return (Domain) this.getSqlMapClientTemplate().queryForObject(
                "Domain.read", id);
    }
}
