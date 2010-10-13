/*
 * Copyright
 */

package domain;

/**
 * 领域模型
 * 
 * @author Sun
 * @version Domain.java 2010-9-27 下午04:15:31
 */
public class Domain {
    private int id;
    private String name;

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
}
