package com.monkey.arcgis {
    /**
     * ArcGIS中的Graphic
     * 
     * @author Sun
     * @see com.esri.ags.Graphic
     */
    public class Graphic {
        /**
         * 其实里面放的是Geometry, 因为使用ObjectTranslator无法转化嵌套的Class, 才换成的Object马甲.
         * 如果这里设置类型为Geometry, 会出现转换错误, 导致属性值无法获取而变成null值
         */
        public var geometry:Object;
        public var attributes:Object;
    }
}
