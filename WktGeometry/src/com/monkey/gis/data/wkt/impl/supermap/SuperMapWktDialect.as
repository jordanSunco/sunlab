package com.monkey.gis.data.wkt.impl.supermap {
    import com.adobe.serialization.json.JSON;
    import com.darronschall.serialization.ObjectTranslator;
    import com.monkey.gis.data.wkt.WktDialect;
    import com.monkey.gis.data.wkt.WktFormat;
    import com.monkey.gis.data.wkt.impl.supermap.geometry.Geometry;

    /**
     * WKT &lt;-&gt; SuperMap Geometry JSON
     * 
     * @author Sun
     */
    public class SuperMapWktDialect implements WktDialect {
        public function getGeometryJson(wkt:String):String {
            var wktType:String = WktFormat.getGeometryType(wkt);
            var coordinates:Array = WktFormat.read(wkt);

            var geometry:Geometry = new Geometry();
            geometry.init(getGeometryType(wktType), getPoints(coordinates));
            return JSON.encode(geometry);
        }

        private function getGeometryType(wktType:String):String {
            var geometryType:String = "";

            switch (wktType) {
                case WktFormat.POINT:
                    geometryType = Geometry.GEOPOINT;
                    break;
                case WktFormat.LINE_STRING:
                    geometryType = Geometry.GEOLINE;
                    break;
                case WktFormat.POLYGON:
                    geometryType = Geometry.GEOREGION;
                    break;
                default:
                    trace("default");
            }

            return geometryType;
        }

        private function getPoints(coordinates:Array):Array {
            var point2dList:Array = [];

            // 将多维数组打平成一维数组([x1, y1, x2, y2...])
            var xyList:Array = coordinates.join().split(WktFormat.COMMA);
            for (var i:int = 0, length:int = xyList.length; i < length; i+=2) {
                var x:Number = xyList[i];
                var y:Number = xyList[i + 1];

                var point2d:Point2D = new Point2D();
                point2d.x = x;
                point2d.y = y;

                point2dList.push(point2d);
            }

            return point2dList;
        }

        public function toWkt(geometryJson:String):String {
            var geometry:Geometry = ObjectTranslator.objectToInstance(
                JSON.decode(geometryJson), Geometry);

            return WktFormat.write(getWktType(geometry.type),
                getCoordinates(geometry));
        }

        private function getWktType(geometryType:String):String {
            var wktType:String = "";

            switch (geometryType) {
                case Geometry.GEOPOINT:
                    wktType = WktFormat.POINT;
                    break;
                case Geometry.GEOLINE:
                    wktType = WktFormat.LINE_STRING;
                    break;
                case Geometry.GEOREGION:
                    wktType = WktFormat.POLYGON;
                    break;
                default:
                    trace("default");
            }

            return wktType;
        }

        private function getCoordinates(geometry:Geometry):Array {
            var coordinates:Array;

            switch (geometry.type) {
                case Geometry.GEOPOINT:
                    coordinates = getPointCoordinates(geometry.points);
                    break;
                case Geometry.GEOLINE:
                    // fall-through 线和面的数据结构一样, 采用相同方式来处理
                case Geometry.GEOREGION:
                    coordinates = getLineCoordinates(geometry.points);
                    break;
                default:
                    trace("default");
            }

            return coordinates;
        }

        private function getPointCoordinates(points:Array):Array {
            var coordinates:Array = [];
            for each (var point2dObject:Object in points) {
                var point2d:Point2D = ObjectTranslator.objectToInstance(
                    point2dObject, Point2D);
                coordinates.push(point2d.x, point2d.y);
            }
            return coordinates;
        }

        private function getLineCoordinates(points:Array):Array {
            var path:Array = [];
            for each (var point2dObject:Object in points) {
                var point2d:Point2D = ObjectTranslator.objectToInstance(
                    point2dObject, Point2D);
                path.push([point2d.x, point2d.y]);
            }
            return [path];
        }
    }
}
