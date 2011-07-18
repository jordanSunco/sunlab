package com.monkey.gis.data.wkt.impl.supermap {
    import com.adobe.serialization.json.JSON;
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
            geometry.init(getType(wktType), getPoints(wktType, coordinates));

            return JSON.encode(geometry);
        }

        private function getType(wktType:String):String {
            var type:String = "";

            switch (wktType) {
                case WktFormat.POINT:
                    type = Geometry.GEOPOINT;
                    break;
                case WktFormat.LINE_STRING:
                    type = Geometry.GEOLINE;
                    break;
                case WktFormat.POLYGON:
                    type = Geometry.GEOREGION;
                    break;
                default:
                    trace("default");
            }

            return type;
        }

        private function getPoints(wktType:String, coordinates:Array):Array {
            var point2ds:Array = [];

            // 将多维数组打平成一维数组([x1, y1, x2, y2...])
            var xyList:Array = coordinates.toString().split(",");
            for (var i:int = 0, length:int = xyList.length; i < length; i+=2) {
                var x:Number = xyList[i];
                var y:Number = xyList[i + 1];

                var point2d:Point2D = new Point2D();
                point2d.x = x;
                point2d.y = y;

                point2ds.push(point2d);
            }

            return point2ds;
        }

        public function toWkt(geometryJson:String):String {
            return null;
        }
    }
}
