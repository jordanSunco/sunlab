/*
 * Copyright
 */

package test.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

/**
 * 实体类 ORM 映射, 采用 Hibernate XML 映射或注解映射
 * 
 * @author Sun
 * @version User.java 2010-3-5 上午11:28:15
 */
//@Entity
//@Table
//@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class User {
//    @Id
    private long id;

//    @Column
    private String name;

    /**
     * @return the id
     */
    public long getId() {
        return this.id;
    }

    /**
     * @param id the id to set
     */
    public void setId(long id) {
        this.id = id;
    }

    /**
     * @return the name
     */
    public String getName() {
        return this.name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }
}
