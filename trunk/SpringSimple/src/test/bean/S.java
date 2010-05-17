/*
 * Copyright
 */

package test.bean;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import test.IS;

/**
 * 服务的具体实现
 * 通过注解的方式注册及依赖
 * 
 * @author Sun
 * @version S.java 2010-3-10 下午03:35:01
 */
@Service
public class S implements IS{
    @Autowired
//    @Qualifier("a")
    private A a;
    
    public void orz() {
        System.out.println("ORZ: " + this.a.getaString());
    }
    
    public void zro() {
        System.out.println("ZRO: " + this.a.getaString());
    }
}
