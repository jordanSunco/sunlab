/*
 * Copyright 
 */

package ufologist.sra.client;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import ufologist.sra.api.SimpleRemoteApi;
import ufologist.sra.api.request.Request;
import ufologist.sra.api.request.impl.GetSystemTimeRequest;
import ufologist.sra.model.Foo;

/**
 * 测试在客户端调用远程服务方法
 * 
 * @author Sun
 * @version Main.java 2012-11-20 下午3:20:15
 */
public class Main {
    public static void main(String[] args) {
        String serverUrl = "http://localhost:8080/WebApp/SimpleRemoteApiServlet";

        Request request = new GetSystemTimeRequest();

        Map<String, String> param = new HashMap<String, String>();
        param.put("param1", "测试传递参数"); 
        param.put("param2", new Date().toString()); 
        request.setParam(param);

        Foo foo = SimpleRemoteApi.sendRequest(serverUrl, request);
        System.out.println(foo.getDate());
    }
}
