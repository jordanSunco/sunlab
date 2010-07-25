/*
 * Copyright
 */

package test;

import java.io.IOException;
import java.net.MalformedURLException;

import com.gargoylesoftware.htmlunit.BrowserVersion;
import com.gargoylesoftware.htmlunit.FailingHttpStatusCodeException;
import com.gargoylesoftware.htmlunit.Page;
import com.gargoylesoftware.htmlunit.WebClient;
import com.gargoylesoftware.htmlunit.html.HtmlElement;
import com.gargoylesoftware.htmlunit.html.HtmlPage;
import com.gargoylesoftware.htmlunit.html.HtmlSubmitInput;

/**
 * 通过HtmlUnit模拟浏览器测试Web程序
 * http://htmlunit.sourceforge.net/
 * 
 * @author Sun
 * @version HtmlUnitTest.java 2010-7-25 上午08:51:01
 */
public class HtmlUnitTest {
    public static void main(String[] args)
            throws FailingHttpStatusCodeException, MalformedURLException,
            IOException {
        // 创建浏览器，可以选择IE、FF等等
        WebClient client = new WebClient(BrowserVersion.FIREFOX_3);

        // 获取某网站页面
        HtmlPage page = client.getPage("http://www.baidu.com");

        // 获取某页面元素
        HtmlElement elmt = page.getElementById("kw");

        // 此例以文本框为例，先点击，再输入，完全跟真浏览器行为一致
        elmt.click();
        elmt.type("百度");

        // 获取按钮
        HtmlSubmitInput searchSubmit = (HtmlSubmitInput) page
                .getElementById("su");
        // 点击并获得返回结果
        Page resultPage = searchSubmit.click();

        System.out.println(resultPage.getWebResponse().getContentAsString());
    }
}
