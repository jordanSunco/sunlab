package com.talkweb.maps.graphic.symbol {
    import com.esri.ags.geometry.Geometry;
    import com.esri.ags.symbol.SimpleFillSymbol;
    import com.esri.ags.symbol.SimpleLineSymbol;
    import com.esri.ags.symbol.SimpleMarkerSymbol;
    import com.esri.ags.symbol.Symbol;
    
    /**
     * 通用样式类
     */
    public class SymbolUtil {
        /**
         * 高亮点样式
         * 
         * TODO 改用图片来标识点标注?
         */
        public static const HIGH_LIGHT_MARKER_SYMBOL:Symbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_TRIANGLE, 30, 0x336600, 1, 0, 0, 0, new SimpleLineSymbol(SimpleLineSymbol.STYLE_DOT, 0xffff66, 1, 6));
        
        /**
         * 高亮线样式
         */
        public static const HIGH_LIGHT_LINE_SYMBOL:Symbol = new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 0x5a6cce, 0.7, 3);
        
        /**
         * 高亮面样式
         */
        public static const HIGH_LIGHT_FILL_SYMBOL:Symbol = new SimpleFillSymbol(SimpleFillSymbol.STYLE_SOLID, 0xaccaa1, 0.6, SymbolUtil.HIGH_LIGHT_LINE_SYMBOL as SimpleLineSymbol);
        
        /**
         * 默认鼠标放在点上的样式
         * 
         * TODO 改用图片来标识点标注?
         */
        public static const ROLL_OVER_MARKER_SYMBOL:Symbol = new SimpleMarkerSymbol(SimpleMarkerSymbol.STYLE_TRIANGLE, 30, 0x336600, 1, 0, 0, 0, new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 0xffff66, 1, 6));
        
        /**
         * 默认鼠标放在线上的样式
         */
        public static const ROLL_OVER_LINE_SYMBOL:Symbol = new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 0xd65476, 0.7, 3);
        
        /**
         * 默认鼠标放在面上的样式
         */
        public static const ROLL_OVER_FILL_SYMBOL:Symbol = new SimpleFillSymbol(SimpleFillSymbol.STYLE_SOLID, 0xaca8ed, 0.6, SymbolUtil.ROLL_OVER_LINE_SYMBOL as SimpleLineSymbol);
        
        /**
         * 获取默认的高亮样式
         * 
         * @param geometryType 地图要素类型
         * 
         * @see com.esri.ags.geometry.Geometry
         * 
         * TODO 和获取鼠标经过样式的方法98%一样, 代码重复 -- DRY! 怎么改?
         */
        public static function getHighLightSymbol(geometryType:String):Symbol {
            var _defaultSymbol:Symbol;
            
            switch(geometryType) {
                case Geometry.MULTIPOINT:
                    // fall-through
                case Geometry.MAPPOINT:
                    _defaultSymbol = SymbolUtil.HIGH_LIGHT_MARKER_SYMBOL;
                    break;
                case Geometry.POLYLINE:
                    _defaultSymbol = SymbolUtil.HIGH_LIGHT_LINE_SYMBOL;
                    break;
                case Geometry.EXTENT:
                    // fall-through
                case Geometry.POLYGON:
                    _defaultSymbol = SymbolUtil.HIGH_LIGHT_FILL_SYMBOL;
                    break;
                default:
                    _defaultSymbol = SymbolUtil.HIGH_LIGHT_LINE_SYMBOL;
            }
            
            return _defaultSymbol;
        }
        
        /**
         * 获取默认鼠标经过的样式
         * 
         * @param geometryType 地图要素类型
         * 
         * @see com.esri.ags.geometry.Geometry
         */
        public static function getRollOverSymbol(geometryType:String):Symbol {
            var _rollOverSymbol:Symbol;

            switch(geometryType) {
                case Geometry.MULTIPOINT:
                    // fall-through
                case Geometry.MAPPOINT:
                    _rollOverSymbol = SymbolUtil.ROLL_OVER_MARKER_SYMBOL;
                    break;
                case Geometry.POLYLINE:
                    _rollOverSymbol = SymbolUtil.ROLL_OVER_LINE_SYMBOL;
                    break;
                case Geometry.EXTENT:
                    // fall-through
                case Geometry.POLYGON:
                    _rollOverSymbol = SymbolUtil.ROLL_OVER_FILL_SYMBOL;
                    break;
                default:
                    _rollOverSymbol = SymbolUtil.ROLL_OVER_FILL_SYMBOL;
            }
            
            return _rollOverSymbol;
        }
    }
}