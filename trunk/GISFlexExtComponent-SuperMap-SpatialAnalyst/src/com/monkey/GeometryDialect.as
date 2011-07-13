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
        /**
         * Geometry JSON(GIS引擎特有格式) -&gt; Geometry(OpenScales)
         */
        function getGeometryFromJson(geometryJson:String):Geometry;

        /**
         * Geometry Object(GIS引擎特有的Geometry对象) -&gt; Geometry(OpenScales)
         */
        function getGeometryFromObject(geometryObject:Object):Geometry;

        /**
         * Geometry(OpenScales) -&gt; Geometry Object(GIS引擎特有的Geometry对象)
         */
        function toGeometry(geometry:Geometry):Object;

        /**
         * Geometry(OpenScales) -&gt; Geometry JSON(GIS引擎特有格式)
         */
        function toGeometryJson(geometry:Geometry):String;
    }
}
