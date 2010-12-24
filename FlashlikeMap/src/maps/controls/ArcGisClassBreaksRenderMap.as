package maps.controls {
    import com.esri.ags.Graphic;
    
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.utils.getDefinitionByName;
    
    import maps.GraphicStyleStrategy;
    
    /**
     * 基于分层区域渲染的效果, 各区域通过策略决定需要渲染的颜色
     * 
     * @author
     */
    public class ArcGisClassBreaksRenderMap extends ArcGisFlashlikeMap {
        protected var renderedGraphics:Array = [];

        protected var defaultDropShadowFilter:DropShadowFilter = new DropShadowFilter();

        /**
         * 与Graphic能通过某种关联关系对应上的一组值对象, 具体关联关系由样式策略的实现类决定
         */
        protected var _graphicsAssociateVos:Array;

        /**
         * 样式策略的实现类, 通过Ta来决定Graphic应有的样式
         */
        protected var graphicStyleStrategy:GraphicStyleStrategy;

        override protected function styleGraphics(graphics:Array):void {
            // 记录当前渲染的Graphic, 用于在关联VO或样式策略更新时重设样式
            this.renderedGraphics = graphics;
            initGraphicsStyleByAssociateVos(graphics);
        }

        /**
         * 从Graphic关联的一组值对象中初始每一个Graphic的样式
         * 
         * @param graphics
         */
        protected function initGraphicsStyleByAssociateVos(graphics:Array):void {
            for each (var graphic:Graphic in graphics) {
                if (_graphicsAssociateVos) { // 如果存在关联值对象, 则使用样式策略
                    graphicStyleStrategy.initGraphicStyle(this._flashMapLevel,
                        graphic, this._graphicsAssociateVos);
                } else { // 如果没有关联值对象, 则使用默认样式
                    graphic.symbol = _defaultSymbol;
                }

                addGraphicRollBehavior(graphic);
            }
        }

        protected function addGraphicRollBehavior(graphic:Graphic):void {
            // 先删除掉以前添加过的这对事件监听器, 不然会触发N次
            graphic.removeEventListener(MouseEvent.ROLL_OVER, graphicRollOverHanlder);
            graphic.removeEventListener(MouseEvent.ROLL_OUT, graphicRollOutHanlder);

            graphic.addEventListener(MouseEvent.ROLL_OVER, graphicRollOverHanlder);
            graphic.addEventListener(MouseEvent.ROLL_OUT, graphicRollOutHanlder);
        }

        protected function graphicRollOverHanlder(event:MouseEvent):void {
            if (! _graphicsAssociateVos) {
                event.target.symbol = _rollOverSymbol;
            }
            event.target.filters = [defaultDropShadowFilter];
        }

        protected function graphicRollOutHanlder(event:MouseEvent):void {
            if (! _graphicsAssociateVos) {
                event.target.symbol = _defaultSymbol;
            }
            event.target.filters = null;
        }

        /**
         * 获取样式策略实现类的实例.
         * 注意必须明确声明(使用)过实现类, 或者通过compiler arguments包含此实现类(例如-include foo.bar)
         * 
         * @param classFullName
         */
        private function getImplementInstance(classFullName:String):GraphicStyleStrategy {
            var _interface:GraphicStyleStrategy;

            try {
                var ImplementClass:Class = getDefinitionByName(classFullName) as Class;
                // 直接通过Class实例化
                _interface = new ImplementClass();
            } catch (e:ReferenceError) {
                throw new ReferenceError(e.message + "必须明确声明(使用)过实现类, 或者通过compiler arguments包含此实现类(例如-includes foo.bar)");
            } catch (e:Error) {
                throw new Error(e.message + "必须实现GraphicStyleStrategy接口");
            }

            return _interface;
        }

        public function set graphicsAssociateVos(value:Array):void {
            this._graphicsAssociateVos = value;
            styleGraphics(this.renderedGraphics);
        }

        public function set graphicStyleStrategyImplClass(value:String):void {
            this.graphicStyleStrategy = getImplementInstance(value);
            styleGraphics(this.renderedGraphics);
        }
    }
}
