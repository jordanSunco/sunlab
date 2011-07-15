package com.monkey.gis.data.wkt {
    public interface WktDialect {
        function getGeometry(wkt:String):Object
        function toWkt(geometry:Object):String
    }
}
