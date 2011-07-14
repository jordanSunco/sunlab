package com.monkey.supermap {
    import com.monkey.FeatureDialect;
    import com.monkey.utils.GeometryUtil;
    
    import mx.utils.ObjectUtil;
    
    import org.flexunit.asserts.assertEquals;
    import org.openscales.core.feature.Feature;
    import org.openscales.core.feature.PointFeature;
    import org.openscales.core.style.Style;
    import org.openscales.geometry.Point;

    /**
     * @author Sun
     */
    public class SuperMapFeatureDialectTest {
        private var featureDialect:FeatureDialect;

        [Before]
        public function setUp():void {
            this.featureDialect = new SuperMapFeatureDialect(new SuperMapGeometryDialect());
        }

        [Test]
        public function testGetLineFeature():void {
            var superMapLineFeatureJson:String = '{"ID": 1,"fieldNames": ["fieldName1", "fieldName2"],"fieldValues": ["fieldValue1", "fieldValue2"],"geometry": {"id": 1,"parts": [2],"points": [{"x": 18.74,"y": 58.01}, {"x": 19.09,"y": 58.55}],"style": null,"type": "LINE"}}';

            var feature:Feature = this.featureDialect.getFeatureFromJson(superMapLineFeatureJson);
            assertEquals("18.74,58.01,19.09,58.55", GeometryUtil.getCoordinates(feature.geometry));
            assertEquals("fieldValue1", feature.attributes["fieldName1"]);
            assertEquals("fieldValue2", feature.attributes["fieldName2"]);
            assertEquals(0, ObjectUtil.compare(Style.getDefaultLineStyle(), feature.style));
        }

        [Test]
        public function testToPointFeatureJson():void {
            var pointFeature:Feature = new PointFeature(new Point(30, 10),
                {a: 1, b: "b"});
            var featureJson:String = this.featureDialect.toFeatureJson(pointFeature);

            var feature:Feature = this.featureDialect.getFeatureFromJson(featureJson);
            assertEquals(GeometryUtil.getCoordinates(pointFeature.geometry).toString(),
                GeometryUtil.getCoordinates(feature.geometry).toString());
            assertEquals(0, ObjectUtil.compare(pointFeature.attributes, feature.attributes));
        }
    }
}