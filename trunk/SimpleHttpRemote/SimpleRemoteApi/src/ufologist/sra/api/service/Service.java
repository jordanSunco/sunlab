/*
 * Copyright 
 */

package ufologist.sra.api.service;

import java.util.Map;

/**
 * 服务接口
 * 
 * @author Sun
 * @version Service.java 2012-11-9 上午11:24:05
 */
public interface Service {
    public <T> T execute(Map param);
}
