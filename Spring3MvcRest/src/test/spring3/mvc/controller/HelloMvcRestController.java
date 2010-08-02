/*
 * Copyright
 */

package test.spring3.mvc.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import test.spring3.mvc.model.Human;

/**
 * 使用Spring 3 MVC 实现RESTful
 * 
 * @author Sun
 * @version HelloMvcRest.java 2010-7-29 下午02:24:49
 */
@Controller
@RequestMapping("/hello")
public class HelloMvcRestController {
    /**
     * 测试URL参数绑定
     * http://localhost:8080/Spring3MvcRest/hello/world?a=hello&id=1&name=robot&ids=1,2,3&names=n1&names=n2&names=n3&male=1&nameList=1,HH,SD&child.id=2
     * 
     * @param a 绑定Request Parameter a
     * @param human 绑定Request Parameter id, name, ids, names, male, nameList, child.id...
     * @param model 返回到View的模型, 可以使用context模块的ui.Model, 而不是servlet模块ModelAndView
     * @return 视图逻辑名
     */
    @RequestMapping("/world")
    public String world(String a, Human human, Model model) {
        model.addAttribute("hello", a);
        return "world";
    }

    /**
     * 测试返回JavaBean 自动转换成JSON或者XML, 依据客户端Accept来决定(内容协商)
     * http://localhost:8080/Spring3MvcRest/hello/rest/1/foo
     * 
     * @param a 绑定URL路径 {a}
     * @param b 绑定URL路径 {b}
     * @return JSON
     */
    @RequestMapping("/rest/{a}/{b}")
    public @ResponseBody Human rest(@PathVariable int a, @PathVariable String b) {
        Human human = new Human();
        human.setId(a);
        human.setName(b);
        return human;
    }

    /**
     * 测试返回Map 自动转换成JSON
     * http://localhost:8080/Spring3MvcRest/hello/foo?a=helloworld
     * 
     * @param a 绑定Request Parameter a
     * @return JSON
     */
    @RequestMapping("/foo")
    public @ResponseBody Map<String, String> foo(String a) {
        Map<String, String> map = new HashMap<String, String>();
        map.put("a", a);
        return map;
    }

    /**
     * 根据客户的Accept返回视图
     * http://localhost:8080/Spring3MvcRest/hello/foo?a=helloworld
     * 
     * @param a 绑定Request Parameter a
     * @return JSON
     */
    @RequestMapping(value="/foo", headers="Accept=text/*")
    public String foo1(String a) {
        return "world";
    }
}
