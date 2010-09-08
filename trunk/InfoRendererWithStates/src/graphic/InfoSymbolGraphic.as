package graphic {
    import com.esri.ags.Graphic;
    import com.esri.ags.geometry.Geometry;
    import com.esri.ags.layers.GraphicsLayer;
    import com.esri.ags.symbol.InfoSymbol;

    import flash.display.DisplayObject;

    import mx.core.ClassFactory;
    import mx.core.UIComponent;

    import symbol.renderer.InfoRendererWithStates;

    public class InfoSymbolGraphic extends Graphic {
        /**
         * 创建带有状态的InfoSymbol(地图上面的信息窗口)的图形要素
         * 
         * @param geometry
         * @param attributes
         * @param previewDisplayObject 预览区域的显示对象
         * @param titleLabelText 标题
         * @param detailContent 详细内容区域的显示对象
         * @param previewDisplayObjectWith 预览区域显示对象的宽
         * @param previewDisplayObjectHeight 预览区域显示对象的高
         */
        public function InfoSymbolGraphic(geometry:Geometry=null,
                attributes:Object=null, previewDisplayObject:DisplayObject = null,
                titleLabelText:String = "Title", detailContent:UIComponent = null,
                previewDisplayObjectWith:uint = 18, previewDisplayObjectHeight:uint = 18) {
            if (!attributes) {
                attributes = new Object();
            }

            attributes["previewDisplayObject"] = previewDisplayObject;
            attributes["titleLabelText"] = titleLabelText;
            attributes["detailContent"] = detailContent;
            attributes["previewDisplayObjectWith"] = previewDisplayObjectWith;
            attributes["previewDisplayObjectHeight"] = previewDisplayObjectHeight;

            var infoSymbol:InfoSymbol = new InfoSymbol();
            infoSymbol.infoRenderer = new ClassFactory(symbol.renderer.InfoRendererWithStates);

            super(geometry, infoSymbol, attributes);
        }

        /**
         * 重新将图形要素添加到GraphicsLayer上
         */
        private function reAdd2GraphicsLayer():void {
            if (parent) {
                var graphicsLayer:GraphicsLayer = parent as GraphicsLayer;
                graphicsLayer.remove(this);
                graphicsLayer.add(this);
            }
        }

        public function get previewDisplayObject():DisplayObject {
            return attributes["previewDisplayObject"];
        }

        public function set previewDisplayObject(value:DisplayObject):void {
            attributes["previewDisplayObject"] = value;
            reAdd2GraphicsLayer();
        }

        public function get previewDisplayObjectWith():uint {
            return attributes["previewDisplayObjectWith"];
        }

        public function set previewDisplayObjectWith(value:uint):void {
            attributes["previewDisplayObjectWith"] = value;
            reAdd2GraphicsLayer();
        }

        public function get previewDisplayObjectHeight():uint {
            return attributes["previewDisplayObjectHeight"];
        }

        public function set previewDisplayObjectHeight(value:uint):void {
            attributes["previewDisplayObjectHeight"] = value;
            reAdd2GraphicsLayer();
        }

        public function get titleLabelText():String {
            return attributes["titleLabelText"];
        }

        public function set titleLabelText(value:String):void {
            attributes["titleLabelText"] = value;
            reAdd2GraphicsLayer();
        }

        public function get detailContent():UIComponent {
            return attributes["detailContent"];
        }

        public function set detailContent(value:UIComponent):void {
            attributes["detailContent"] = value;
            reAdd2GraphicsLayer();
        }
    }
}
