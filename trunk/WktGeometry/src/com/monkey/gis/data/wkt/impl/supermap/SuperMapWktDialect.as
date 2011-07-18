package com.monkey.gis.data.wkt.impl.supermap {
    import com.monkey.gis.data.wkt.WktDialect;
    import com.monkey.gis.data.wkt.WktFormat;

    public class SuperMapWktDialect implements WktDialect {
        public function getGeometryJson(wkt:String):String {
            var coordinates:Array = WktFormat.read(wkt);
            return null;
        }

        public function toWkt(geometryJson:String):String {
            return null;
        }
    }
}
