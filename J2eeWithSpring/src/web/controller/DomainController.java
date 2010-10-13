/*
 * Copyright
 */

package web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import service.DomainService;

/**
 * Spring MVC Control
 * 
 * @author Sun
 * @version DomainController.java 2010-7-26 下午11:13:12
 */
@Controller
public class DomainController {
    @Autowired
    private DomainService domainService;

    /**
     * 请求对应的处理方法
     * 
     * @param id 自动绑定request parameter参数
     * @param model 返回到view的model
     */
    @RequestMapping("/domain/list")
    public void list(int id, Model model) {
        model.addAttribute("domain", this.domainService.getDomain(id));
    }
}
