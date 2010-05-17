/*
 * Copyright
 */

package test.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import test.dao.IUserDao;
import test.entity.User;

/**
 * 
 * @author Sun
 * @version UserService.java 2010-3-5 上午11:41:28
 */
@Service
// @Transactional
public class UserService implements IUserService {
    @Autowired
    private IUserDao userDao;
    
    public User getUserById(long id) {
        return this.userDao.findById(id);
    }
}
