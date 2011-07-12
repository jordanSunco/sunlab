package com.monkey.supermap {
    import com.monkey.GeometryDialect;
    
    import org.flexunit.asserts.assertEquals;
    import org.openscales.geometry.Point;
    import org.openscales.geometry.Polygon;

    /**
     * @author Sun
     */
    public class SuperMapGeometryDialectTest {
        private var geometryDialect:GeometryDialect;

        [Before]
        public function setUp():void {
            geometryDialect = new SuperMapGeometryDialect();
        }

        [Test]
        public function testGetPolygon():void {
            var superMapPolygonJson:String = '{"id": 1,"style": null,"type": "REGION","parts": [4],"points": [{"x": -12.91,"y": 407.37},{"x": -2.91,"y": 248.49},{"x": 250.22,"y": 305.78},{"x": 185.27,"y": 413.36},{"x": -12.91,"y": 407.37}]}';
            var polygon:Polygon = geometryDialect.getGeometry(superMapPolygonJson) as Polygon;

            var longLat:Array = [];
            for each (var point:Point in polygon.toVertices()) {
                longLat.push(point.x, point.y);
            }

            assertEquals("-12.91,407.37,-2.91,248.49,250.22,305.78,185.27,413.36,-12.91,407.37",
                longLat.toString());
        }

        [Test]
        public function testToPointJson():void {
            var point:Point = new Point(112, 34);
            var json:String = geometryDialect.toGeometryJson(point);
            trace(json);
        }
    }
}
