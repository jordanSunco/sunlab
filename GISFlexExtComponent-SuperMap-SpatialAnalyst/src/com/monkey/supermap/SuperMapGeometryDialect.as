package com.monkey.supermap {
    import com.adobe.serialization.json.JSON;
    import com.darronschall.serialization.ObjectTranslator;
    import com.monkey.GeometryDialect;
    import com.monkey.supermap.web.core.Point2D;
    import com.monkey.supermap.web.core.geometry.Geometry;
    
    import org.openscales.geometry.Geometry;
    import org.openscales.geometry.LineString;
    import org.openscales.geometry.LinearRing;
    import org.openscales.geometry.Point;
    import org.openscales.geometry.Polygon;

    /**
     * SuperMap Geometry &lt;-&gt; OpenScales Geometry
     * 
     * @author Sun
     */
    public class SuperMapGeometryDialect implements GeometryDialect {
        public function getGeometryFromJson(geometryJson:String):org.openscales.geometry.Geometry {
            return getGeometryFromObject(JSON.decode(geometryJson));
        }

        public function getGeometryFromObject(geometryObject:Object):org.openscales.geometry.Geometry {
            var superMapGeometry:com.monkey.supermap.web.core.geometry.Geometry = getSuperMapGeometry(geometryObject);
            var geometry:org.openscales.geometry.Geometry;

            switch (superMapGeometry.type) {
                case com.monkey.supermap.web.core.geometry.Geometry.GEOPOINT:
                    geometry = getPoint(superMapGeometry);
                    break;
                case com.monkey.supermap.web.core.geometry.Geometry.GEOLINE:
                    geometry = getLineString(superMapGeometry);
                    break;
                case com.monkey.supermap.web.core.geometry.Geometry.GEOREGION:
                    geometry = getPolygon(superMapGeometry);
                    break;
                default:
                    trace("default");
            }

            return geometry;
        }

        private function getSuperMapGeometry(geometryObject:Object):com.monkey.supermap.web.core.geometry.Geometry {
            return ObjectTranslator.objectToInstance(geometryObject,
                com.monkey.supermap.web.core.geometry.Geometry);
        }

        private function getPoint(superMapGeometry:com.monkey.supermap.web.core.geometry.Geometry):Point {
            var point2D:Point2D = ObjectTranslator.objectToInstance(
                superMapGeometry.points[0], Point2D);
            return new Point(point2D.x, point2D.y);
        }

        private function getLineString(superMapGeometry:com.monkey.supermap.web.core.geometry.Geometry):LineString {
            return new LineString(getVertices(superMapGeometry));
        }

        private function getPolygon(superMapGeometry:com.monkey.supermap.web.core.geometry.Geometry):Polygon {
            var ring:LinearRing = new LinearRing(getVertices(superMapGeometry));
            var rings:Vector.<org.openscales.geometry.Geometry> = new Vector.<org.openscales.geometry.Geometry>();
            rings.push(ring);

            return new Polygon(rings);
        }

        private function getVertices(superMapGeometry:com.monkey.supermap.web.core.geometry.Geometry):Vector.<Number> {
            var vertices:Vector.<Number> = new Vector.<Number>();

            for each (var point2DObject:Object in superMapGeometry.points) {
                var point2D:Point2D = ObjectTranslator.objectToInstance(
                    point2DObject, Point2D);
                vertices.push(point2D.x, point2D.y);
            }

            return vertices;
        }

        public function toGeometry(geometry:org.openscales.geometry.Geometry):Object {
            var superMapGeometry:com.monkey.supermap.web.core.geometry.Geometry = new com.monkey.supermap.web.core.geometry.Geometry();
            superMapGeometry.type = getGeometryType(geometry);
            superMapGeometry.points = getPoint2Ds(geometry);

            return superMapGeometry;
        }

        private function getGeometryType(geometry:org.openscales.geometry.Geometry):String {
            var type:String = "";

            if (geometry is Point) {
                type = com.monkey.supermap.web.core.geometry.Geometry.GEOPOINT;
            } else if (geometry is LineString) {
                type = com.monkey.supermap.web.core.geometry.Geometry.GEOLINE;
            } else if (geometry is Polygon) {
                type = com.monkey.supermap.web.core.geometry.Geometry.GEOREGION;
            }

            return type;
        }

        private function getPoint2Ds(geometry:org.openscales.geometry.Geometry):Array {
            var vertices:Array = [];

            for each (var point:Point in geometry.toVertices()) {
                var point2D:Point2D = new Point2D();
                point2D.x = point.x;
                point2D.y = point.y;
                vertices.push(point2D);
            }

            return vertices;
        }

        public function toGeometryJson(geometry:org.openscales.geometry.Geometry):String {
            return JSON.encode(toGeometry(geometry));
        }
    }
}
