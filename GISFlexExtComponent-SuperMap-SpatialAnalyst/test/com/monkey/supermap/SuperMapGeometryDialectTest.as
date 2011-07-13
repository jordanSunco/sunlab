package com.monkey.supermap {
    import com.monkey.GeometryDialect;
    
    import org.flexunit.asserts.assertEquals;
    import org.openscales.geometry.Geometry;
    import org.openscales.geometry.LineString;
    import org.openscales.geometry.LinearRing;
    import org.openscales.geometry.Point;
    import org.openscales.geometry.Polygon;

    /**
     * @author Sun
     */
    public class SuperMapGeometryDialectTest {
        private var geometryDialect:GeometryDialect;

        [Before]
        public function setUp():void {
            this.geometryDialect = new SuperMapGeometryDialect();
        }

        [Test]
        public function testGetPoint():void {
            var superMapPointJson:String = '{"id": 1,"style": null,"type": "POINT","parts": [1],"points": [{"x": 25.27,"y": 54.68}]}';

            var point:Point = this.geometryDialect.getGeometryFromJson(superMapPointJson) as Point;
            assertEquals("25.27,54.68", points2Coordinates(point.toVertices()));
        }

        [Test]
        public function testGetLineString():void {
            var superMapLineJson:String = '{"id": 1,"style": null,"type": "LINE","parts": [4],"points": [{"x": 96.37,"y": 399.73},{"x": 127.61,"y": 290.41},{"x": 397.38,"y": 362.81},{"x": 357.05,"y": 279.04}]}';

            var lineString:LineString = this.geometryDialect.getGeometryFromJson(superMapLineJson) as LineString;
            assertEquals("96.37,399.73,127.61,290.41,397.38,362.81,357.05,279.04",
                points2Coordinates(lineString.toVertices()));
        }

        [Test]
        public function testGetPolygon():void {
            var superMapPolygonJson:String = '{"id": 1,"style": null,"type": "REGION","parts": [4],"points": [{"x": -12.91,"y": 407.37},{"x": -2.91,"y": 248.49},{"x": 250.22,"y": 305.78},{"x": 185.27,"y": 413.36},{"x": -12.91,"y": 407.37}]}';

            var polygon:Polygon = this.geometryDialect.getGeometryFromJson(superMapPolygonJson) as Polygon;
            assertEquals("-12.91,407.37,-2.91,248.49,250.22,305.78,185.27,413.36,-12.91,407.37",
                points2Coordinates(polygon.toVertices()));
        }

        [Test]
        public function testToPointJson():void {
            var geometry:Point = new Point(30, 10);
            var geometryJson:String = this.geometryDialect.toGeometryJson(geometry);

            var point:Point = this.geometryDialect.getGeometryFromJson(geometryJson) as Point;
            assertEquals(geometry.x, point.x);
            assertEquals(geometry.y, point.y);
        }

        [Test]
        public function testToLineJson():void {
            var vertices:Vector.<Number> = new Vector.<Number>();
            vertices.push(35, 15, 15, 35, 45, 45);
            var geometryJson:String = this.geometryDialect.toGeometryJson(
                new LineString(vertices));

            var lineString:LineString = this.geometryDialect.getGeometryFromJson(geometryJson) as LineString;
            assertEquals(vertices.toString(),
                points2Coordinates(lineString.toVertices()));
        }

        [Test]
        public function testToRegionJson():void {
            var vertices:Vector.<Number> = new Vector.<Number>();
            vertices.push(65, 45, 45, 55, 55, 75, 75, 75, 65, 45);
            var ring:LinearRing = new LinearRing(vertices);

            var rings:Vector.<Geometry> = new Vector.<Geometry>();
            rings.push(ring);
            var geometry:Geometry = new Polygon(rings);
            var geometryJson:String = this.geometryDialect.toGeometryJson(geometry);

            var polygon:Polygon = this.geometryDialect.getGeometryFromJson(geometryJson) as Polygon;
            assertEquals(vertices.toString(),
                points2Coordinates(polygon.toVertices()));
        }

        private function points2Coordinates(vertices:Vector.<Point>):Array {
            var coordinates:Array = [];
            for each (var point:Point in vertices) {
                coordinates.push(point.x, point.y);
            }
            return coordinates;
        }
    }
}
