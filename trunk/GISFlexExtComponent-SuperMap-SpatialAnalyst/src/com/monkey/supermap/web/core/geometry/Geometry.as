package com.monkey.supermap.web.core.geometry {
    /**
     * SuperMap中的Geometry基类
     * 
     * @author Sun
     * @see com.supermap.web.core.geometry.Geometry
     * @see com.supermap.web.iServerJava2.ServerGeometry
     * @see http://support.supermap.com.cn/DataWarehouse/WebDocHelp/6.0/iSever6R/mergedProjects/SuperMapiServerRESTAPI/clientBuildREST/Geometry_Build.htm 几何对象的 JSON 格式构建
     */
    public class Geometry {
        public static const GEOPOINT:String = "POINT";
        public static const GEOLINE:String = "LINE";
        public static const GEOREGION:String = "REGION";

        public var id:String;
        public var style:String;
        public var type:String;
        public var parts:Array;
        public var points:Array;
    }
}
