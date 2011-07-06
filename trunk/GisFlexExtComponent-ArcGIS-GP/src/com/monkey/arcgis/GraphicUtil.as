package com.monkey.arcgis {
    import com.darronschall.serialization.ObjectTranslator;
    import com.monkey.arcgis.geometry.Geometry;
    import com.monkey.arcgis.geometry.MapPoint;
    
    import org.openscales.core.feature.Feature;
    import org.openscales.core.feature.PointFeature;
    import org.openscales.geometry.Geometry;
    import org.openscales.geometry.Point;

    /**
     * Graphic(ArcGIS) &lt;-&gt; Feature(OpenScales)
     * 
     * @author Sun
     */
    public class GraphicUtil {
        private static const PROJECTION_PREFIX:String = "EPSG";

        /**
         * Feature(OpenScales) -&gt; Graphic(ArcGIS)
         * 
         * @param feature OpenScales Feature
         * @param geometryType ArcGIS Geometry类型
         * @return ArcGIS Graphic
         */
        public static function feature2Graphic(feature:Feature,
                geometryType:String):Graphic {
            var graphic:Graphic = new Graphic();
            graphic.geometry = getGraphicGeometry(feature.geometry,
                geometryType);
            graphic.attributes = feature.attributes;

            return graphic;
        }

        public static function getSpatialReference(projection:String):SpatialReference {
            var spatialReference:SpatialReference = new SpatialReference();
            spatialReference.wkid = projection.replace(PROJECTION_PREFIX + ":", "");

            return spatialReference;
        }

        /**
         * OpenScales Geometry -&gt; ArcGIS Geometry
         * 
         * @param geometry OpenScales Geometry
         * @param geometryType ArcGIS Geometry类型
         * @return ArcGIS Geometry
         */
        private static function getGraphicGeometry(geometry:org.openscales.geometry.Geometry,
                geometryType:String):com.monkey.arcgis.geometry.Geometry {
            var graphicGeometry:com.monkey.arcgis.geometry.Geometry = null;

            switch (geometryType) {
                case com.monkey.arcgis.geometry.Geometry.MAPPOINT:
                    graphicGeometry = point2MapPoint(geometry);
                    break;
            }

            return graphicGeometry;
        }

        /**
         * Point -&gt; MapPoint
         * 
         * @param geometry OpenScales Geometry Point
         * @return ArcGIS Geometry MapPoint
         */
        private static function point2MapPoint(geometry:org.openscales.geometry.Geometry):com.monkey.arcgis.geometry.Geometry {
            var point:Point = geometry as Point;

            var mapPoint:MapPoint = new MapPoint();
            mapPoint.x = point.x;
            mapPoint.y = point.y;

            return mapPoint;
        }

        /**
         * Graphic(ArcGIS) -&gt; Feature(OpenScales) 
         * 
         * @param graphicObject ArcGIS Graphic Object(因为是从JSON中获取的数据, 因此不是强类型)
         * @param geometryType ArcGIS Geometry类型
         * @param spatialReference
         * @return OpenScales Feature
         */
        public static function graphic2Feature(graphicObject:Object,
                geometryType:String, spatialReference:SpatialReference):Feature {
            var graphic:Graphic = ObjectTranslator.objectToInstance(
                graphicObject, Graphic);

            var feature:Feature = getFeature(geometryType);
            feature.geometry = getFeatureGeometry(graphic.geometry, geometryType);
            feature.geometry.projection = getProjection(spatialReference);
            feature.attributes = graphic.attributes;

            return feature;
        }

        /**
         * 根据ArcGIS Geometry类型创建不同的Feature实例
         * 
         * @param geometryType ArcGIS Geometry类型
         * @return OpenScales Feature实例
         */
        private static function getFeature(geometryType:String):Feature {
            var feature:Feature = null;

            switch (geometryType) {
                case com.monkey.arcgis.geometry.Geometry.MAPPOINT:
                    feature = new PointFeature();
                    break;
            }

            return feature;
        }

        /**
         * ArcGIS Geometry -&gt; OpenScales Geometry
         * 
         * @param geometryObject ArcGIS Geometry Object(因为是从JSON中获取的数据, 因此不是强类型)
         * @param geometryType ArcGIS Geometry类型
         * @return OpenScales Geometry
         */
        private static function getFeatureGeometry(geometryObject:Object,
                geometryType:String):org.openscales.geometry.Geometry {
            var geometry:org.openscales.geometry.Geometry = null;

            switch (geometryType) {
                case com.monkey.arcgis.geometry.Geometry.MAPPOINT:
                    geometry = mapPoint2Point(geometryObject);
                    break;
            }

            return geometry;
        }

        private static function getProjection(spatialReference:SpatialReference):String {
            return PROJECTION_PREFIX + ":" + spatialReference.wkid;
        }

        /**
         * MapPoint -&gt; Point 
         * 
         * @param geometryObject ArcGIS Geometry MapPoint(因为是从JSON中获取的数据, 因此不是强类型)
         * @return OpenScales Geometry Point
         */
        private static function mapPoint2Point(geometryObject:Object):org.openscales.geometry.Geometry {
            var mapPoint:MapPoint = ObjectTranslator.objectToInstance(
                geometryObject, MapPoint);

            var point:Point = new Point(mapPoint.x, mapPoint.y);

            return point;
        }
    }
}
