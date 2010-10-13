/*
 * Copyright
 */

package service;

import domain.Domain;

/**
 * 服务接口
 * 
 * @author Sun
 * @version DomainService.java 2010-9-27 下午05:25:39
 */
public interface DomainService {
    /**
     * 获取领域模型
     * 
     * @param id
     * @return 模型
     */
    Domain getDomain(int id);
}
