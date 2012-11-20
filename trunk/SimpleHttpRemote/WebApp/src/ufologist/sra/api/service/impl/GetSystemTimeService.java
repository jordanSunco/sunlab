/*
 * Copyright 
 */

package ufologist.sra.api.service.impl;

import java.util.Date;
import java.util.Map;

import ufologist.sra.api.service.Service;
import ufologist.sra.model.Foo;

/**
 * 远程服务类
 * 
 * @author Sun
 * @version GetSystemTimeService.java 2012-11-20 下午3:21:38
 */
public class GetSystemTimeService implements Service {
    public Foo execute(Map param) {
        System.out.println("远程调用参数: " + param);
        Foo foo = new Foo();
        foo.setDate(new Date().toString());
        return foo;
    }
}
