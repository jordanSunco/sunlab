package com.monkey {
    import org.openscales.geometry.Geometry;

    /**
     * 互转不同GIS引擎的Geometry数据格式(JSON)与OpenScales的Geometry数据格式.
     * Geometry是一个统一的概念, 但是如同SQL方言一样, 会有名称上的区别, 因此将Geometry看作是一种方言, 在不同GIS引擎间实现这种方言的转换.
     * JSON(各GIS引擎都有不同) &lt;-&gt; Geometry(OpenScales)
     * 
     * @author Sun
     */
    public interface GeometryDialect {
        function getGeometry(geometryJson:String):Geometry;
        function toGeometryJson(geometry:Geometry):String;
    }
}
