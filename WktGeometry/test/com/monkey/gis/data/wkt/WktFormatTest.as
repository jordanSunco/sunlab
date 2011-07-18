package com.monkey.gis.data.wkt {
    import org.flexunit.asserts.assertEquals;

    /**
     * @author Sun
     */
    public class WktFormatTest {
        [Test]
        public function testGetPointTypeWithUpperCaseWkt():void {
            var wkt:String = "POINT (30 10)";
            assertEquals(WktFormat.POINT, WktFormat.getGeometryType(wkt));
        }

        [Test]
        public function testGetPointTypeWithLowerCaseWkt():void {
            var wkt:String = " point (30 10)";
            assertEquals(WktFormat.POINT, WktFormat.getGeometryType(wkt));
        }

        [Test]
        public function testGetLineStringType():void {
            var wkt:String = "LINESTRING (30 10, 10 30)";
            assertEquals(WktFormat.LINE_STRING, WktFormat.getGeometryType(wkt));
        }

        [Test]
        public function testGetMultiLineStringType():void {
            var wkt:String = "MULTILINESTRING ((10 10, 20 20), (40 40, 30 30))";
            assertEquals(WktFormat.MULTI_LINE_STRING, WktFormat.getGeometryType(wkt));
        }

        [Test]
        public function testGetPolygonType():void {
            var wkt:String = "POLYGON ((30 10, 10 20, 20 40, 30 10))";
            assertEquals(WktFormat.POLYGON, WktFormat.getGeometryType(wkt));
        }

        [Test]
        public function testReadPoint():void {
            var wkt:String = "POINT (30 10)";
            assertEquals([30, 10].toString(), WktFormat.read(wkt).toString());
        }

        [Test]
        public function testReadLineString():void {
            var wkt:String = "LINESTRING (30 10, 10 30)";

            var paths:Array = [
                [[30, 10], [10, 30]]
            ];
            assertEquals(paths.length, WktFormat.read(wkt).length);
            assertEquals(paths.toString(), WktFormat.read(wkt).toString());
        }

        [Test]
        public function testReadMultiLineString():void {
            var wkt:String = "MULTILINESTRING ((10 10, 20 20), (40 40, 30 30))";

            var paths:Array = [
                [[10, 10], [20, 20]],
                [[40, 40], [30, 30]]
            ];
            assertEquals(paths.length, WktFormat.read(wkt).length);
            assertEquals(paths.toString(), WktFormat.read(wkt).toString());
        }

        [Test]
        public function testReadPolygon():void {
            var wkt:String = "POLYGON ((30 10, 10 20, 40 40, 30 10))";

            var rings:Array = [
                [[30, 10], [10, 20], [40, 40], [30, 10]]
            ];
            assertEquals(rings.length, WktFormat.read(wkt).length);
            assertEquals(rings.toString(), WktFormat.read(wkt).toString());
        }

        [Test]
        public function testReadMultiRingPolygon():void {
            var wkt:String = "POLYGON ((35 10, 10 20, 15 40, 35 10), (20 30, 35 35, 30 20, 20 30))";

            var rings:Array = [
                [[35, 10], [10, 20], [15, 40], [35, 10]],
                [[20, 30], [35, 35], [30, 20], [20, 30]]
            ];
            assertEquals(rings.length, WktFormat.read(wkt).length);
            assertEquals(rings.toString(), WktFormat.read(wkt).toString());
        }

        [Test]
        public function testWritePoint():void {
            var coordinates:Array = [30, 10];
            var wkt:String = WktFormat.write(WktFormat.POINT, coordinates);

            assertEquals("POINT (30 10)", wkt);
        }

        [Test]
        public function testWriteLineString():void {
            var coordinates:Array = [
                [[30, 10], [10, 30]]
            ];
            var wkt:String = WktFormat.write(WktFormat.LINE_STRING, coordinates);

            assertEquals("LINESTRING (30 10,10 30)", wkt);
        }

        [Test]
        public function testWriteMultiLineString():void {
            var coordinates:Array = [
                [[10, 10], [20, 20]],
                [[40, 40], [30, 30]]
            ];
            var wkt:String = WktFormat.write(WktFormat.MULTI_LINE_STRING, coordinates);

            assertEquals("MULTILINESTRING ((10 10,20 20),(40 40,30 30))",
                wkt);
        }

        [Test]
        public function testWritePolygon():void {
            var coordinates:Array = [
                [[30, 10], [10, 20], [40, 40], [30, 10]]
            ];
            var wkt:String = WktFormat.write(WktFormat.POLYGON, coordinates);

            assertEquals("POLYGON ((30 10,10 20,40 40,30 10))", wkt);
        }

        [Test]
        public function testWriteMultiRingPolygon():void {
            var coordinates:Array = [
                [[35, 10], [10, 20], [15, 40], [35, 10]],
                [[20, 30], [35, 35], [30, 20], [20, 30]]
            ];
            var wkt:String = WktFormat.write(WktFormat.POLYGON, coordinates);

            assertEquals("POLYGON ((35 10,10 20,15 40,35 10),(20 30,35 35,30 20,20 30))",
                wkt);
        }
    }
}
