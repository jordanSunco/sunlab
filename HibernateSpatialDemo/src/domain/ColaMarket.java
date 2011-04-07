/*
 * Copyright
 */

package domain;

import com.vividsolutions.jts.geom.Point;

/**
 * 
 * @author Sun
 * @version ColaMarket.java 2011-4-6 上午06:49:25
 */
public class ColaMarket {
    private Integer id;
    private String name;
    private Point location;

    /**
     * @return the id
     */
    public Integer getId() {
        return this.id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Integer id) {
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
     * @return the location
     */
    public Point getLocation() {
        return this.location;
    }

    /**
     * @param location the location to set
     */
    public void setLocation(Point location) {
        this.location = location;
    }
}
