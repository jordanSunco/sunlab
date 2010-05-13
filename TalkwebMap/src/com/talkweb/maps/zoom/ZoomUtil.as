package com.talkweb.maps.zoom {
    import com.esri.ags.Graphic;
    import com.esri.ags.Map;
    import com.esri.ags.geometry.Extent;
    import com.esri.ags.geometry.Geometry;
    import com.esri.ags.geometry.MapPoint;
    import com.esri.ags.geometry.Multipoint;
    import com.esri.ags.utils.GraphicUtil;
    
    /**
     * 定位
     */
    public class ZoomUtil {
        private var _map:Map;
        
        public function get map():Map {
            return _map;
        }
        
        public function set map(_map:Map):void {
            this._map = _map;
        }
        
        /**
         * 定位地图到多个graphic所在的extent
         * 
         * @param graphics 多个图形要素
         * @param level 额外定位的地图层级
         */
        public function zoom(graphics: Array, level: Number = -1):void {
            if (graphics.length == 0) {
                return;
            }
            
            if (graphics.length == 1) {
                zoomByPoint(graphics[0]);
            } else {
                zoomByExtent(graphics);
            }
            
            // 如果需要额外定位到确切的地图层次
            if (level != -1) {
                _map.level = level;
            }
        }
        
        /**
         * 根据多个图形要素, 计算出能全部看见的extent 视野
         * 
         * @param graphics 多个图形要素
         */
        private function zoomByExtent(graphics:Array):void {
            var graphicsExtent:Extent = GraphicUtil.getGraphicsExtent(graphics);
            _map.extent = graphicsExtent;
            
            // make sure the whole extent is visible
            // http://resources.esri.com/help/9.3/arcgisserver/apis/flex/samples/index.html?sample=SelectAndZoom
            if (!_map.extent.containsExtent(graphicsExtent)) {
                _map.level--;
            }
        }
        
        /**
         * 根据单个图形要素类型, 处理单个点的定位到地图中心
         * 因为单个点无法获取要素的extent
         * 
         * @param graphic 图形要素
         */
        private function zoomByPoint(graphic:Graphic):void {
            var geometry:Geometry = graphic.geometry;
            
            if (geometry.type == Geometry.MAPPOINT) { // 单个点直接定位为地图中心点
                _map.centerAt(geometry as MapPoint);
            } else if (geometry.type == Geometry.MULTIPOINT) { // 多个点
                var tempGeo:Multipoint = geometry as Multipoint;
                
                if (tempGeo.points.length == 1) { // 如果只有一个点, 也是直接定位中心
                    _map.centerAt(tempGeo.points[0] as MapPoint);
                } else { // 多个点使用extent定位
                    zoomByExtent([graphic]);
                }
            } else { // 使用extent定位(线, 面)
                zoomByExtent([graphic]);
            }
        }
    }
}