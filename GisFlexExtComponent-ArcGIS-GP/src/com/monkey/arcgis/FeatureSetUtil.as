package com.monkey.arcgis {
    import com.adobe.serialization.json.JSON;
    import com.darronschall.serialization.ObjectTranslator;
    import com.monkey.arcgis.geometry.Geometry;
    
    import org.openscales.core.feature.Feature;
    import org.openscales.geometry.Geometry;
    import org.openscales.geometry.LineString;
    import org.openscales.geometry.MultiLineString;
    import org.openscales.geometry.MultiPoint;
    import org.openscales.geometry.MultiPolygon;
    import org.openscales.geometry.Point;
    import org.openscales.geometry.Polygon;

    /**
     * 将OpenScales的Feature数据格式与ArcGIS的Graphic数据格式进行互转.
     * 数据格式参考REST API.
     * 
     * 转换过程:
     * 1. 将ArcGIS Flex API中涉及FeatureSet的类都移植过来. 例如FeatureSet, Graphic, Geometry, Geometry子类等, 这样通过JSON做序列化时, 直接就可以生成按照ArcGIS规格的字符串了
     * 2. Vector.&lt;Feature&gt; -&gt; FeatureSetJson字符串, 用于使用Feature做为GP的输出参数
     *     1) 获取Feature的类型 -&gt; FeatureSet.geometryType
     *     2) Feature(OpenScales)  -&gt; Graphic(ArcGIS)
     *     3) Geometry(OpenScales) -&gt; Geometry(ArcGIS)
     *     4) Feature.attributes -&gt; Graphic.attributes
     *     5) JSON.encode(FeatureSet)
     * 3. ags FeatureSetJson对象 -&gt; Vector.&lt;Feature&gt;, 用于获取GP的输出, 以转为标准格式接收
     *     1) 根据FeatureSet.geometryType来做转换
     *     2) Graphic(ArcGIS) -&gt; Feature(OpenScales)
     *     2) Geometry(ArcGIS) -&gt; Geometry(OpenScales)
     *     3) Graphic.attributes -&gt; Feature.attributes
     * 
     * @author Sun
     * @see http://resources.esri.com/help/9.3/ArcGISServer/apis/rest/geometry.html
     */
    public class FeatureSetUtil {
        public static function convertToFeatureSetJson(features:Vector.<Feature>):String {
            var aGeometry:org.openscales.geometry.Geometry = ((features[0]) as Feature).geometry;
            var geometryType:String = getGeometryType(aGeometry);

            var featureSet:FeatureSet = new FeatureSet();
            featureSet.geometryType = geometryType;
            // TODO spatialReference
//            arcgisFeatureSet.spatialReference = null;
            featureSet.features = getGraphics(features, geometryType);

            return JSON.encode(featureSet);
        }

        /**
         * 获取OpenScales Geometry的类型与ArcGIS Gemetry类型的对应关系
         * 
         * @param geometry
         * @return ArcGIS Gemetry的类型
         */
        private static function getGeometryType(geometry:org.openscales.geometry.Geometry):String {
            var geometryType:String = "";

            if (geometry is Point) {
                geometryType = com.monkey.arcgis.geometry.Geometry.MAPPOINT;
            } else if (geometry is MultiPoint) {
                geometryType = com.monkey.arcgis.geometry.Geometry.MULTIPOINT;
            } else if (geometry is LineString || geometry is MultiLineString) {
                geometryType = com.monkey.arcgis.geometry.Geometry.POLYLINE;
            } else if (geometry is Polygon || geometry is MultiPolygon) {
                geometryType = com.monkey.arcgis.geometry.Geometry.POLYGON;
            }

            return geometryType;
        }

        /**
         * 将所有Feature(OpenScales)转成Graphic(ArcGIS)
         * 
         * @param features OpenScales Feature向量
         * @param geometryType ArcGIS Geometry类型
         * @return ArcGIS Graphic数组
         */
        private static function getGraphics(features:Vector.<Feature>,
                geometryType:String):Array {
            var graphics:Array = [];

            for each (var feature:Feature in features) {
                graphics.push(GraphicUtil.feature2Graphic(feature, geometryType));
            }

            return graphics;
        }

        public static function convertFromFeatureSet(featureSetObject:Object):Vector.<Feature> {
            var featureSet:FeatureSet = ObjectTranslator.objectToInstance(
                featureSetObject, FeatureSet);
            var spatialReference:SpatialReference = ObjectTranslator.objectToInstance(
                featureSet.spatialReference, SpatialReference);

            return getFeatures(featureSet.features, featureSet.geometryType,
                spatialReference);
        }

        /**
         * 将所有Graphic(ArcGIS)转成Feature(OpenScales)
         * 
         * @param graphics ArcGIS Graphic数组
         * @param geometryType ArcGIS Geometry类型
         * @param spatialReference
         * @return OpenScales Feature向量
         */
        private static function getFeatures(graphics:Array,
                geometryType:String, spatialReference:SpatialReference):Vector.<Feature> {
            var features:Vector.<Feature> = new Vector.<Feature>();

            for each (var graphicObject:Object in graphics) {
                features.push(GraphicUtil.graphic2Feature(graphicObject,
                    geometryType, spatialReference));
            }

            return features;
        }
    }
}
