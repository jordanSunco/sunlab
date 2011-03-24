/*
 * Copyright
 */

package wps.impl;

import wps.Geoprocessing;

import com.vividsolutions.jts.geom.Geometry;
import com.vividsolutions.jts.io.ParseException;
import com.vividsolutions.jts.io.WKTReader;

/**
 * 
 * @author Sun
 * @version GeoprocessingImpl.java 2011-3-24 上午09:04:48
 */
public class GeoprocessingImpl implements Geoprocessing {
    public String union(String wtk1, String wtk2) {
        String unionWtk = "";
        WKTReader wktReader = new WKTReader();

        try {
            Geometry input1 = wktReader.read(wtk1);
            Geometry input2 = wktReader.read(wtk2);

            unionWtk = input1.union(input2).toString();
        } catch (ParseException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        return unionWtk;
    }
}
