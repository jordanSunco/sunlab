package com.monkey.supermap.web.core.geometry {
    /**
     * SuperMap中的Geometry基类
     * 
     * @author Sun
     * @see com.supermap.web.core.geometry.Geometry
     */
    public class Geometry {
        public static const GEOPOINT:String = "POINT";
        public static const GEOLINE:String = "LINE";
        public static const GEOREGION:String = "REGION";

        public function get type():String {
            return "";
        }
    }
}
