/*
 * Copyright
 */

package org.geotools.example;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.geotools.arcsde.ArcSDEDataStoreFactory;
import org.geotools.data.DataStore;
import org.geotools.data.DataStoreFinder;
import org.geotools.data.FeatureSource;
import org.geotools.feature.FeatureCollection;
import org.geotools.feature.FeatureIterator;
import org.geotools.filter.text.cql2.CQL;
import org.geotools.filter.text.cql2.CQLException;
import org.opengis.feature.Property;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.filter.Filter;

/**
 * 测试读写ArcSDE
 * 
 * @author Sun
 * @version ArcSdeRw.java 2011-7-22 14:32:55
 */
public class ArcSdeRw {
    public static void main(String[] args) throws IOException, CQLException {
        String connectionPropertiesFile = "arcsde.properties";
        // SDE表名必须大写
        String sdeTableName = "SDE.AD";
        String cql = "ID LIKE 'G0853040015'";

        ArcSdeRw arcSdeRw = new ArcSdeRw();
        FeatureSource<SimpleFeatureType, SimpleFeature> fs = arcSdeRw
                .readFeatureSource(connectionPropertiesFile, sdeTableName);
        arcSdeRw.printFeature(fs, cql);
        fs.getDataStore().dispose();
    }

    private FeatureSource<SimpleFeatureType, SimpleFeature> readFeatureSource(
            String connectionPropertiesFile, String sdeTableName)
            throws IOException {
        if (ArcSDEDataStoreFactory.getSdeClientVersion() == ArcSDEDataStoreFactory.JSDE_VERSION_DUMMY) {
            throw new RuntimeException("Don't run the test with the dummy jar."
                    + "Make sure the real ArcSDE jars are on your classpath.");
        }

        Properties properties = getProperties(connectionPropertiesFile);
        DataStore dataStore = DataStoreFinder.getDataStore(properties);
        // String[] featureTypes = dataStore.getTypeNames();

        return dataStore.getFeatureSource(sdeTableName);
    }

    private Properties getProperties(String propertiesFile) throws IOException {
        Properties properties = new Properties();
        InputStream in = getClass().getResourceAsStream(propertiesFile);
        properties.load(in);
        in.close();

        return properties;
    }

    private void printFeature(
            FeatureSource<SimpleFeatureType, SimpleFeature> fs, String cql)
            throws CQLException, IOException {
        Filter filter = CQL.toFilter(cql);

        FeatureCollection<SimpleFeatureType, SimpleFeature> fc = fs
                .getFeatures(filter);

        FeatureIterator<SimpleFeature> fi = fc.features();
        while (fi.hasNext()) {
            SimpleFeature sf = fi.next();
            for (Property property : sf.getProperties()) {
                System.out.println(property.getName() + ": "
                        + property.getValue());
            }
            System.out.println();
        }
    }
}
