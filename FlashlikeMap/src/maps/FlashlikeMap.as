package maps {
    /**
     * 类似Flash的静态地图效果, 是怎样的效果呢?
     * 1. 地图不能漫游
     * 2. 单击地图就能下钻(drill down)点击的区域
     * 3. 地图每层只显示特定图层区域
     *     例如: 在省级别时, 地图显示的是所有市, 点击某个市, 则地图就只显示这个市的所有县.
     * 4. 能够回到上一级(roll up)
     * 
     * @author Sun
     */
    public interface FlashlikeMap {
        /**
         * 下钻Flash地图
         * 
         * @param startDrillDownFlashMapLevel 下钻发生时, 在flash地图的第几级
         * @param attributes 下钻操作依赖的条件, 一般为过滤下一级的信息
         */
        function drillDown(startDrillDownFlashMapLevel:uint, attributes:Object):void;
        function rollUp():void;
        function canDrillDown(startDrillDownFlashMapLevel:uint):Boolean;
        function canRollUp():Boolean;
    }
}
