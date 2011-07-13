package com.monkey.utils {
    import org.openscales.geometry.Geometry;
    import org.openscales.geometry.Point;

    /**
     * @author Sun
     */
    public class GeometryUtil {
        /**
         * 获取Geometry中所有的坐标值
         * 
         * @param geometry
         * @return 包含所有坐标值的数组([x1, y1, x2, y2...])
         */
        public static function getCoordinates(geometry:Geometry):Array {
            var vertices:Vector.<Point> = geometry.toVertices();

            var coordinates:Array = [];
            for each (var point:Point in vertices) {
                coordinates.push(point.x, point.y);
            }

            return coordinates;
        }
    }
}
