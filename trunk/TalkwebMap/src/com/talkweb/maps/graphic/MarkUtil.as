package com.talkweb.maps.graphic {
    import com.esri.ags.Graphic;
    import com.esri.ags.events.DrawEvent;
    import com.esri.ags.geometry.Geometry;
    import com.esri.ags.geometry.MapPoint;
    import com.esri.ags.geometry.Multipoint;
    import com.esri.ags.layers.GraphicsLayer;
    import com.esri.ags.symbol.InfoSymbol;
    import com.esri.ags.symbol.Symbol;
    import com.esri.ags.toolbars.Draw;
    import com.talkweb.maps.config.MapConfig;
    import com.talkweb.maps.graphic.symbol.SymbolUtil;
    import com.talkweb.maps.service.MapService;

    import flash.events.MouseEvent;

    import mx.core.ClassFactory;

    /**
     * 地图标注
     */
    public class MarkUtil {
        private var _mapService:MapService;

        public function set mapService(_mapService:MapService):void {
            this._mapService = _mapService;
        }

        public function get mapService():MapService {
            return this._mapService;
        }

        /**
         * 添加图形要素到地图的绘画图层
         *
         * @param graphics 图形要素
         * @param graphicsLayer 指定添加到哪个绘画图层(默认为一个共用图层)
         * @param defaultSymbol 默认样式(默认根据geometry类型可自动获得)
         * @param rollOverSymbol 鼠标交互时的样式(默认根据geometry类型可自动获得)
         */
        public function addGraphics(graphics:Array,
            graphicsLayer:GraphicsLayer = null, defaultSymbol:Symbol = null,
            rollOverSymbol:Symbol = null):void {
            graphicsLayer = graphicsLayer ? graphicsLayer : 
                this._mapService.draw.graphicsLayer;

            for each (var g:Graphic in graphics) {
                defaultSymbol = defaultSymbol ? defaultSymbol : 
                    SymbolUtil.getHighLightSymbol(g.geometry.type);
                rollOverSymbol = rollOverSymbol ? rollOverSymbol : 
                    SymbolUtil.getRollOverSymbol(g.geometry.type);

                g.symbol = defaultSymbol;

                addDefaultRollOver(g, defaultSymbol, rollOverSymbol);

                graphicsLayer.add(g);
            }
        }

        /**
         * 在地图上添加InfoWindow显示信息
         *
         * @param graphic 图形要素
         * @param infoRendererClass 渲染数据的容器
         * @param attributes 需要传递到容器中的数据, 默认为图形要素中的attributes
         *
         * @see com.esri.ags.symbol.InfoSymbol
         */
        public function addInfo(graphic:Graphic, infoRendererClass:Class = null, 
            attributes:Object = null):void {
            var infoSymbol:InfoSymbol = new InfoSymbol();
            infoSymbol.infoRenderer = infoRendererClass == null ? null : 
                new ClassFactory(infoRendererClass);

            var g:Graphic = new Graphic(getCenter(graphic.geometry), infoSymbol);
            if (attributes != null) {
                g.attributes = attributes;
            } else {
                g.attributes = graphic.attributes;
            }

            this._mapService.draw.graphicsLayer.add(g);
        }

        /**
         * 清空绘画图层的图形要素
         *
         * @param graphicsLayer 指定需要清除哪个绘画图层(默认为一个共用图层)
         */
        public function clearGraphicsLayer(graphicsLayer:GraphicsLayer = null):void {
            graphicsLayer = graphicsLayer ? graphicsLayer : 
                this._mapService.draw.graphicsLayer;

            graphicsLayer.clear();
        }

        /**
         * 启动画图工具, 并完成测距功能
         *
         * @param callback 测距完成后的回调函数(lengths:Array, token:Object)
         * @param token 回调函数中的额外参数引用
         * @param wkid 空间索引标准(默认为32618)
         */
        public function measureDistanceByDraw(callback:Function, token:Object = null,
            wkid:Number = MapConfig.DEFAULT_MEASURE_WIKI):void {
            _mapService.draw.activate(Draw.POLYLINE);

            _mapService.draw.addEventListener(DrawEvent.DRAW_END, drawEndHandler);

            function drawEndHandler(event:DrawEvent):void {
                _mapService.draw.deactivate();
                _mapService.draw.removeEventListener(DrawEvent.DRAW_END, drawEndHandler);

                addDefaultRollOver(event.graphic,
                    SymbolUtil.getHighLightSymbol(event.graphic.geometry.type),
                    SymbolUtil.getRollOverSymbol(event.graphic.geometry.type));

                _mapService.measureDistance([event.graphic], callback, token, wkid);
            }
        }

        /**
         * 启动画图工具, 并完成测面功能
         *
         * @param callback 测距完成后的回调函数(areaLengths:Object, token:Object)
         * @param token 回调函数中的额外参数引用
         */
        public function measureAreaByDraw(callback:Function, token:Object = null):void {
            _mapService.draw.activate(Draw.POLYGON);

            _mapService.draw.addEventListener(DrawEvent.DRAW_END, drawEndHandler);

            function drawEndHandler(event:DrawEvent):void {
                _mapService.draw.deactivate();
                _mapService.draw.removeEventListener(DrawEvent.DRAW_END, drawEndHandler);

                addDefaultRollOver(event.graphic,
                    SymbolUtil.getHighLightSymbol(event.graphic.geometry.type),
                    SymbolUtil.getRollOverSymbol(event.graphic.geometry.type));

                _mapService.measureArea([event.graphic], callback, token);
            }
        }

        /**
         * 添加默认鼠标经过时样式变化
         *
         * @param graphic 图形要素
         * @param defaultSymbol 默认样式
         * @param rollOverSymbol 鼠标经过时的样式
         */
        protected function addDefaultRollOver(graphic:Graphic,
            defaultSymbol:Symbol, rollOverSymbol:Symbol):void {
            graphic.addEventListener(MouseEvent.ROLL_OVER, function ():void {
                    graphic.symbol = rollOverSymbol;
                });

            graphic.addEventListener(MouseEvent.ROLL_OUT, function ():void {
                    graphic.symbol = defaultSymbol;
                });
        }

        /**
         * 获取图形要素的中心点
         *
         * @param geometry 地理信息
         * @return 中心点
         */
        protected function getCenter(geometry:Geometry):MapPoint {
            var mapPoint:MapPoint;

            switch (geometry.type) {
                case Geometry.MAPPOINT:
                    mapPoint = geometry as MapPoint;
                    break;
                case Geometry.MULTIPOINT:// 当只有一个点时无法通过extent获取中心点
                    var multiPoint:Multipoint = geometry as Multipoint;

                    if (multiPoint.points.length == 1) {
                        mapPoint = multiPoint.points[0];
                    } else {
                        mapPoint = multiPoint.extent.center;
                    }
                    break;
                case Geometry.POLYLINE:
                // fall-through
                case Geometry.EXTENT:
                // fall-through
                case Geometry.POLYGON:
                    mapPoint = geometry.extent.center;
                    break;
                default:
                    mapPoint = geometry as MapPoint;
            }

            return mapPoint;
        }
    }
}

