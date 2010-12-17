/*
 * Copyright
 */

package drawing {
    import flash.display.Graphics;
    import flash.geom.Point;
    
    /**
     * 画扇形的工具类(用一节节短线模拟圆弧)
     * 
     * 绘制过程:
     * 1. 将画笔移至圆心
     * 2. 计算圆弧起点(可以顺时针或逆时针画这条弧线)
     * 3. 画连接圆心和圆弧起点的线
     * 4. 每隔一定的角度(如5度)画直线来充当一节圆弧
     * 5. 画连接圆弧的结尾和圆心封闭扇形
     * 
     * @author Sun
     * @see http://blog.dofy.net/?p=207
     */
    public class SectorUtil {
        public static function drawWedge(graphics:Graphics, center:Point,
                radius:Number, startAngle:Number, arcAngle:Number):void {
            arcAngle += startAngle;

            // 计算圆弧起点(可以顺时针或逆时针画这条弧线, arcAngle为负数画顺时针)
            var arcStartPoint:Point = getArcPoint(center, radius, arcAngle);

            // 将画笔移至圆心
            graphics.moveTo(center.x, center.y);
            // 画连接圆心和圆弧起点的线
            graphics.lineTo(arcStartPoint.x, arcStartPoint.y);

            var segAngle:Number = 5;
            // 每隔一定的角度画直线来充当一节圆弧
            while (arcAngle >= startAngle + segAngle) {
                arcAngle -= segAngle;
                var arcPoint:Point = getArcPoint(center, radius, arcAngle);
                graphics.lineTo(arcPoint.x, arcPoint.y);
            }

            // 画连接圆弧的结尾和圆心封闭扇形
            graphics.lineTo(center.x, center.y);
        }

        /**
         * 计算圆弧上点的位置
         */
        public static function getArcPoint(center:Point, radius:Number,
                arcAngle:Number):Point {
            var arcRadian:Number = arcAngle * Math.PI / 180;

            return new Point(Math.sin(arcRadian) * radius + center.x,
                Math.cos(arcRadian) * radius + center.y);
        }
    }
}
