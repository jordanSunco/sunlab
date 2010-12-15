package maps.controls {
    /**
     * 基于ArcGIS实现的类似Flash地图效果, 需要这个类来配置每一层的约束条件.
     * 
     * @author Sun
     */
    public class ArcGisFlashMapLevelConfig {
        /**
         * Flash地图层级的名称, 一般就是省, 市, 县这样的层次.
         */
        private var _name:String;

        /**
         * Flash地图层级对应的ArcGIS地图层级, 有可能会跳级.
         * 例如: Flash省级在地图的第0级, 市级可能到了第2级, 县级可能在第4级这样的.
         */
        private var _mapLevel:uint;

        /**
         * 从这个图层中查询出需要高亮的区域
         */
        private var _highlightLayerUrl:String;

        /**
         * 查询要高亮的图层区域时所需的where语句, 通过?(问号)来占位.
         * 例如: A = '?'(注意在这里通过单引号来区分值是否是字符串类型)
         */
        private var _highlightLayerWhereClause:String;

        /**
         * 为了补全下一层要查询的高亮图层的where语句(带入真实的约束值替换掉问号),
         * 需要取出这些字段的值, 匹配上那些问号(字段的索引位置和问号位置需保持一致).
         * 
         * 例如: 当前在省这一层, 那么我查询出市, 高亮这个市的所有县(下一层),
         * 这个市就是县的约束条件(where语句). 这里我们假设县的约束条件是CITY_ID = ?,
         * 所以我需要取出市的CITY_ID字段值, 补全这个约束条件.
         */
        private var _nextLevelLayerWhereFields:Array;

        private var _outFields:Array;

        public function ArcGisFlashMapLevelConfig(name:String, mapLevel:uint,
                highlightLayerUrl:String, highlightLayerWhereClause:String,
                nextLevelLayerWhereFields:Array, outFields:Array) {
            this._name = name;
            this._mapLevel = mapLevel;
            this._highlightLayerUrl = highlightLayerUrl;
            this._highlightLayerWhereClause = highlightLayerWhereClause;
            this._nextLevelLayerWhereFields = nextLevelLayerWhereFields;
            this._outFields = outFields;
        }

        public function get name():String {
            return this._name;
        }

        public function get mapLevel():uint {
            return this._mapLevel;
        }

        public function get highlightLayerUrl():String {
            return this._highlightLayerUrl;
        }

        public function get highlightLayerWhereClause():String {
            return this._highlightLayerWhereClause;
        }

        public function get nextLevelLayerWhereFields():Array {
            return this._nextLevelLayerWhereFields;
        }

        public function get outFields():Array {
            return this._outFields;
        }
    }
}
