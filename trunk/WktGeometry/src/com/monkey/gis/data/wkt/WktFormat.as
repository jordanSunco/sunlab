package com.monkey.gis.data.wkt {
    /**
     * WKT &lt;-&gt; 坐标数组(参考ArcGIS Geometry JSON结构)
     * 
     * @author Sun
     * @see org.openscales.core.format.WKTFormat
     * @see http://services.arcgisonline.com/ArcGIS/SDK/REST/geometry.html Geometry Objects
     */
    public class WktFormat {
        public static const POINT:String = "POINT";
        public static const LINE_STRING:String = "LINESTRING";
        public static const MULTI_LINE_STRING:String = "MULTILINESTRING";
        public static const POLYGON:String = "POLYGON";

        public static const MATCH_TYPE:RegExp = /\s*(\w+)\s*\(.+/g;
        public static const MATCH_DIGITAL:RegExp = /\d+/g;
        public static const MATCH_XY_PAIR:RegExp = /\d+\s\d+/g;
        public static const MATCH_RING:RegExp = /\(\d[^)]+\)/g;

        public static const SPACE:String = " ";
        public static const LEFT_PARENTHESES:String = "(";
        public static const RIGHT_PARENTHESES:String = ")";
        public static const EMPTY_STRING:String = "";
        public static const COMMA:String = ",";

        public static function getGeometryType(wkt:String):String {
            var type:String = wkt.replace(MATCH_TYPE, "$1");
            return type.toUpperCase();
        }

        /**
         * 读取WKT, 请其中的坐标值提取到一个数组中, 不同类型的WKT数组结构不一.
         * 一个点是组成几何图形的最基本单位, 数组结构也是基础模型.
         * 单条线, 多条线, 多边形的数组结构是一样的.
         * 
         * @param wkt
         * @return <p>POINT -&gt; [x, y]</p>
         *         <p>LINESTRING -&gt; [ [[x1, y1], [x2, y2]...] ]</p>
         *         <p>MULTILINESTRING -&gt; [ [[path1x1, path1y1], [path1x2, path1y2]...], [[path2x1, path2y1], [path2x2, path2y2]...] ... ]</p>
         *         <p>POLYGON -&gt; [ [[ring1x1, ring1y1], [ring1x2, ring1y2]...], [[ring2x1, ring2y1], [ring2x2, ring2y2]...] ... ]</p>
         */
        public static function read(wkt:String):Array {
            var geometryType:String = getGeometryType(wkt);

            var coordinates:Array;
            switch (geometryType) {
                case POINT:
                    coordinates = getPointCoordinates(wkt);
                    break;
                case LINE_STRING:
                    // 将单条线再包装一层数组, 保持其数据格式与多条线一致
                    coordinates = [getLineStringCoordinates(wkt)];
                    break;
                case MULTI_LINE_STRING:
                    // fall-through 多条线的数据格式和多边形一样, 采用相同方式来处理
                case POLYGON:
                    coordinates = getPolygonCoordinates(wkt);
                    break;
                default:
                    trace("default");
            }

            return coordinates;
        }

        /**
         * 获取POINT WKT点坐标数组
         * 
         * @param wkt
         * @return [x, y]
         */
        private static function getPointCoordinates(wkt:String):Array {
            var xy:Array = wkt.match(MATCH_DIGITAL);
            return [xy[0], xy[1]];
        }

        /**
         * 获取LINESTRING WKT点坐标数组
         * 
         * @param wkt
         * @return [[x1, y1], [x2, y2]...]
         */
        private static function getLineStringCoordinates(wkt:String):Array {
            var xyPairs:Array = wkt.match(MATCH_XY_PAIR);

            var path:Array = [];
            for each (var xy:String in xyPairs) {
                path.push(getPointCoordinates(xy));
            }
            return path;
        }

        /**
         * 获取POLYGON WKT点坐标数组
         * 
         * @param wkt
         * @return [ [[ring1x1, ring1y1], [ring1x2, ring1y2]...], [[ring2x1, ring2y1], [ring2x2, ring2y2]...] ... ]
         */
        private static function getPolygonCoordinates(wkt:String):Array {
            var ringsWkt:Array = wkt.match(MATCH_RING);

            var rings:Array = [];
            for each (var ring:String in ringsWkt) {
                rings.push(getLineStringCoordinates(ring));
            }
            return rings;
        }

        /**
         * 将坐标数组输出为WKT格式
         * 
         * @see #read()
         */
        public static function write(type:String, coordinates:Array):String {
            var wktStringBuffer:Array = [type, SPACE, LEFT_PARENTHESES];

            switch (type) {
                case POINT:
                    wktStringBuffer.push(parsePoint(coordinates));
                    break;
                case LINE_STRING:
                    wktStringBuffer.push(parseLineString(coordinates));
                    break;
                case MULTI_LINE_STRING:
                    // fall-through 多条线的数据格式和多边形一样, 采用相同方式来处理
                case POLYGON:
                    wktStringBuffer.push(parseLine(coordinates));
                    break;
                default:
                    trace("default");
            }

            wktStringBuffer.push(RIGHT_PARENTHESES);
            return wktStringBuffer.join(EMPTY_STRING);
        }

        private static function parsePoint(coordinates:Array):String {
            return coordinates.join(SPACE);
        }

        private static function parseLineString(coordinates:Array):String {
            var wktStringBuffer:Array = [];

            for each (var line:Array in coordinates) {
                for each (var xy:Array in line) {
                    wktStringBuffer.push(xy.join(SPACE), COMMA);
                }
            }
            // 删除添加最后一个元素时多加的一个逗号
            wktStringBuffer.pop();

            return wktStringBuffer.join(EMPTY_STRING);
        }

        private static function parseLine(coordinates:Array):String {
            var wktStringBuffer:Array = [];

            for each (var lines:Array in coordinates) {
                wktStringBuffer.push(LEFT_PARENTHESES);

                for each (var xy:Array in lines) {
                    wktStringBuffer.push(xy.join(SPACE), COMMA);
                }
                // 删除添加最后一个元素时多加的一个逗号
                wktStringBuffer.pop();

                wktStringBuffer.push(RIGHT_PARENTHESES, COMMA);
            }
            // 删除添加最后一个元素时多加的一个逗号
            wktStringBuffer.pop();

            return wktStringBuffer.join(EMPTY_STRING);
        }
    }
}
