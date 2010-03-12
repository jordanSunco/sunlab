/*
 * Copyright
 */

package test.dao;

import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import test.entity.User;

/**
 * 实现 Hibernate (HibernateDaoSupport) Dao 层
 * 
 * @author Sun
 * @version UserDao.java 2010-3-11 下午04:32:00
 */
public class UserDao extends HibernateDaoSupport implements IUserDao {
    public User findById(long id) {
        return (User) getHibernateTemplate().get(User.class, id);
    }
}
