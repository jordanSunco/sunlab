package heatmap {
    import com.esri.ags.Map;
    import com.esri.ags.events.ExtentEvent;
    import com.esri.ags.events.PanEvent;
    import com.esri.ags.geometry.MapPoint;
    import com.michaelvandaniker.visualization.HeatMap;
    
    import flash.events.Event;
    import flash.geom.Point;
    
    /**
     * 扩展热点图, 使热点图能够覆盖在ArcGIS Map上.
     * 
     * 1. 将热点图作为子元素UI组件, 添加到arcgis的Map组件中.
     * 2. 地图漫游以及extent变化时, 热点能重新计算位置.
     * 3. 热点数据(dataProvider)使用经纬度点(MapPoint), 会自动计算成屏幕坐标.
     * 
     * @author Sun
     */
    public class ArcGisHeatMap extends HeatMap {
        private var _map:Map;

        public function set map(value:Map):void {
            _map = value;
            addToMap();
            followMap();
        }

        private function addToMap():void {
            this.width = _map.width;
            this.height = _map.height;

            _map.addChild(this);
        }

        /**
         * 热点数据(dataProvider)如何转换成Point屏幕点.
         * 
         * 1. 热点数据现在是一组经纬度点(MapPoint)
         * 2. o代表的是一个热点数据, 这里就是一个经纬度点
         * 3. 将o转换成屏幕点, 这里通过map.toScreen达到目的
         * 
         * @see updatePoints
         */
        override protected function xyTransformationFunction(o:Object):Point {
            // 只有当map.loaded = true时, 才能使用toScreen方法.
            // 也就是说只有当地图加载完成以后, 地图渲染成功, 才能确定地图有多大,
            // 这时才能做屏幕坐标的计算.
            return _map.toScreen(o as MapPoint);
        }

        /**
         * 监听地图漫游以及extent变化使重新计算热点屏幕坐标, 并重绘, 达到热点订在地图上的效果.
         */
        private function followMap():void {
            _map.addEventListener(ExtentEvent.EXTENT_CHANGE, updateHeatMap);
            _map.addEventListener(PanEvent.PAN_UPDATE, updateHeatMap);
        }

        private function updateHeatMap(event:Event):void {
            this.updatePoints();
            this.invalidateDisplayList();
        }
    }
}
