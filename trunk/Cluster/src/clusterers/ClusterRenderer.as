/*
 * Copyright
 */

package clusterers {
    import clusterers.symbol.FlareSymbol;
    
    import com.esri.ags.Graphic;
    import com.esri.ags.Map;
    import com.esri.ags.events.ExtentEvent;
    import com.esri.ags.geometry.Geometry;
    import com.esri.ags.geometry.MapPoint;
    import com.esri.ags.layers.GraphicsLayer;
    import com.esri.ags.renderers.ClassBreakInfo;
    import com.esri.ags.symbol.CompositeSymbol;
    import com.esri.ags.symbol.SimpleMarkerSymbol;
    import com.esri.ags.symbol.Symbol;
    import com.esri.ags.symbol.TextSymbol;
    
    import flare.events.TweenFlareContainerEffectEvent;
    
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    
    import mx.collections.ArrayCollection;
    import mx.events.CollectionEvent;

    [DefaultProperty("classBreakInfo")]

    /**
     * Cluster a set of map points.
     * 扩展基于flexviewer实现的点聚合效果
     * 1. 重构
     * 2. 增加分级配置功能
     * 3. 增加默认递增聚合效果
     * 
     * @author Sun
     * @version 2010-09-16
     */
    public class ClusterRenderer {
        /**
         * 必须获得Map对象调用其转换经纬度的方法(toScreen)
         */
        private var _map:Map;

        /**
         * 展现聚合点的GraphicsLayer
         * 
         * TODO 想通过GraphicsLayer来获得Map, 但由于Map还未初始化好, 会得到null
         */
        private var _renderLayer:GraphicsLayer;

        /**
         * 需要聚合的原始Graphic点
         */
        [ArrayElementType("com.esri.ags.Graphic")]
        private var _mapPointGraphicSource:ArrayCollection = new ArrayCollection();

        /**
         * 聚合的范围 in pixels
         */
        private var _radius:int = 20;
        private var diameter:int;

        /**
         * 分级配置信息, 设置聚合点数量区间对应的Symbol
         */
        [ArrayElementType("com.esri.ags.renderers.ClassBreakInfo")]
        private var _classBreakInfo:Array;

        /**
         * 当没有分级配置信息时, 默认聚合点基数的大小
         */
        private var baseSize:uint = 10;

        /**
         * 当没有分级配置信息时, 聚合点最大限制
         */
        private var maxSize:uint = 150;

        /**
         * 当没有分级配置信息时, 默认聚合点透明度
         */
        private var defaultAlpha:Number = 0.75;

        /**
         * 聚合点要素
         */
        [ArrayElementType("clusterers.Cluster")]
        private var clusters/*<int,Cluster>*/:Dictionary;

        /**
         * 聚合后的Graphic点
         */
        [ArrayElementType("com.esri.ags.Graphic")]
        private var _clusterGraphics:ArrayCollection = new ArrayCollection();

        private var overlapExists:Boolean;

        public function ClusterRenderer(_map:Map = null,
                _renderLayer:GraphicsLayer = null,
                _mapPointGraphicSource:ArrayCollection = null) {
            if (_map) {
                map = _map;
            }

            if (_renderLayer) {
                renderLayer = _renderLayer;
            }

            if (_mapPointGraphicSource) {
                mapPointGraphicSource = _mapPointGraphicSource;
            }
        }

        private function graphicChangeHandler(event:CollectionEvent):void {
            clusterMapPoints();
        }

        private function extentChangeHandler(event:ExtentEvent):void {
            clusterMapPoints();            
        }

//        private function clusterMapPoints():void {
        public function clusterMapPoints():void {
            diameter = radius * 2;

            assignMapPointsToClusters();

            // Keep merging overlapping clusters until none overlap.
            do {
                mergeOverlappingClusters();
            } while (overlapExists);

            showClusterGraphics();
        }

        private function showClusterGraphics():void {
            clusterGraphics.removeAll();

            for each (var cluster:Cluster in clusters) {
                // Convert clusters to graphics so they can be displayed.
                var mapPoint:MapPoint = map.toMap(new Point(cluster.x, cluster.y))
                cluster.x = mapPoint.x;
                cluster.y = mapPoint.y;

                var graphic:Graphic = new Graphic(cluster, createClusterSymobl(cluster));
                graphic.filters = getGraphicFilters(cluster);
                addFlareSymbol(graphic);

                clusterGraphics.addItem(graphic);
            }

            // TODO 会覆盖图层中原有的Graphic
            this._renderLayer.graphicProvider = clusterGraphics;
        }

        private function addFlareSymbol(graphic:Graphic):void {
            var clusterSymobl:Symbol = graphic.symbol;
            // TODO 写死最多能展开30个点
            var flareMaxCount:uint = 30;

            if ((graphic.geometry as Cluster).getMapPointCount() <= flareMaxCount) {
                graphic.addEventListener(MouseEvent.ROLL_OVER, function (event:MouseEvent):void {
                    event.target.symbol = new FlareSymbol();
                });
                graphic.addEventListener(TweenFlareContainerEffectEvent.FLARE_CONTAINER_CLOSE_COMPLETE, function ():void {
                    graphic.symbol = clusterSymobl;
                });
            }
        }

        /**
         * TODO 给Graphic添加滤镜效果
         */
        protected function getGraphicFilters(cluster:Cluster):Array {
            var dropShadowFilter:DropShadowFilter = new DropShadowFilter(5);
            var glowFilter:GlowFilter = new GlowFilter(0x88AEF7, 1, 12, 12, 1, 2);
            return [dropShadowFilter, glowFilter];
        }

        protected function createClusterSymobl(cluster:Cluster):Symbol {
            var clusterMapPointCount:uint = cluster.getMapPointCount();

            // 显示聚合点
            var baseSymbol:Symbol;
            // 显示聚合点的数量
            var clusterCountTextSymbol:TextSymbol = new TextSymbol();
            // TODO 自定义TextSymbol
            clusterCountTextSymbol.color = 0xFFFFFF;
            clusterCountTextSymbol.text = cluster.getMapPointCount().toString();

            // 混合聚合点和文字
            var compositeSymbol:CompositeSymbol = new CompositeSymbol();
            var symbols:ArrayCollection = compositeSymbol.symbols as ArrayCollection;

            if (_classBreakInfo) {
                baseSymbol = getSymoblFromBreak(clusterMapPointCount);
            } else {
                baseSymbol = getDefaultSymobl(clusterMapPointCount);
            }

            // 从分级配置信息中获取Symbol, 可能获得null
            if (baseSymbol) {
                symbols.addItem(baseSymbol);
            }
            symbols.addItem(clusterCountTextSymbol);

            return compositeSymbol;
        }

        /**
         * 从分级配置信息中获取Symbol, 如果没有匹配上则返回null
         */
        private function getSymoblFromBreak(clusterMapPointCount:uint):Symbol {
            for each (var info:ClassBreakInfo in _classBreakInfo) {
                if (clusterMapPointCount >= info.minValue
                        && clusterMapPointCount <= info.maxValue) {
                    return info.symbol;
                }
            }

            return null;
        }

        private function getDefaultSymobl(clusterMapPointCount:uint):Symbol {
            var sms:SimpleMarkerSymbol = new SimpleMarkerSymbol();
            sms.alpha = defaultAlpha;
            sms.size = getClusterSize(clusterMapPointCount);
            sms.color = getClusterColor(clusterMapPointCount);

            return sms;
        }

        /**
         * TODO 根据聚合点数量和递增聚合点大小
         */
        protected function getClusterSize(clusterMapPointCount:uint):uint {
            var size:uint = baseSize + clusterMapPointCount;

            if (size > maxSize) {
                return maxSize;
            }

            return size;
        }

        /**
         * TODO 根据聚合点数量和基色形成一组递增色
         */
        protected function getClusterColor(clusterMapPointCount:uint):uint {
            return (0xff0000 | (0x00ff00 * (clusterMapPointCount / 20)) 
                | (0x0000ff * (clusterMapPointCount / 20)));
        }

        private function mergeOverlappingClusters():void {
            overlapExists = false;

            // Create a new set to hold non-overlapping clusters.            
            const dest/*<int,Cluster>*/:Dictionary = new Dictionary();
            for each (var cluster:Cluster in clusters) {
                // skip merged cluster
                if(cluster.getMapPointCount() === 0) {
                    continue;
                }

                // Search all immediately adjacent clusters.
                searchAndMerge(cluster,  1,  0);
                searchAndMerge(cluster, -1,  0);
                searchAndMerge(cluster,  0,  1);
                searchAndMerge(cluster,  0, -1);
                searchAndMerge(cluster,  1,  1);
                searchAndMerge(cluster,  1, -1);
                searchAndMerge(cluster, -1,  1);
                searchAndMerge(cluster, -1, -1);

                // Find the new cluster centroid values.
                var cx:int = cluster.x / diameter;
                var cy:int = cluster.y / diameter;
                cluster.cx = cx;
                cluster.cy = cy;

                // Compute new dictionary key.
                var ci:int = (cx << 16) | cy;
                dest[ci] = cluster;
            }
            clusters = dest;
        }

		/**
		 * 寻找附近的cluster并做合成
		 */
        private function searchAndMerge(cluster:Cluster, ox:int, oy:int):void {
            const cx:int = cluster.cx + ox;
            const cy:int = cluster.cy + oy;
            const ci:int = (cx << 16) | cy;

            const found:Cluster = clusters[ci] as Cluster;
            if(found && found.getMapPointCount()) {
                const dx:Number = found.x - cluster.x;
                const dy:Number = found.y - cluster.y;
                const dd:Number = Math.sqrt(dx * dx + dy * dy);
                // Check if there is a overlap based on distance. 
                if (dd < diameter) {
                    overlapExists = true;
                    cluster.merge(found)
                }
            }
        }

        /**
         * Assign map points to clusters.
         */
        private function assignMapPointsToClusters():void {
            clusters = new Dictionary();

            for each (var graphic:Graphic in this._mapPointGraphicSource) {
                if (graphic.geometry.type == Geometry.MAPPOINT) {
                    var mapPoint:MapPoint = graphic.geometry as MapPoint;

                    // Cluster only map points in the map extent
                    if(map.extent.contains(mapPoint)) {
                        // Convert world map point to screen values.
                        var screenPoint:Point = map.toScreen(mapPoint);
                        var sx:Number = screenPoint.x;
                        var sy:Number = screenPoint.y;
     
                        // Convert to cluster x/y values.
                        var cx:int = sx / diameter;
                        var cy:int = sy / diameter;
    
                        // Convert to cluster dictionary key.
                        var ci:int = (cx << 16) | cy;
                        // Find existing cluster
                        var cluster:Cluster = clusters[ci];
                        if (cluster) {
                            // Average centroid values based on new map point.
                            cluster.x = (cluster.x + sx) / 2.0;
                            cluster.y = (cluster.y + sy) / 2.0;
                        } else {
                            // Not found - create a new cluster as that index.
                            clusters[ci] = new Cluster(sx, sy, cx, cy);

                            cluster = clusters[ci];
                        }

                        // add map point graphic to that cluster.
                        // Increment the number map points in that cluster.
                        // include itself
                        cluster.addMapPointGraphic(graphic);
                    }
                }
            }
        }

        public function get mapPointGraphicSource():ArrayCollection {
            return this._mapPointGraphicSource;
        }

        public function set mapPointGraphicSource(value:ArrayCollection):void {
            this._mapPointGraphicSource = value;

            // 监听数据源是否变化, 需要重新聚合
            this._mapPointGraphicSource.addEventListener(
                CollectionEvent.COLLECTION_CHANGE, graphicChangeHandler);

            clusterMapPoints();
        }

        public function get renderLayer():GraphicsLayer {
            return this._renderLayer;
        }

        public function set renderLayer(value:GraphicsLayer):void {
            this._renderLayer = value;
        }

        public function get map():Map {
            return this._map;
        }

        public function set map(value:Map):void {
            this._map = value;

            // 监听Map extent是否改变, 需要重新聚合
            this.map.addEventListener(ExtentEvent.EXTENT_CHANGE, extentChangeHandler);
        }

        public function get clusterGraphics():ArrayCollection {
            return this._clusterGraphics;
        }

        public function get radius():int {
            return this._radius;
        }

        public function set radius(value:int):void {
            this._radius = value;
        }

        public function get classBreakInfo():Array {
            return this._classBreakInfo;
        }

        public function set classBreakInfo(value:Array):void {
            this._classBreakInfo = value;
        }
    }
}
