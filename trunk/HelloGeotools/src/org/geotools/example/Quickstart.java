/*
 * Copyright
 */

package org.geotools.example;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;

import org.geotools.data.FeatureSource;
import org.geotools.data.FileDataStore;
import org.geotools.data.FileDataStoreFinder;
import org.geotools.data.shapefile.ShapefileDataStore;
import org.geotools.map.DefaultMapContext;
import org.geotools.map.MapContext;
import org.geotools.swing.JMapFrame;
import org.geotools.swing.data.JFileDataStoreChooser;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;

/**
 * Geotools网站上Quickstart中的示例, read and display a shapefile
 * 
 * @author Sun
 * @version Quickstart.java 2011-7-21 下午09:05:35
 * @see <a href="http://docs.geotools.org/stable/userguide/quickstart.html">Quickstart</a>
 */
public class Quickstart {
    public static void main(String[] args) throws IOException {
        // display a data store file chooser dialog for shapefiles
        File file = JFileDataStoreChooser.showOpenFile("shp", null);

        FileDataStore store = FileDataStoreFinder.getDataStore(file);
        ShapefileDataStore _store = (ShapefileDataStore) store;
        // 通过ShapefileDataStore.setStringCharset来解决中文乱码问题
        _store.setStringCharset(Charset.forName("GB2312"));

        FeatureSource<SimpleFeatureType, SimpleFeature> featureSource = _store
                .getFeatureSource();

        // Create a map context and add our shapefile to it
        MapContext map = new DefaultMapContext();
        map.setTitle("Quickstart");
        map.addLayer(featureSource, null);

        // Now display the map
        JMapFrame.showMap(map);
    }
}
