/*
 * Copyright
 */

package test;

import java.util.ArrayList;
import java.util.List;

/**
 * 
 * @author Administrator
 * @version TestListObject.java 2010-4-10 下午02:03:39
 */
public class TestListObject {
    private List<Model> l;
    
    public TestListObject() {
        this.l = new ArrayList<Model>();
        
        this.l.add(new Model(1, "a"));
        this.l.add(new Model(2, "b"));
        this.l.add(new Model(3, "c"));
        this.l.add(new Model(4, "d"));
    }
    
    public List<Model> getl() {
        return this.l;
    }
}
