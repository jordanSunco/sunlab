package com.monkey.gis.data.feature {
    /**
     * 通用要素类
     * 
     * @author Sun
     */
    public class Feature {
        /**
         * 使用WKT来表示几何结构
         */
        public var geometry:String;
        public var attributes:Object;

        public function Feature(geometry:String, attributes:Object) {
            this.geometry = geometry;
            this.attributes = attributes;
        }
    }
}
