/*
 * Copyright
 */

package model;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * 
 * @author Sun
 * @version Model.java 2010-8-19 上午10:48:21
 */
@XmlRootElement
public class Model {
    private String id;

    /**
     * @return the id
     */
    public String getId() {
        return this.id;
    }

    /**
     * @param id the id to set
     */
    public void setId(String id) {
        this.id = id;
    }
}
