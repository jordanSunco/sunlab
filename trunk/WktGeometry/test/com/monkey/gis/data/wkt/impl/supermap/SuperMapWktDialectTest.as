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

        [Test]
        public function testToPointWkt():void {
            var json:String = '{"type":"POINT","parts":[1],"points":[{"x":25,"y":54}],"style":null,"id":1}';
            var wkt:String = this.wktDialect.toWkt(json);

            assertEquals("POINT (25 54)", wkt);
        }

        [Test]
        public function testToLineWkt():void {
            var json:String = '{"type":"LINE","parts":[2],"points":[{"x":96,"y":399},{"x":127,"y":290}],"style":null,"id":1}';
            var wkt:String = this.wktDialect.toWkt(json);

            assertEquals("LINESTRING (96 399,127 290)", wkt);
        }

        [Test]
        public function testToRegionWkt():void {
            var json:String = '{"type":"REGION","parts":[3],"points":[{"x":-12,"y":407},{"x":-2,"y":248},{"x":250,"y":305},{"x":-12,"y":407}],"style":null,"id":1}';
            var wkt:String = this.wktDialect.toWkt(json);

            assertEquals("POLYGON ((-12 407,-2 248,250 305,-12 407))", wkt);
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
