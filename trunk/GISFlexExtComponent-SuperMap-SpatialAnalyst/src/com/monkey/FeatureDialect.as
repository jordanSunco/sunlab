package com.monkey {
    import org.openscales.core.feature.Feature;

    /**
     * 互转不同GIS引擎的Feature数据格式(JSON)与OpenScales的Geometry数据格式.
     * Feature是一个统一的概念, 但是如同SQL方言一样, 会有名称上的区别, 因此将Feature看作是一种方言, 在不同GIS引擎间实现这种方言的转换.
     * JSON(各GIS引擎都有不同) &lt;-&gt; Feature(OpenScales)
     * 
     * @author Sun
     */
    public interface FeatureDialect {
        /**
         * Feature JSON(GIS引擎特有格式) -&gt; Feature(OpenScales)
         */
        function getFeatureFromJson(featureJson:String):Feature;

        /**
         * Feature Object(GIS引擎特有的Feature对象) -&gt; Feature(OpenScales)
         */
        function getFeatureFromObject(featureObject:Object):Feature;

        /**
         * Feature(OpenScales) -&gt; Feature Object(GIS引擎特有的Feature对象)
         */
        function toFeature(feature:Feature):Object;

        /**
         * Feature(OpenScales) -&gt; Feature JSON(GIS引擎特有格式)
         */
        function toFeatureJson(feature:Feature):String;
    }
}
