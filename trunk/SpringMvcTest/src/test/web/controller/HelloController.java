/*
 * Copyright
 */

package test.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import test.service.Service;

/**
 * 最简单的Spring MVC Control
 * 
 * @author Sun
 * @version SimpleControl.java 2010-7-26 下午11:13:12
 */
public class HelloController implements Controller {
    private Service service;

    public ModelAndView handleRequest(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView(this.service.getHello());
        modelAndView.addObject("hello", request.getParameter("hello"));

        return modelAndView;
    }

    /**
     * @param service the service to set
     */
    public void setService(Service service) {
        this.service = service;
    }
}
