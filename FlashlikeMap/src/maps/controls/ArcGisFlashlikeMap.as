package maps.controls {
    import com.esri.ags.Graphic;
    import com.esri.ags.Map;
    import com.esri.ags.events.MapMouseEvent;
    import com.esri.ags.geometry.Extent;
    import com.esri.ags.layers.GraphicsLayer;
    import com.esri.ags.symbol.SimpleFillSymbol;
    import com.esri.ags.symbol.SimpleLineSymbol;
    import com.esri.ags.symbol.Symbol;
    import com.esri.ags.tasks.FeatureSet;
    import com.esri.ags.tasks.Query;
    import com.esri.ags.toolbars.Navigation;
    import com.esri.ags.utils.GraphicUtil;
    
    import flash.events.MouseEvent;
    
    import maps.FlashlikeMap;
    import maps.business.SpatialBusinessDelegate;
    import maps.events.ArcGisFlashlikeMapEvent;
    
    import utils.DefaultResponder;

    [Event(name="renderGraphic", type="maps.events.ArcGisFlashlikeMapEvent")]

    /**
     * 通过高亮ArcGIS切片图层特定区域的办法来达到类似Flash静态地图的效果.
     * 
     * 由于一般的Flash静态地图都是基础图层(省, 市, 县这样的行政区域等等),
     * 图层数据变化的频率比较慢, 出于性能和显示效果的考虑,
     * ArcGIS推荐将这些图层做为一个切片地图服务.
     * 但是做成切片地图服务后, 地图就变成了一块一块切好的(静态)图片,
     * 不能使用图层过滤功能(即只显示地图的某些区域, 例如只显示一个市的所有县).
     * 
     * 那么我们怎么变相的达到只显示地图中的某些区域呢?
     * 1. 将地图整体配成浅色, 这样就能突出那些高亮的区域, 让人可以无视周围的区域
     * 2. 查询出那些只想在地图上显示的区域(Polygon Graphic)
     * 3. 将它们添加到GraphicsLayer中, 并使用Symbol高亮突出它们
     * 4. 将地图视野调整到刚好能容纳它们, 不过这时肯定还是能够看到周围的区域(颜色淡可以无视)
     * 5. 当鼠标移入/移出区域时切换高亮效果, 使单个区域有3D凸起的感觉(使用Filter)
     * 
     * 下面是一个应用场景:
     * 在省视野显示包含的市, 单个市视野显示包含的县, 单个县视野显示包含的乡镇
     * 1. 地图分省, 市, 县3层视野, 对应ArcGIS地图层级0, 1, 3
     * 2. 省这一层默认显示了所有的市
     * 3. 在省这一层点击地图, 查询点击了哪个市
     * 4. 查询这个市包含的县, 高亮出来
     * 5. 调整地图视野刚好能容纳所有高亮的县, 并调整地图层级到市, 也就是第1层
     * 6. 点击某个高亮的县
     * 7. 查询这个县包含的乡镇, 高亮出来
     * 8. 调整地图视野刚好能容纳所有高亮的乡镇, 并调整地图层级到县, 也就是第3层
     * 
     * @author Sun
     */
    public class ArcGisFlashlikeMap extends Map implements FlashlikeMap {
        private var highlightGraphicsLayer:GraphicsLayer;

        [ArrayElementType("com.talkweb.maps.controls.ArcGisFlashMapLevelConfig")]
        private var _flashMapLevelConfigs:Array;
        protected var _flashMapLevel:uint;

        private var firstDrillDownMapLevel:uint;

        [ArrayElementType("com.esri.ags.tasks.FeatureSet")]
        private var highlightFeatureSetHistory:Array = [];

        protected var _defaultSymbol:Symbol = new SimpleFillSymbol(SimpleFillSymbol.STYLE_SOLID, 0xD2F386, 0.7, new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 0xFFFFFF, 1, 2));
        protected var _rollOverSymbol:Symbol = new SimpleFillSymbol(SimpleFillSymbol.STYLE_CROSS, 0, 0.5, new SimpleLineSymbol(SimpleLineSymbol.STYLE_SOLID, 0x003D5C, 1, 2));

        /**
         * 用于回退到全图视野(zoomToFullExtent)
         */
        private var navigationTool:Navigation = new Navigation();

        /**
         * 记录当flash地图从第0层(这时并不处于地图的第0层)下钻时的extent, 用于回退到该视野
         */
        private var firstDrillDownExtent:Extent;

        /**
         * 通过绑定通知外界地图是否还能够进行回退操作
         */
        private var _canRollUpValue:Boolean;

        public function ArcGisFlashlikeMap() {
            disableMapNavigation();
            initClickDillDown();
            navigationTool.map = this;
        }

        private function disableMapNavigation():void {
            this.mapNavigationEnabled = false;
            this.zoomSliderVisible = false;
        }

        /**
         * 初始化点击地图能进行下钻操作.
         * 只有在第一次下钻的时候才触发此操作, 其他时候下钻都通过点击已经高亮的Graphic来完成.
         */
        private function initClickDillDown():void {
            this.addEventListener(MapMouseEvent.MAP_CLICK, firstDrillDown);
        }

        /**
         * 进行第一次下钻操作, 查询条件为点击位置.
         * 当地图层级处于第一次下钻所要求的地图层级时, 才触发此行为.
         * 
         * @param event
         */
        protected function firstDrillDown(event:MapMouseEvent):void {
            if (this.level == firstDrillDownMapLevel) {
                if (this.level != 0) {
                    this.firstDrillDownExtent = this.extent;
                }

                var firstFlashMapLevel:ArcGisFlashMapLevelConfig =
                    getFlashMapLevelConfig(0);

                var queryParameter:Query = new Query();
                // 查询第一层高亮图层的条件为点击位置
                queryParameter.geometry = event.mapPoint;
                queryParameter.outFields = firstFlashMapLevel.outFields;

                var businessDelegate:SpatialBusinessDelegate =
                    new SpatialBusinessDelegate(new DefaultResponder(
                        handleFirstHighlightLayerResult));
                businessDelegate.queryLayer(firstFlashMapLevel.highlightLayerUrl,
                    queryParameter);
            }
        }

        /**
         * 根据第一层图层的查询结果, 进行下钻
         * 
         * @param featureSet
         */
        private function handleFirstHighlightLayerResult(featureSet:FeatureSet):void {
            if (featureSet.features.length > 0) {
                var firstHighlightLayerGraphic:Graphic =
                    featureSet.features[0] as Graphic;
                // 从flash地图第0层开始下钻
                drillDown(0, firstHighlightLayerGraphic.attributes);
            }
        }

        /**
         * 1. 需要在Map中添加一个默认的GraphicsLayer做高亮图形用
         * 2. 继承Map, 在构造函数时添加一个GraphicsLayer, 这样的方式不行, 原因可能是MXML中采用layers方式添加的图层覆盖了最开始添加的图层(就是这里的GraphicsLayer). 但万万没想到的是这会造成整个地图都出不来了, debug结果如下:
         *     // 在构造函数中添加GraphicsLayer, 可以看出图层确实是加入成功了
         *     trace("in constructor before", (this.layers as ArrayCollection).length); // 输出: 0
         *     this.addLayer(new GraphicsLayer()); // 试过指定index
         *     trace("in constructor after", (this.layers as ArrayCollection).length); // 输出: 1
         * 
         *     <!-- 同时通过MXML在外部添加图层(一般的流程都是这样) -->
         *     <controls:ArcGisFlashlikeMap id="map">
         *         <esri:ArcGISTiledMapServiceLayer url="" />
         *     </controls:ArcGisFlashlikeMap>
         *     // 初始成功后再试试添加图层
         *     trace("in init before", map.layers); // 只看见ArcGISTiledMapServiceLayer, 没有看见在构造函数中添加的GraphicsLayer, 被无视了?
         *     map.addLayer(new ArcGISDynamicMapServiceLayer(""));
         *     trace("in init after", map.layers); // 还是只有ArcGISTiledMapServiceLayer和ArcGISDynamicMapServiceLayer, 而且地图没有显示出这些图层, 那个无辜的GraphicsLayer就这样被无情的抛弃了.
         * 
         * 3. 解决方案, 重写set layers方法, 在这里实现添加默认GraphicsLayer的逻辑
         */
        override public function set layers(value:Object):void {
            super.layers = value;

            if (! highlightGraphicsLayer) {
                highlightGraphicsLayer = new GraphicsLayer();
                this.addLayer(highlightGraphicsLayer);

                highlightGraphicsLayer.addEventListener(MouseEvent.CLICK,
                    clickGraphicDrillDown);
            }
        }

        private function clickGraphicDrillDown(event:MouseEvent):void {
            // 在地图下钻(zoom)的过程中, 如果快速点击地图会触发GraphicsLayer的点击事件,
            // 如果此时没有点中GraphicsLayer中的Graphic, 则event.target代表GraphicsLayer,
            // 所以这里需要判断一下只有当取得到Graphic时才进行下钻
            var clickedGraphic:Graphic = event.target as Graphic;
            if (clickedGraphic) {
                // 当前层级下钻
                drillDown(_flashMapLevel, clickedGraphic.attributes);
            }
        }

        public function drillDown(startDrillDownFlashMapLevel:uint,
                graphicAttributes:Object):void {
            if (canDrillDown(startDrillDownFlashMapLevel)) {
                // 开始下钻操作, 设置当前flash所处的地图层级
                this._flashMapLevel = startDrillDownFlashMapLevel;

                // 根据当前图层的查询结果(graphic属性)来过滤下一层flash地图配置的高亮图层
                // 下一层所需要的过滤条件中的值, 对应当前flash地图的层级配置中下一层所需字段
                var nextLevelLayerWhereClauseValues:Array = getAttributeValues(
                    graphicAttributes,
                    getFlashMapLevelConfig(startDrillDownFlashMapLevel).nextLevelLayerWhereFields);

                // 查询数据是异步操作, 查询结果在某时刻返回后会修改_flashMapLevel
                // 如果直接使用_flashMapLevel实例变量会造成多线程问题
                queryNextHighlightLayer(startDrillDownFlashMapLevel,
                    nextLevelLayerWhereClauseValues);
            }
        }

        /**
         * Flash地图的回退操作.
         * 
         * 实现机制:
         * 1. 记录每一次高亮的FeatureSet
         * 2. 回退操作前, 会有2次高亮的FeatureSet被记录(上一层的和当前层的)
         *     这里有个例外就是从第2层回退到第1层, 例如从市回退到省, 需要单独实现, 逻辑有所不同.
         *     回退到省需要4步操作:
         *         a) flash地图层级设置到0
         *         b) 地图层级设置到0
         *         c) 清空高亮GraphicsLayer
         *         d) 移除记录的高亮FeatureSet
         * 3. 那么回退时, 需要回退到上上一层Flash地图层级(level - 2), 取出上两次高亮的FeatureSet, 就能调用highlightAndZoom方法高亮并定位到正确视野
         * 
         * 例如:
         * 当前在第1层, 高亮A市的所有县, 这是第1次高亮的FeatureSet(fs1)
         * 下钻到第2层, 高亮B县的所有乡镇, 这是第2次高亮的FeatureSet(fs2)
         * 那么我们如何回到第1层的状态?
         * 其实就是从第0层(2 - 2)下钻, 并高亮fs1即可, 由于我们记录了每一次高亮的FeatureSet, 只需从记录数组中取出倒数第2条即可(length - 2)
         */
        public function rollUp():void {
            if (canRollUp()) {
                // 回退 = 退2层再下钻一层, 即level - 2 + 1
                // 例如当前在第2层, 回退应该到第1层, 就是(2 - 2) + 1, 从第0层下钻到第1层
                var startDrillDownFlashMapLevel:int = this._flashMapLevel - 2;

                if (startDrillDownFlashMapLevel < 0) {
                    backToFirstFlashMapLevel();
                } else {
                    // 倒数第2个高亮FeatureSet
                    var highlightFeatureSet:FeatureSet = this.highlightFeatureSetHistory[this.highlightFeatureSetHistory.length - 2];
                    highlightAndZoom(startDrillDownFlashMapLevel, highlightFeatureSet);
                }

                // 回退后, 删除掉记录的最后2个FeatureSet(为了该次回退操作而保留的)
                removeLastTwoHighlightFeatureSetFromHistory();
            }
        }

        public function canDrillDown(startDrillDownFlashMapLevel:uint):Boolean {
            return startDrillDownFlashMapLevel + 1 < this._flashMapLevelConfigs.length;
        }

        public function canRollUp():Boolean {
            return this._flashMapLevel - 1 >= 0;
        }

        [Bindable]
        public function get canRollUpValue():Boolean {
            return this._canRollUpValue;
        }

        private function set canRollUpValue(value:Boolean):void {
            this._canRollUpValue = value;
        }

        private function backToFirstFlashMapLevel():void {
            this.highlightGraphicsLayer.clear();
            this._flashMapLevel = 0;
            // 当flash地图位于第0层时, 就不能进行地图回退操作了, 已经到达顶层
            this.canRollUpValue = false;

            // 如果flash地图是从地图的第0层开始下钻的, 那么回退到全图视野,
            // 否则回退到从flash第0层下钻时的extent
            if (this.firstDrillDownMapLevel == 0) {
                this.navigationTool.zoomToFullExtent();
            } else {
                this.extent = this.firstDrillDownExtent;
            }
        }

        private function removeLastTwoHighlightFeatureSetFromHistory():void {
            this.highlightFeatureSetHistory.pop();
            this.highlightFeatureSetHistory.pop();
        }

        /**
         * 查询flash地图层级配置中的下一层图层, 并将查询结果高亮显示出来.
         * 
         * @param startDrillDownFlashMapLevel 下钻时的flash地图层级
         * @param whereClauseValues where语句条件的真实值
         */
        private function queryNextHighlightLayer(startDrillDownFlashMapLevel:uint,
                whereClauseValues:Array):void {
            // 获取下一层flash图层的配置, 当前处于哪一层已经在drillDown中设置好了
            var nextFlashMapLevelConfig:ArcGisFlashMapLevelConfig =
                getFlashMapLevelConfig(startDrillDownFlashMapLevel + 1);

            var queryParameter:Query = new Query();
            // 查询条件来自上一层, 在drillDown中会根据上一层的结果生成条件
            queryParameter.where = populateWhereClause(
                nextFlashMapLevelConfig.highlightLayerWhereClause,
                whereClauseValues);
            queryParameter.outFields = nextFlashMapLevelConfig.outFields;
            // 需要高亮显示, 必须返回geometry
            queryParameter.returnGeometry = true;

            var businessDelegate:SpatialBusinessDelegate =
                new SpatialBusinessDelegate(new DefaultResponder(
                    function (featureSet:FeatureSet):void {
                        highlightAndZoom(startDrillDownFlashMapLevel, featureSet);
                    })
                );
            businessDelegate.queryLayer(nextFlashMapLevelConfig.highlightLayerUrl,
                queryParameter);
        }

        private function getAttributeValues(attributes:Object,
                propertyNames:Array):Array {
            var values:Array = [];
            for each (var propertyName:String in propertyNames) {
                values.push(attributes[propertyName]);
            }

            return values;
        }

        /**
         * 组装SQL语句中的where条件, 将?替换成真实值
         * 
         * @param whereClause 使用问号占位的where条件语句
         * @param whereClauseValues 与问号位对应的真实值
         * 
         * @return 使用真实值替换了问号的where语句
         */
        private function populateWhereClause(whereClause:String,
                whereClauseValues:Array):String {
            // TODO 通过模板方式替换字符串, 应对可能存在的多个?条件
            return whereClause.replace("?", whereClauseValues[0]);
        }

        /**
         * 高亮图层并调整地图视野刚好能容纳所有高亮区域
         * 
         * @param startDrillDownFlashMapLevel 下钻时的flash地图层级
         * @param featureSet
         */
        protected function highlightAndZoom(startDrillDownFlashMapLevel:uint,
                featureSet:FeatureSet):void {
            // 能够下钻下来就能够回退回去
            this.canRollUpValue = true;

            // 记录高亮的featureSet, 用于回退
            this.highlightFeatureSetHistory.push(featureSet);

            // 下钻完成后, flash地图层级也会向下一层
            this._flashMapLevel = startDrillDownFlashMapLevel + 1;

            // 取得下一层flash地图层级配置的ArcGIS地图图层, 定位过去
            zoomToExtent(featureSet.features,
                getFlashMapLevelConfig(this._flashMapLevel).mapLevel);
            styleGraphics(featureSet.features);
            renderGraphics(featureSet.features);

            dispatchRenderGraphicEvent(startDrillDownFlashMapLevel, featureSet);
        }

        protected function dispatchRenderGraphicEvent(
                startDrillDownFlashMapLevel:uint, featureSet:FeatureSet):void {
            var renderGraphicEvent:ArcGisFlashlikeMapEvent = new ArcGisFlashlikeMapEvent(
                ArcGisFlashlikeMapEvent.RENDER_GRAPHIC,
                startDrillDownFlashMapLevel, featureSet);

            dispatchEvent(renderGraphicEvent);
        }

        /**
         * 调整地图视野刚好能容纳所有传入的graphics, 并可额外设定地图层级
         * 
         * @param graphics
         * @param mapLevel
         */
        public function zoomToExtent(graphics:Array, mapLevel:Number = -1):void {
            this.extent = GraphicUtil.getGraphicsExtent(graphics);

            if (mapLevel != -1) {
                this.level = mapLevel;
            }
        }

        /**
         * 将graphics添加到专门用于高亮的GraphicsLayer中
         * 
         * @param graphics
         */
        private function renderGraphics(graphics:Array):void {
            this.highlightGraphicsLayer.graphicProvider = graphics;
        }

        /**
         * 设置graphics的样式(可以是Symbol和Filter)
         */
        protected function styleGraphics(graphics:Array):void {
            for each (var graphic:Graphic in graphics) {
                graphic.symbol = this._defaultSymbol;

                // graphic与鼠标交互时切换其样式
                graphic.addEventListener(MouseEvent.ROLL_OVER, onGraphicRollOver);
                graphic.addEventListener(MouseEvent.ROLL_OUT, onGraphicRollOut);
            }
        }

        protected function onGraphicRollOver(event:MouseEvent):void {
            event.target.symbol = _rollOverSymbol;
        }

        protected function onGraphicRollOut(event:MouseEvent):void {
            event.target.symbol = _defaultSymbol;
        }

        private function getFlashMapLevelConfig(flashMapLevel:uint):ArcGisFlashMapLevelConfig {
            return this._flashMapLevelConfigs[flashMapLevel] as ArcGisFlashMapLevelConfig;
        }

        public function set flashMapLevelConfigs(value:Array):void {
            this._flashMapLevelConfigs = value;
            initFirstDrillDownMapLevel();
        }

        private function initFirstDrillDownMapLevel():void {
            this.firstDrillDownMapLevel = getFlashMapLevelConfig(0).mapLevel;
        }

        public function get flashMapLevel():uint {
            return this._flashMapLevel;
        }

        public function set defaultSymbol(value:Symbol):void {
            this._defaultSymbol = value;
        }

        public function set rollOverSymbol(value:Symbol):void {
            this._rollOverSymbol = value;
        }
    }
}
