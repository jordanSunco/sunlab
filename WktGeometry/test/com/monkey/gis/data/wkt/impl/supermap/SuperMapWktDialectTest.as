package com.monkey.gis.data.wkt.impl.supermap {
    import com.adobe.serialization.json.JSON;
    import com.darronschall.serialization.ObjectTranslator;
    import com.monkey.gis.data.wkt.WktDialect;
    import com.monkey.gis.data.wkt.impl.supermap.geometry.Geometry;
    
    import org.flexunit.asserts.assertEquals;

    /**
     * @author Sun
     */
    public class SuperMapWktDialectTest {
        private var wktDialect:WktDialect;

        [Before]
        public function setUp():void {
            this.wktDialect = new SuperMapWktDialect();
        }

        [Test]
        public function testGetPointJson():void {
            var wkt:String = "POINT (30 10)";
            var geometryJson:String = this.wktDialect.getGeometryJson(wkt);

            var geometry:Geometry = ObjectTranslator.objectToInstance(
                JSON.decode(geometryJson), Geometry);
            assertEquals(1, geometry.parts[0]);
            assertEquals([30, 10].toString(), getCoordinates(geometry.points));
        }

        [Test]
        public function testGetLineJson():void {
            var wkt:String = "LINESTRING (30 10, 10 30)";
            var geometryJson:String = this.wktDialect.getGeometryJson(wkt);

            var geometry:Geometry = ObjectTranslator.objectToInstance(
                JSON.decode(geometryJson), Geometry);
            assertEquals(2, geometry.parts[0]);
            assertEquals([30, 10, 10, 30].toString(),
                getCoordinates(geometry.points));
        }

        [Test]
        public function testGetRegionJson():void {
            var wkt:String = "POLYGON ((30 10, 10 20, 20 40, 30 10))";
            var geometryJson:String = this.wktDialect.getGeometryJson(wkt);

            var geometry:Geometry = ObjectTranslator.objectToInstance(
                JSON.decode(geometryJson), Geometry);
            assertEquals(3, geometry.parts[0]);
            assertEquals([30, 10, 10, 20, 20, 40, 30, 10].toString(),
                getCoordinates(geometry.points));
        }

        private function getCoordinates(points:Array):Array {
            var coordinates:Array = [];
            for each (var point2dObject:Object in points) {
                var point2d:Point2D = ObjectTranslator.objectToInstance(
                    point2dObject, Point2D);
                coordinates.push(point2d.x, point2d.y);
            }
            return coordinates;
        }
    }
}
