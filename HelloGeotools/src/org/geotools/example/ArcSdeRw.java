/*
 * Copyright
 */

package org.geotools.example;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.geotools.arcsde.ArcSDEDataStoreFactory;
import org.geotools.arcsde.data.ArcSDEDataStore;
import org.geotools.arcsde.session.Command;
import org.geotools.arcsde.session.ISession;
import org.geotools.data.DataStore;
import org.geotools.data.DataStoreFinder;
import org.geotools.data.FeatureSource;
import org.geotools.data.FeatureStore;
import org.geotools.data.FileDataStoreFinder;
import org.geotools.data.Transaction;
import org.geotools.data.shapefile.ShapefileDataStore;
import org.geotools.feature.FeatureCollection;
import org.geotools.feature.FeatureIterator;
import org.geotools.filter.text.cql2.CQL;
import org.geotools.filter.text.cql2.CQLException;
import org.opengis.feature.Property;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.filter.Filter;

import com.esri.sde.sdk.client.SeConnection;
import com.esri.sde.sdk.client.SeException;
import com.esri.sde.sdk.client.SeTable;

/**
 * 测试读写ArcSDE
 * 
 * @author Sun
 * @version ArcSdeRw.java 2011-7-22 14:32:55
 * @see org.geotools.arcsde.data.TestData
 */
public class ArcSdeRw {
    private static String CREATE_FEATURE_TYPE_HINT_PARAM_NAME = "configuration.keyword";

    public static void main(String[] args) throws IOException, CQLException {
        String connectionPropertiesFile = "arcsde.properties";
        // SDE表名必须大写
        String sdeTableName = "SDE.AD";
        String cql = "ID LIKE 'G0853040015'";

        String shpFile = "D:/Softs/uDigEclipse/shp/restaurant.shp";
        String shpFileSdeTableName = "SDE.RESTAURANT";
        String shpSdeCql = "NAME_PY = 'DaZhong JiuDian'";

        ArcSdeRw arcSdeRw = new ArcSdeRw();
        FeatureSource<SimpleFeatureType, SimpleFeature> fs = arcSdeRw.readFeatureSource(
                connectionPropertiesFile, sdeTableName);
        arcSdeRw.printFeature(fs, cql);
        fs.getDataStore().dispose();

        arcSdeRw.importShp2Sde(shpFile, connectionPropertiesFile);
        FeatureSource<SimpleFeatureType, SimpleFeature> shpSdeFs = arcSdeRw.readFeatureSource(
                connectionPropertiesFile, shpFileSdeTableName);
        arcSdeRw.printFeature(shpSdeFs, shpSdeCql);

        ISession session = ((ArcSDEDataStore) shpSdeFs.getDataStore())
                .getSession(Transaction.AUTO_COMMIT);
        deleteTable(session, shpFileSdeTableName);

        shpSdeFs.getDataStore().dispose();
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

    /**
     * 将shp文件中的空间数据导入到SDE空间数据库.
     * 1. 获取shp的DataStore
     * 2. 获取shp中的FeatureSource, 即所有的空间数据
     * 3. 获取FeatureSource的FeatureType(Schema), 即空间数据的要素类型, 对于shp文件FeatureType的名称就是shp的文件名(不带后缀)
     * 4. 连接SDE数据库, 获得SDE的DataStore
     * 5. 在SDE中创建于shp相同的FeatureType, 即创建一张空间数据表
     * 6. 获取新创建的FeatureType(表名称)的FeatureStore, 通过它来导入shp中的空间数据(FeatureCollection)
     * 
     * @throws IOException
     */
    private void importShp2Sde(String shpFile, String connectionPropertiesFile)
            throws IOException {
        ShapefileDataStore shpFileDs = (ShapefileDataStore) FileDataStoreFinder
                .getDataStore(new File(shpFile));
        // 通过ShapefileDataStore.setStringCharset来解决中文乱码问题
        shpFileDs.setStringCharset(Charset.forName("GB2312"));

        FeatureSource<SimpleFeatureType, SimpleFeature> fs = shpFileDs
                .getFeatureSource();
        SimpleFeatureType featureType = fs.getSchema();

        Properties properties = getProperties(connectionPropertiesFile);
        ArcSDEDataStore sdeDs = (ArcSDEDataStore) DataStoreFinder
                .getDataStore(properties);

        Map<String, String> hints = new HashMap<String, String>();
        hints.put(CREATE_FEATURE_TYPE_HINT_PARAM_NAME,
                properties.get(CREATE_FEATURE_TYPE_HINT_PARAM_NAME).toString());
        // 在SDE中创建Schema必须使用ArcSDEDataStore, 并带入configuration.keyword参数
        sdeDs.createSchema(featureType, hints);

        // 获取SDE中根据shp文件创建的空间数据表
        // restaurant.shp -> SDE.RESTAURANT
        String tableName = getTableName(featureType.getTypeName());
        FeatureStore<SimpleFeatureType, SimpleFeature> featureStore = (FeatureStore<SimpleFeatureType, SimpleFeature>) sdeDs
                .getFeatureSource(tableName);
        featureStore.addFeatures(fs.getFeatures());

        sdeDs.dispose();
    }

    private static void deleteTable(ISession session, final String tableName) {
        final Command<Void> deleteCmd = new Command<Void>() {
            @Override
            public Void execute(ISession session, SeConnection connection)
                    throws SeException, IOException {
                SeTable table = new SeTable(connection, tableName);
                try {
                    table.delete();
                } catch (SeException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
                return null;
            }
        };

        try {
            session.issue(deleteCmd);
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        session.dispose();
    }

    /**
     * 获取SDE中的空间数据表名称.
     * 例如
     * 
     * @param featureTypeName
     * @return 大写的SDE.featureTypeName
     */
    private String getTableName(String featureTypeName) {
        // TODO SDE的表模式是死的?
        String sdeSchemaName = "SDE";

        StringBuffer sb = new StringBuffer();
        sb.append(sdeSchemaName);
        sb.append(".");
        sb.append(featureTypeName);
        return sb.toString().toUpperCase();
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
