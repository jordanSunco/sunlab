package clusterers.flexviewer {
    import com.esri.ags.Graphic;
    import com.esri.ags.geometry.Geometry;
    import com.esri.ags.symbol.Symbol;

    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;

    /**
     * Graphic sub class to create a textfield child to render number of clustered map points.
     */        
    public class ClusterGraphic extends Graphic {
        public function ClusterGraphic(geometry:Geometry=null, symbol:Symbol=null,
                attributes:Object=null) {
            super(geometry, symbol, attributes);
        }

        override protected function createChildren():void {
            super.createChildren();
            const textField:TextField = new TextField();
            textField.name = "textField";
            textField.mouseEnabled = false;
            textField.mouseWheelEnabled = false;
            textField.antiAliasType = AntiAliasType.ADVANCED;
            textField.selectable = false;
            textField.autoSize = TextFieldAutoSize.CENTER;
            addChild(textField);
        }
    }
}