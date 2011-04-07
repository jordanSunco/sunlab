/*
 * Copyright 
 */

package dao;

import java.util.List;

import com.vividsolutions.jts.geom.Geometry;

import domain.ColaMarket;

/**
 * 
 * @author Sun
 * @version ColaMarketDao.java 2011-4-6 上午09:14:22
 */
public interface ColaMarketDao {
    void add(ColaMarket colaMarket);
    ColaMarket find(Integer id);
    List<ColaMarket> spatialQueryWithin(Geometry geometry);
    List<ColaMarket> spatialQueryWithinHql(Geometry geometry);
}
