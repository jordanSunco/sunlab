/*
 * Copyright
 */

package test.dao;

import java.util.List;

import test.entity.User;

/**
 * 数据访问(DAO) 层接口(CUID)
 * 
 * @author Sun
 * @version IUserDao.java 2010-3-11 下午04:33:35
 */
public interface IUserDao {
    User findById(long id);
    
//    List<User> list();
//    void insert(User user);
//    void insert(List<User> users);
//    void update(User user);
//    void delete(long id);
}
