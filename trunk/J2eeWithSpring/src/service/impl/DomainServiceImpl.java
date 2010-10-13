/*
 * Copyright
 */

package service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import service.DomainService;
import dao.DomainDao;
import domain.Domain;

/**
 * 
 * @author Sun
 * @version DomainServiceImpl.java 2010-9-27 下午05:27:27
 */
@Service
public class DomainServiceImpl implements DomainService {
    @Autowired
    DomainDao domainDao;

    public Domain getDomain(int id) {
        return this.domainDao.read(id);
    }
}
