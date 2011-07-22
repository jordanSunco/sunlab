/*
 * Copyright
 */

package org.geotools.example;

import java.io.IOException;
import java.io.Serializable;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import org.geotools.data.FeatureSource;
import org.geotools.data.FileDataStore;
import org.geotools.data.shapefile.ShapefileDataStoreFactory;
import org.geotools.feature.FeatureCollection;
import org.geotools.feature.FeatureIterator;
import org.opengis.feature.Property;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.filter.Filter;

import com.gi.engine.util.gt.FilterUtil;

/**
 * 读取shp文件并通过CQL来过滤数据
 * 
 * @author Sun
 * @version HelloGeotools.java 2011-7-22 上午09:32:34
 */
public class HelloGeotools {
    public static void main(String[] args) throws IOException {
        String shpFileUrl = "file:/D:/Softs/uDigEclipse/shp/restaurant.shp";
        String dbfCharset = "GB2312";
        String cql = "Name LIKE '%酒店%'";

        HelloGeotools helloGeotools = new HelloGeotools();
        FeatureSource<SimpleFeatureType, SimpleFeature> fs = helloGeotools
                .readShpFeatureSource(shpFileUrl, dbfCharset);
        helloGeotools.printFeature(fs, cql);
    }

    private FeatureSource<SimpleFeatureType, SimpleFeature> readShpFeatureSource(
            String shpFileUrl, String dbfCharset) throws IOException {
        Map<String, Serializable> params = new HashMap<String, Serializable>();
        params.put(ShapefileDataStoreFactory.URLP.key, new URL(shpFileUrl));
        // 设置正确的数据文件编码方式, 否则读取中文数据可能出现乱码问题
        params.put(ShapefileDataStoreFactory.DBFCHARSET.key, dbfCharset);

        ShapefileDataStoreFactory dataStoreFactory = new ShapefileDataStoreFactory();
        FileDataStore dataStore = dataStoreFactory.createDataStore(params);

        return dataStore.getFeatureSource();
    }

    private void printFeature(
            FeatureSource<SimpleFeatureType, SimpleFeature> fs, String cql)
            throws IOException {
        // GeoTools CQL不能解析中文条件(Lexical error)
        // Filter filter = CQL.toFilter("Name LIKE '%中文%'");
        // GIServer中解决了这个问题, 可以解析中文条件
        Filter filter = FilterUtil.whereclauseToFilter(cql);

        FeatureCollection<SimpleFeatureType, SimpleFeature> fc = fs
                .getFeatures(filter);

        FeatureIterator<SimpleFeature> fi = fc.features();
        while (fi.hasNext()) {
            SimpleFeature sf = fi.next();
            for (Property property : sf.getProperties()) {
                System.out.println(property.getName() + ": " + property.getValue());
            }
            System.out.println();
        }
    }
}
