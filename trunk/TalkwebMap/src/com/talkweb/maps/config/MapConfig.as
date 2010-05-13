package com.talkweb.maps.config {
    /**
     * 地图配置
     */
    public class MapConfig {
        /**
         * URL分隔符
         */
//        public static const URL_PATH_SEPARATOR:String = "/";
        
        /**
         * 服务器地址
         */
        public static const SERVER_URL:String = "http://192.168.200.58:8399/";
        
        /**
         * 基础图层地图服务地址
         */
        public static const BASE_MAP_SERVICE_URL:String = SERVER_URL + "arcgis/rest/services/jichu/MapServer/";
        
        /**
         * 业务图层地图服务地址
         */
        public static const BUSINESS_MAP_SERVICE_URL:String = SERVER_URL + "arcgis/rest/services/qudao/MapServer/";
        
        /**
         * GeometryService
         * 做测距测面等地理信息查询
         */
        public static const GEOMETRY_SERVICE_URL:String = SERVER_URL + "arcgis/rest/services/Geometry/GeometryServer/";
        
        /**
         * 路径分析服务
         */
        public static const ROUTE_SERVICE_URL:String = SERVER_URL + "arcgis/rest/services/hnNAroad/NAServer/Route/";
        
        /**
         * GP服务
         */
        public static const GP_SERVICE_URL:String = "http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Specialty/ESRI_Currents_World/GPServer/MessageInABottle/";
        
        /**
         * 图层索引
         */
        public static const CITY_REGION_LAYER_INDEX:int = 26;
        
        /**
         * 图层查询返回所有字段
         * 
         * To return all fields, specify the wildcard "*" as the value of this parameter.
         * In this case, the query results include all the field values.
         * Note that the wildcard also implicitly implies returnGeometry=true 
         * and setting returnGeometry to false will have no effect.
         * 
         * @link http://resources.esri.com/help/9.3/arcgisserver/apis/flex/apiref/com/esri/ags/tasks/Query.html#outFields 
         */
        public static const RETURN_ALL_FIELDS:Array = ["*"];
        
        /**
         * 测量默认用的WIKI空间索引
         */
        public static const DEFAULT_MEASURE_WIKI:Number = 32618;
    }
}