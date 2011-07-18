package com.monkey.gis.data.feature {
    /**
     * Feature &lt;-&gt; Feature JSON(各GIS引擎特定的Feature JSON数据结构)
     * 
     * @author Sun
     */
    public interface FeatureDialect {
        function getFeatureJson(feature:Feature):String
        function toFeature(geometryJson:String):Feature
    }
}
