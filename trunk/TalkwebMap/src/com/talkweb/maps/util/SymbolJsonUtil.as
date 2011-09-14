package com.talkweb.maps.util {
    import com.esri.ags.symbol.SimpleFillSymbol;
    import com.esri.ags.symbol.SimpleLineSymbol;
    import com.esri.ags.symbol.SimpleMarkerSymbol;
    import com.esri.ags.symbol.Symbol;
    import com.esri.ags.symbol.TextSymbol;
    import com.esri.serialization.json.JSON;

    /**
     * 参考 JSON.encode(graphic:Graphic)
     * 
     * arcgis 本身自带的JSON.encode会将Symbol信息过滤掉, 目前采用很爱吃的方法
     * 1. Symbol JSON编码(Symbol -> String)
     *     将Symbol类转化为一个普通的Object
     *     确定Symbol子类类型, 添加type属性标识
     *     复制样式属性到Object
     *     通过JSON.encode得到JSON字符串
     * 2. Symbol JSON解码(String -> Symbol)
     *     通过JSON.decode得到Object
     *     通过Object.type属性判断出是哪一种Symbol子类类型, 并实例化一个特定的Symbol
     *     复制Object属性到Symbol
     * 
     * @link{http://forums.arcgis.com/threads/3857-JSON.encode%28graphic-Graphic%29}
     */
    public class SymbolJsonUtil {
        /**
         * Symbol Type
         * arcgis flex api 1.3 Symbol 本身没有类型属性
         * 参考REST API
         * 
         * @link{http://servicesbeta.esri.com/ArcGIS/SDK/REST/symbol.html}
         */
        public static const TEXT_SYMBOL_TYPE:String = "esriTS";
        public static const SIMPLE_MARKER_SYMBOL_TYPE:String = "esriSMS";
        public static const SIMPLE_LINE_SYMBOL_TYPE:String = "esriSLS";
        public static const SIMPLE_FILL_SYMBOL_TYPE:String = "esriSFS";

        /*
        private function rgbToInt(r:int, g:int, b:int):int {
            return r << 16 | g << 8 | b << 0;
        }

        private function encodeColor(color:uint, alpha:Number = 1):Array {
            var colorArray:Array = new Array();
            var alphaRestValue:uint = alpha * 255;
            var hexRep:String = color.toString(16);

            if (hexRep.length == 6) {
                colorArray.push(new uint("0x" + hexRep.substring(0, 2)));
                colorArray.push(new uint("0x" + hexRep.substring(2, 4)));
                colorArray.push(new uint("0x" + hexRep.substring(4, 6)));
            } else if (hexRep.length == 4) {
                colorArray.push(new uint(0));
                colorArray.push(new uint("0x" + hexRep.substring(0, 2)));
                colorArray.push(new uint("0x" + hexRep.substring(2, 4)));
            } else if (hexRep.length == 2) {
                colorArray.push(new uint(0));
                colorArray.push(new uint(0));
                colorArray.push(new uint("0x" + hexRep.substring(0, 2)));
            } else {
                colorArray.push(new uint(0));
                colorArray.push(new uint(0));
                colorArray.push(new uint(0));
            }
            colorArray.push(alphaRestValue);
            
            return colorArray;
        }
        */
        
        public static function encode(symbol:Symbol):String {
            return JSON.encode(SymbolJsonUtil.symbol2Object(symbol));
        }
        
        public static function decode(symbolJson:String):Symbol {
            return SymbolJsonUtil.object2Symbol(JSON.decode(symbolJson));
        }
        
        private static function symbol2Object(symbol:Symbol):Object {
            var symbolObj:Object = new Object();
            
            if (symbol is TextSymbol) {
                /*
                var textSym:TextSymbol = symbol as TextSymbol;
                //not yet finished
                symbolObj.type = "esriTS";
                symbolObj.angle = textSym.angle;
                symbolObj.color = encodeColor(textSym.color, textSym.alpha);
                if (textSym.background) {
                    symbolObj.backgroundColor = encodeColor(textSym.backgroundColor);
                }
                if (textSym.border) {
                    symbolObj.borderLineColor = encodeColor(textSym.borderColor);
                }
                symbolObj.xoffset = textSym.xoffset;
                symbolObj.yoffset = textSym.yoffset;
                symbolObj.text = textSym.text;
                */
            } else if (symbol is SimpleMarkerSymbol) {
                /*
                var markerSym:SimpleMarkerSymbol = symbol as SimpleMarkerSymbol;
                symbolObj.type = "esriSMS";
                symbolObj.style = symbolObj.type + markerSym.style.substring(0, 1).toUpperCase() + markerSym.style.substring(1);
                symbolObj.color = encodeColor(markerSym.color, markerSym.alpha);
                symbolObj.size = markerSym.size;
                symbolObj.angle = markerSym.angle;
                symbolObj.xOffset = markerSym.xoffset;
                symbolObj.yOffset = markerSym.yoffset;
                if (markerSym.outline) {
                    var outlineObj:Object = new Object();
                    outlineObj.color = encodeColor(markerSym.outline.color, markerSym.outline.alpha);
                    outlineObj.width = markerSym.outline.width;
                    outlineObj.style = markerSym.outline.style;
                    symbolObj.outline = outlineObj;
                }
                */
            } else if (symbol is SimpleLineSymbol) {
                var lineSym:SimpleLineSymbol = symbol as SimpleLineSymbol;
                symbolObj.type = SymbolJsonUtil.SIMPLE_LINE_SYMBOL_TYPE;
                symbolObj.style = lineSym.style;
                symbolObj.color = lineSym.color;
                symbolObj.alpha = lineSym.alpha;
                symbolObj.width = lineSym.width;
            } else if (symbol is SimpleFillSymbol) {
                var fillSym:SimpleFillSymbol = symbol as SimpleFillSymbol;
                symbolObj.type = SymbolJsonUtil.SIMPLE_FILL_SYMBOL_TYPE;
                symbolObj.style = fillSym.style;
                symbolObj.color = fillSym.color;
                symbolObj.alpha = fillSym.alpha;
                if (fillSym.outline) {
                    symbolObj.outline = symbol2Object(fillSym.outline);
                }
            } else {
                trace("Unknown SYMBOL type to convert to json: " + symbol);
                return null;
            }

            return symbolObj;
        }
        
        private static function object2Symbol(symbolObj:Object):Symbol {
            if (symbolObj == null) {
                trace("SYMBOL Object is null: " + symbolObj);
                return null;
            }
            
            var symbol:Symbol;
            var symbolType:String = symbolObj["type"];
            
            switch (symbolType) {
                case SymbolJsonUtil.TEXT_SYMBOL_TYPE:
                    break;
                case SymbolJsonUtil.SIMPLE_MARKER_SYMBOL_TYPE:
                    break;
                case SymbolJsonUtil.SIMPLE_LINE_SYMBOL_TYPE:
                    var sls:SimpleLineSymbol = new SimpleLineSymbol();
                    sls.style = symbolObj.style;
                    sls.color = symbolObj.color;
                    sls.alpha = symbolObj.alpha;
                    sls.width = symbolObj.width;

                    symbol = sls;
                    break;
                case SymbolJsonUtil.SIMPLE_FILL_SYMBOL_TYPE:
                    var sfs:SimpleFillSymbol = new SimpleFillSymbol();
                    sfs.style = symbolObj.style;
                    sfs.color = symbolObj.color;
                    sfs.alpha = symbolObj.alpha;
                    sfs.outline = object2Symbol(symbolObj.outline) as SimpleLineSymbol;

                    symbol = sfs;
                    break;
                default:
                    trace("Unknown SYMBOL type to convert from json: " + symbolObj);
                    return null;
            }

            return symbol;
        }
    }
}
