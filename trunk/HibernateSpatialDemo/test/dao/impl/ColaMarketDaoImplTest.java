/*
 * Copyright
 */

package dao.impl;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernatespatial.criterion.SpatialRestrictions;
import org.junit.Assert;
import org.junit.Test;

import util.HibernateUtil;

import com.vividsolutions.jts.geom.Geometry;
import com.vividsolutions.jts.geom.Point;
import com.vividsolutions.jts.io.ParseException;
import com.vividsolutions.jts.io.WKTReader;

import dao.ColaMarketDao;
import domain.ColaMarket;

/**
 * 
 * @author Sun
 * @version ColaMarketDaoImplTest.java 2011-4-6 上午09:22:13
 */
public class ColaMarketDaoImplTest {
    ColaMarketDao dao = new ColaMarketDaoImpl();
    Integer colaMarketId = Integer.valueOf(1);
    String colaMarketName = "cola_a";
    String wktPoint = "POINT (12 14)";
    String wktPolygon = "POLYGON ((0 0,20 0,20 20,0 20,0 0))";

    @Test
    public void testAdd() {
        ColaMarket colaMarket = new ColaMarket();
        colaMarket.setName(this.colaMarketName);
        colaMarket.setLocation((Point) getGeometry(this.wktPoint));

        this.dao.add(colaMarket);
        validateAdd();
        testSpatialQueryWithin();
        testSpatialQueryWithinHql();
    }

    private void validateAdd() {
        ColaMarket addedColaMarket = this.dao.find(this.colaMarketId);
        Assert.assertEquals(this.colaMarketId, addedColaMarket.getId());
        Assert.assertEquals(this.colaMarketName, addedColaMarket.getName());
        Assert.assertEquals(this.wktPoint, addedColaMarket.getLocation()
                .toString());
    }

    private void testSpatialQueryWithin() {
        List<ColaMarket> result = this.dao
                .spatialQueryWithinHql(getGeometry(this.wktPolygon));
        ColaMarket colaMarket = result.get(0);

        Assert.assertEquals(this.colaMarketId, colaMarket.getId());
        Assert.assertEquals(this.colaMarketName, colaMarket.getName());
        Assert.assertEquals(this.wktPoint, colaMarket.getLocation().toString());
    }

    private void testSpatialQueryWithinHql() {
        List<ColaMarket> result = this.dao
                .spatialQueryWithin(getGeometry(this.wktPolygon));
        ColaMarket colaMarket = result.get(0);

        Assert.assertEquals(this.colaMarketId, colaMarket.getId());
        Assert.assertEquals(this.colaMarketName, colaMarket.getName());
        Assert.assertEquals(this.wktPoint, colaMarket.getLocation().toString());
    }

    private Geometry getGeometry(String wkt) {
        // interpret the WKT string to a point
        WKTReader wktReader = new WKTReader();
        Geometry geom = null;
        try {
            geom = wktReader.read(wkt);
        } catch (ParseException e) {
            throw new RuntimeException("Not a WKT string:" + wkt);
        }

        return geom;
    }
}
