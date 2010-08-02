/*
 * Copyright
 */

package test.spring3.mvc.model;

import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * 测试模型
 * 
 * @author Sun
 * @version Human.java 2010-7-29 下午06:06:52
 */
@XmlRootElement
public class Human {
    private int id;
    private String name;
    private boolean male;
    private int[] ids;
    private String[] names;
    private List<String> nameList;

    private Human child;

    /**
     * @return the id
     */
    public int getId() {
        return this.id;
    }

    /**
     * @param id the id to set
     */
    public void setId(int id) {
        this.id = id;
    }

    /**
     * @return the name
     */
    public String getName() {
        return this.name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the male
     */
    public boolean isMale() {
        return this.male;
    }

    /**
     * @param male the male to set
     */
    public void setMale(boolean male) {
        this.male = male;
    }

    /**
     * @return the ids
     */
    public int[] getIds() {
        return this.ids;
    }

    /**
     * @param ids the ids to set
     */
    public void setIds(int[] ids) {
        this.ids = ids;
    }

    /**
     * @return the names
     */
    public String[] getNames() {
        return this.names;
    }

    /**
     * @param names the names to set
     */
    public void setNames(String[] names) {
        this.names = names;
    }

    /**
     * @return the nameList
     */
    public List<String> getNameList() {
        return this.nameList;
    }

    /**
     * @param nameList the nameList to set
     */
    public void setNameList(List<String> nameList) {
        this.nameList = nameList;
    }

    /**
     * @return the child
     */
    public Human getChild() {
        return this.child;
    }

    /**
     * @param child the child to set
     */
    public void setChild(Human child) {
        this.child = child;
    }
}
