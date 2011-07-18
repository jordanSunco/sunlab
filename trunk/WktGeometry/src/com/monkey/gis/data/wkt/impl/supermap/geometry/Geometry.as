package com.monkey.gis.data.wkt.impl.supermap.geometry {
    /**
     * SuperMap中的Geometry基类
     * 
     * @author Sun
     * @see com.supermap.web.iServerJava2.ServerGeometry
     * @see http://support.supermap.com.cn/DataWarehouse/WebDocHelp/6.0/iSever6R/mergedProjects/SuperMapiServerRESTAPI/clientBuildREST/Geometry_Build.htm 几何对象的 JSON 格式构建
     */
    public class Geometry {
        public static const GEOPOINT:String = "POINT";
        public static const GEOLINE:String = "LINE";
        public static const GEOREGION:String = "REGION";

        public var id:String;
        public var style:String;
        private var _type:String;
        private var _parts:Array;
        private var _points:Array;

        public function init(type:String, points:Array):void {
            this._type = type;
            this._points = points;
            this._parts = getParts();
        }

        private function getParts():Array {
            var parts:Array;

            switch (this.type) {
                case Geometry.GEOPOINT:
                    // fall-through 点和线一样, 都是算包含多少个点
                case Geometry.GEOLINE:
                    parts = [this.points.length];
                    break;
                case Geometry.GEOREGION:
                    // 由于面的起点和终点始终是一个点, 因此少算一个点
                    parts = [this.points.length - 1];
                    break;
                default:
                    trace("default");
            }

            return parts;
        }

        public function get type():String {
            return this._type;
        }

        public function set type(value:String):void {
            this._type = value;
        }

        public function get points():Array {
            return this._points;
        }

        public function set points(value:Array):void {
            this._points = value;
        }

        public function get parts():Array {
            return this._parts;
        }

        public function set parts(value:Array):void {
            this._parts = value;
        }
    }
}
