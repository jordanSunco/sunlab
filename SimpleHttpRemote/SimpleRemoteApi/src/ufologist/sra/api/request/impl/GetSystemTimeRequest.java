/*
 * Copyright 
 */

package ufologist.sra.api.request.impl;

import ufologist.sra.api.request.Request;

/**
 * 具体请求实现类
 * 可以不用一个个实现, 直接实例化Request对象, 指向需要调用的远程服务类即可
 * 
 * @author Sun
 * @version GetSystemTimeRequest.java 2012-11-9 上午10:43:37
 */
public class GetSystemTimeRequest extends Request {
    public String getServiceClass() {
        return "ufologist.sra.api.service.impl.GetSystemTimeService";
    }
}
