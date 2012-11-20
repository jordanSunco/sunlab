/*
 * Copyright 
 */

package ufologist.sra.servlet;

import java.io.IOException;
import java.lang.reflect.Constructor;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;

import ufologist.sra.api.request.Request;
import ufologist.sra.api.service.Response;
import ufologist.sra.api.service.Service;

import com.alibaba.fastjson.JSON;

/**
 * 简单服务接口调用servlet, 接收所有API调用, 返回调用结果
 * 
 * @author Sun
 * @version SimpleRemoteApiServlet.java 2012-11-20 下午3:16:09
 */
public class SimpleRemoteApiServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        try {
            executeService(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void executeService(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        // 获得http request body
        String requestBody = IOUtils.toString(request.getReader());
        Request req = JSON.parseObject(requestBody, Request.class);

        Service service = newInstance(req.getServiceClass());
        Object result = service.execute(req.getParam());

        Response resp = new Response();
        resp.setResultClass(result.getClass().getName());
        resp.setResultJson(JSON.toJSONString(result));

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(JSON.toJSONString(resp));
    }

    private <T> T newInstance(String className) throws Exception {
        Class clazz = Class.forName(className);
        Constructor cons = clazz.getConstructor();
        Object obj = cons.newInstance();
        return (T) obj;
    }
}
