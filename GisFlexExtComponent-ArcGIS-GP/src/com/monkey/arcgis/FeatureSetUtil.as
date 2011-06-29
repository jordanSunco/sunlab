package com.monkey.arcgis {
    import com.adobe.serialization.json.JSON;
    import com.darronschall.serialization.ObjectTranslator;
    import com.monkey.arcgis.geometry.Geometry;
    import com.monkey.arcgis.geometry.MapPoint;
    
    import org.openscales.core.feature.Feature;
    import org.openscales.core.feature.PointFeature;
    import org.openscales.geometry.Point;

    /**
     * 将OpenScales的Feature数据格式与ArcGIS的Graphic数据格式进行互转.
     * 数据格式参考REST API.
     * 
     * 转换过程:
     * 1. 将ArcGIS Flex API中涉及FeatureSet的类都移植过来. 例如FeatureSet, Graphic, Geometry, Geometry子类等, 这样通过JSON做序列化时, 直接就可以生成按照ArcGIS规格的字符串了
     * 2. Vector.<Feature> -> FeatureSetJson字符串, 用于使用Feature做为GP的输出参数
     *     1) 获取Feature的类型 -> FeatureSet.geometryType
     *     2) Feature(OpenScales)  -> Graphic(ArcGIS)
     *     3) Geometry(OpenScales) -> Geometry(ArcGIS)
     *     4) Feature.attributes -> Graphic.attributes
     *     5) JSON.encode(FeatureSet)
     * 3. ags FeatureSetJson对象 -> Vector.<Feature>, 用于获取GP的输出, 以转为标准格式接收
     *     1) 根据FeatureSet.geometryType来做转换
     *     2) Graphic(ArcGIS) -> Feature(OpenScales)
     *     2) Geometry(ArcGIS) -> Geometry(OpenScales)
     *     3) Graphic.attributes -> Feature.attributes
     * 
     * @author Sun
     * @see http://resources.esri.com/help/9.3/ArcGISServer/apis/rest/geometry.html
     */
    public class FeatureSetUtil {
        public static function convertToFeatureSetJson(features:Vector.<Feature>):String {
            var geometryType:String = getGeometryType(features);

            var featureSet:FeatureSet = new FeatureSet();
            featureSet.geometryType = geometryType;
            // TODO spatialReference
//            arcgisFeatureSet.spatialReference = null;
            featureSet.features = getGraphics(features, geometryType);

            return JSON.encode(featureSet);
        }

        /**
         * TODO 未完整实现
         */
        private static function getGeometryType(features:Vector.<Feature>):String {
            if (features[0] as PointFeature) {
                return Geometry.MAPPOINT;
            }

            return null;
        }

        /**
         * Feature(OpenScales) -> Graphic(ArcGIS)
         */
        private static function getGraphics(features:Vector.<Feature>,
                geometryType:String):Array {
            var graphics:Array = [];

            switch (geometryType) {
                case Geometry.MAPPOINT:
                    populateMapPoint(features, graphics);
                    break;
            }

            return graphics;
        }

        /**
         * TODO 重构
         */
        private static function populateMapPoint(features:Vector.<Feature>,
                graphics:Array):void {
            for each (var feature:Feature in features) {
                var graphic:Graphic = new Graphic();

                var geometry:Point = feature.geometry as Point;
                var mapPoint:MapPoint = new MapPoint();
                mapPoint.x = geometry.x;
                mapPoint.y = geometry.y;

                graphic.geometry = mapPoint;
                graphic.attributes = feature.attributes;

                graphics.push(graphic);
            }
        }

        /**
         * TODO 未实现
         */
        public static function convertFromFeatureSet(featureSetObject:Object):Vector.<Feature> {
            var featureSet:FeatureSet = ObjectTranslator.objectToInstance(featureSetObject, FeatureSet);
            return getFeatures(featureSet);
        }

        /**
         * Graphic(ArcGIS) -> Feature(OpenScales) 
         */
        private static function getFeatures(featureSet:FeatureSet):Vector.<Feature> {
            var features:Vector.<Feature> = new Vector.<Feature>();

            switch (featureSet.geometryType) {
                case Geometry.MAPPOINT:
                    populatePointFeature(featureSet, features);
                    break;
            }

            return features;
        }

        /**
         * TODO 重构
         */
        private static function populatePointFeature(featureSet:FeatureSet,
                features:Vector.<Feature>):void {
            for each (var featureObject:Object in featureSet.features) {
                var graphic:Graphic = ObjectTranslator.objectToInstance(
                    featureObject, Graphic);
                var mapPoint:MapPoint = ObjectTranslator.objectToInstance(
                    graphic.geometry, MapPoint);

                var feature:Feature = new PointFeature();
                var geometry:Point = new Point(mapPoint.x, mapPoint.y);
                feature.geometry = geometry;
                feature.attributes = graphic.attributes;

                features.push(feature);
            }
        }
    }
}
