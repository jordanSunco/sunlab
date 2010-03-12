/*
 * Copyright
 */

package test.service;

import java.util.List;

import test.entity.User;

/**
 * 服务层接口
 * 
 * @author Sun
 * @version IUserService.java 2010-3-11 下午04:30:04
 */
public interface IUserService {
    User getUserById(long id);
}
