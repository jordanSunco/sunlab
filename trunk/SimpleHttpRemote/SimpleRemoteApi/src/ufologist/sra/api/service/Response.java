/*
 * Copyright 
 */

package ufologist.sra.api.service;

/**
 * 服务返回结果
 * 
 * @author Sun
 * @version Result.java 2012-11-15 下午4:03:36
 */
public class Response {
    /**
     * 返回结果的类名
     */
    private String resultClass;

    /**
     * 返回结果的JSON字符串
     */
    private String resultJson;

    public String getResultClass() {
        return this.resultClass;
    }
    public void setResultClass(String resultClass) {
        this.resultClass = resultClass;
    }
    public String getResultJson() {
        return resultJson;
    }
    public void setResultJson(String resultJson) {
        this.resultJson = resultJson;
    }
}
