/*
 * Copyright
 */

package test;

import flex.messaging.FlexContext;
import flex.messaging.FlexSession;

/**
 * 
 * @author Administrator
 * @version Test.java 2010-4-10 上午11:52:23
 */
public class Test {
    public Test() {
        FlexSession flexSession = FlexContext.getFlexSession();
        
        if (flexSession.getAttribute("s") == null) {
            flexSession.setAttribute("s", "ABC");
        }
    }
    
    public String getS() {
        return (String) FlexContext.getFlexSession().getAttribute("s");
    }
    
    public void setS(String s) {
        FlexContext.getFlexSession().setAttribute("s", s);
    }
}
