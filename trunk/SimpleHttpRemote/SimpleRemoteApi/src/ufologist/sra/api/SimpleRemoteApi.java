/*
 * Copyright 
 */

package ufologist.sra.api;

import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.AbstractHttpClient;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;

import ufologist.sra.api.request.Request;
import ufologist.sra.api.service.Response;

import com.alibaba.fastjson.JSON;

/**
 * API调用类
 * 
 * @author Sun
 * @version SimpleRemoteApi.java 2012-11-9 下午4:15:29
 */
public class SimpleRemoteApi {
    public static <T> T sendRequest(String serverUrl, Request request) {
        String responseBody = "";

        AbstractHttpClient httpclient = new DefaultHttpClient();
        HttpPost httppost = new HttpPost(serverUrl);
        BasicResponseHandler responseHandler = new BasicResponseHandler();

        try {
            StringEntity requestJson = new StringEntity(JSON.toJSONString(request),
                    ContentType.APPLICATION_JSON);
            // 将json放入http request body
            httppost.setEntity(requestJson);
            responseBody = httpclient.execute(httppost, responseHandler);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            httpclient.getConnectionManager().shutdown();
        }

        Response response = JSON.parseObject(responseBody, Response.class);
        String resultClass = response.getResultClass();
        String resultJson = response.getResultJson();
        Class resultClazz = null;
        try {
            resultClazz = Class.forName(resultClass);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return (T) JSON.parseObject(resultJson, resultClazz);
    }
}
