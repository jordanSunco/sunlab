/*
 * Copyright 
 */

package ufologist.sra.api.request;

import java.util.Map;

/**
 * 客户端请求
 * 
 * @author Sun
 * @version Request.java 2012-11-9 上午10:39:14
 */
public class Request {
    /**
     * 请求服务实现类
     */
    private String serviceClass;

    /**
     * 请求参数
     */
    private Map param;

    public String getServiceClass() {
        return this.serviceClass;
    }
    public void setServiceClass(String serviceClass) {
        this.serviceClass = serviceClass;
    }
    public Map getParam() {
        return this.param;
    }
    public void setParam(Map param) {
        this.param = param;
    }
}
