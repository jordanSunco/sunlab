package maps {
    import com.esri.ags.Graphic;
    import com.esri.ags.symbol.SimpleFillSymbol;

    /**
     * Graphic样式策略实现模板类, 继承Ta重写getGraphicVo和styleIt实现具体策略.
     * 
     * @author Sun
     */
    public class GraphicStyleImpl implements GraphicStyleStrategy {
        public function initGraphicStyle(level:uint, graphic:Graphic,
                vos:Array):void {
            styleIt(graphic, getGraphicVo(level, graphic, vos));
        }

        public function getGraphicVo(level:uint, graphic:Graphic,
                vos:Array):Object {
            trace("FIXME getGraphicVo 模板方法, 子类必须实现具体逻辑");
            return vos[Math.floor(Math.random() * vos.length)];
        }

        public function styleIt(graphic:Graphic, graphicVo:Object):void {
            trace("FIXME styleIt 模板方法, 子类必须实现具体逻辑");
            graphic.symbol = new SimpleFillSymbol(SimpleFillSymbol.STYLE_SOLID,
                0xff00ff >> Math.random() * 10);
        }
    }
}
