package com.monkey.arcgis {
    /**
     * ArcGIS中的FeatureSet
     * 
     * @author Sun
     * @see com.esri.ags.FeatureSet
     */
    public class FeatureSet {
        public var geometryType:String;

        [ArrayElementType("com.talkweb.twgis.arcgis.Graphic")]
        public var features:Array;
    }
}
