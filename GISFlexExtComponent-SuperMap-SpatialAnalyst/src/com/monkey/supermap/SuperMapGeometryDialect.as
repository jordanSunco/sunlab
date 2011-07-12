package com.monkey.supermap {
    import com.adobe.serialization.json.JSON;
    import com.darronschall.serialization.ObjectTranslator;
    import com.monkey.GeometryDialect;
    import com.monkey.supermap.web.core.Point2D;
    import com.monkey.supermap.web.core.geometry.Geometry;
    
    import org.openscales.geometry.Geometry;
    import org.openscales.geometry.LinearRing;
    import org.openscales.geometry.Polygon;

    /**
     * SuperMap Geometry &lt;-&gt; OpenScales Geometry
     * 
     * @author Sun
     */
    public class SuperMapGeometryDialect implements GeometryDialect {
        public function getGeometry(geometryJson:String):org.openscales.geometry.Geometry {
            var superMapGeometry:com.monkey.supermap.web.core.geometry.Geometry = getSuperMapGeometry(geometryJson);
            return _getGeometry(superMapGeometry);
        }

        private function getSuperMapGeometry(geometryJson:String):com.monkey.supermap.web.core.geometry.Geometry {
            return ObjectTranslator.objectToInstance(JSON.decode(geometryJson),
                com.monkey.supermap.web.core.geometry.Geometry);
        }

        private function _getGeometry(superMapGeometry:com.monkey.supermap.web.core.geometry.Geometry):org.openscales.geometry.Geometry {
            var geometry:org.openscales.geometry.Geometry;

            switch (superMapGeometry.type) {
                case com.monkey.supermap.web.core.geometry.Geometry.GEOPOINT:
                    break;
                case com.monkey.supermap.web.core.geometry.Geometry.GEOLINE:
                    break;
                case com.monkey.supermap.web.core.geometry.Geometry.GEOREGION:
                    geometry = getPolygon(superMapGeometry); 
                    break;
                default:
                    trace("default");
            }

            return geometry;
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
    }
}
