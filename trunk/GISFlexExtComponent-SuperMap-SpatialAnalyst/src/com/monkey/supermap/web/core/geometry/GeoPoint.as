package com.monkey.supermap.web.core.geometry {
    /**
     * SuperMap中的GeoPoint
     * 
     * @author Sun
     * @see com.supermap.web.core.geometry.GeoPoint
     */
    public class GeoPoint extends Geometry {
        override public function get type():String {
            return Geometry.GEOPOINT;
        }
    }
}
