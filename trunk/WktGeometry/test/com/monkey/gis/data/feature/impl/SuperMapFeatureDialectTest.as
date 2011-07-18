package com.monkey.gis.data.feature.impl {
    import com.adobe.serialization.json.JSON;
    import com.darronschall.serialization.ObjectTranslator;
    import com.monkey.gis.data.feature.Feature;
    import com.monkey.gis.data.feature.FeatureDialect;
    import com.monkey.gis.data.feature.impl.supermap.Feature;
    import com.monkey.gis.data.feature.impl.supermap.SuperMapFeatureDialect;
    import com.monkey.gis.data.wkt.WktDialect;
    import com.monkey.gis.data.wkt.impl.supermap.SuperMapWktDialect;
    
    import org.flexunit.asserts.assertEquals;

    /**
     * @author Sun
     */
    public class SuperMapFeatureDialectTest {
        private var wktDialect:WktDialect;
        private var featureDialect:FeatureDialect;

        [Before]
        public function setUp():void {
            this.wktDialect = new SuperMapWktDialect();
            this.featureDialect = new SuperMapFeatureDialect(this.wktDialect);
        }

        [Test]
        public function testGetFeatureJson():void {
            var feature:com.monkey.gis.data.feature.Feature =
                new com.monkey.gis.data.feature.Feature("POINT (30 10)", {a: 1, b: "b"});
            var featureJson:String = this.featureDialect.getFeatureJson(feature);

            var superMapFeature:com.monkey.gis.data.feature.impl.supermap.Feature =
                ObjectTranslator.objectToInstance(JSON.decode(featureJson), com.monkey.gis.data.feature.impl.supermap.Feature);
            var aIndex:int = superMapFeature.fieldNames.indexOf("a");
            assertEquals(1, superMapFeature.fieldValues[aIndex]);
            var bIndex:int = superMapFeature.fieldNames.indexOf("b");
            assertEquals("b", superMapFeature.fieldValues[bIndex]);

            var wkt:String = this.wktDialect.toWkt(JSON.encode(superMapFeature.geometry));
            assertEquals("POINT (30 10)", wkt);
        }

        [Test]
        public function testToFeature():void {
            var featureJson:String = '{"fieldNames":["a","b"],"fieldValues":[1,"b"],"geometry":{"type":"POINT","id":null,"parts":[1],"points":[{"y":10,"x":30}],"style":null},"ID":null}';
            var feature:com.monkey.gis.data.feature.Feature = this.featureDialect.toFeature(featureJson);

            assertEquals(1, feature.attributes["a"]);
            assertEquals("b", feature.attributes["b"]);
            assertEquals("POINT (30 10)", feature.geometry);
        }
    }
}