package com.monkey.gis.data.wkt {
    /**
     * WKT &lt;-&gt; Geometry JSON(各GIS引擎特定的Geometry JSON数据结构)
     * 
     * @author Sun
     */
    public interface WktDialect {
        function getGeometryJson(wkt:String):String
        function toWkt(geometryJson:String):String
    }
}
