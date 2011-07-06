package com.monkey.arcgis {
    import com.adobe.serialization.json.JSON;
    import com.darronschall.serialization.ObjectTranslator;
    import com.monkey.arcgis.geometry.Geometry;
    import com.monkey.arcgis.geometry.MapPoint;
    
    import org.flexunit.asserts.assertEquals;
    import org.openscales.core.feature.Feature;
    import org.openscales.core.feature.PointFeature;
    import org.openscales.geometry.Point;

    /**
     * @author Sun
     */
    public class FeatureSetUtilTest {
        [Test]
        public function testConvertToMapPointFeatureSetJson():void {
            var x:Array = [0, 1];
            var y:Array = [2, 3];

            var features:Vector.<Feature> = new Vector.<Feature>();

            var feature1:Feature = new PointFeature(new Point(x[0], y[0]),
                {label: "Point1"});
            var feature2:Feature = new PointFeature(new Point(x[1], y[1]),
                {label: "Point2"});
            features.push(feature1, feature2);

            var featureSetObject:Object = JSON.decode(
                FeatureSetUtil.convertToFeatureSetJson(features));
            var featureSet:FeatureSet = ObjectTranslator.objectToInstance(
                featureSetObject, FeatureSet);

            assertEquals(Geometry.MAPPOINT, featureSet.geometryType);

            for (var i:uint, length:uint = featureSet.features.length; i < length; i++) {
                var featureObject:Object = featureSet.features[i];

                var agsFeature:Graphic = ObjectTranslator.objectToInstance(
                    featureObject, Graphic);
                var mapPoint:MapPoint = ObjectTranslator.objectToInstance(
                    agsFeature.geometry, MapPoint);

                assertEquals(x[i], mapPoint.x);
                assertEquals(y[i], mapPoint.y);
            }
        }

        [Test]
        public function testConvertFromMapPointFeatureSet():void {
            var x:Array = [0, 1];
            var y:Array = [2, 3];

            var mapPointFeatureSetJson:String = "{\"geometryType\":\"esriGeometryPoint\",\"spatialReference\": {\"wkid\": 2431},\"features\":[{\"attributes\":{\"label\":\"Point1\"},\"geometry\":{\"y\":2,\"x\":0}},{\"attributes\":{\"label\":\"Point2\"},\"geometry\":{\"y\":3,\"x\":1}}]}";
            var featureSetObject:Object = JSON.decode(mapPointFeatureSetJson);

            var features:Vector.<Feature> = FeatureSetUtil.convertFromFeatureSet(
                featureSetObject);
            for (var i:uint, length:uint = features.length; i < length; i++) {
                var feature:PointFeature = features[i] as PointFeature;
                var point:Point = feature.geometry as Point;

                assertEquals(x[i], point.x);
                assertEquals(y[i], point.y);
                assertEquals("EPSG:2431", point.projection);
            }
        }
    }
}
