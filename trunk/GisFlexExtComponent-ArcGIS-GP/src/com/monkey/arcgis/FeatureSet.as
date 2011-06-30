package com.monkey.arcgis {
    /**
     * ArcGIS中的FeatureSet
     * 
     * @author Sun
     * @see com.esri.ags.FeatureSet
     */
    public class FeatureSet {
        public var geometryType:String;
        public var spatialReference:Object;

        [ArrayElementType("com.talkweb.twgis.arcgis.Graphic")]
        public var features:Array;

        /**
         * 由于GP Task返回的FeatureSet JSON数据中有这个属性,
         * 因此通过ObjectTranslator来做转换时必须有这个public属性,
         * 否则console中报错
         * ReferenceError: Error #1056: 无法为 com.talkweb.twgis.arcgis.FeatureSet 创建属性 exceededTransferLimit。
         * 这个错误不会影响到其他属性的转换, 暂且注销掉
         */
//        public var exceededTransferLimit:Boolean;
    }
}
