/*
 * Copyright
 */

package dao;

import domain.Domain;

/**
 * 数据访问接口
 * 
 * @author Sun
 * @version Dao.java 2010-9-27 下午04:17:09
 */
public interface DomainDao {
    /**
     * 获取指定ID的模型
     * 
     * @param id 模型ID
     * @return 领域模型
     */
    Domain read(int id);
}
