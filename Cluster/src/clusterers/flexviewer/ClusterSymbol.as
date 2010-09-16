package clusterers.flexviewer {
    import com.esri.ags.Map;
    import com.esri.ags.geometry.Geometry;
    import com.esri.ags.geometry.MapPoint;
    import com.esri.ags.symbol.Symbol;

    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    /**
     * Symbol to render ClusterGraphic.
     */
    public class ClusterSymbol extends Symbol {
        private var m_radius:Number = 20;
        private var m_textFormat:TextFormat = new TextFormat("Helvetica", 12, 0xFFFFFF);

        private const RED:Number = 0xFF0F00;
        private const ORANGE:Number = 0xFF6900;
        private const YELLOW:Number = 0xFF9F00;
        private const GREEN:Number = 0x76D100;

        public function ClusterSymbol() {
            m_textFormat.align = TextFormatAlign.CENTER;
            m_textFormat.leftMargin = 1;
            m_textFormat.rightMargin = 1; 
        }

        public function set radius(value:Number):void {
            m_radius = value;            
        }

        override public function clear(sprite:Sprite):void {
            sprite.graphics.clear();
        }

        override public function draw(sprite:Sprite, geometry:Geometry,
                attributes:Object, map:Map):void {
            // 根据地图点将sprite定位到屏幕坐标的正确位置
            const mapPoint:MapPoint = MapPoint(geometry);
            const sx:Number = toScreenX(map, mapPoint.x);
            const sy:Number = toScreenY(map, mapPoint.y);
            sprite.x = sx;
            sprite.y = sy;

            // 一个聚合图形包含的点数量
            const n:int = attributes.n;
            if (n === 1) {
                sprite.graphics.beginFill(GREEN, 1.0);
                sprite.graphics.drawCircle(0, 0, Number(m_textFormat.size));
                sprite.graphics.endFill();
            } else { // 不同的数量采用不同颜色的圆圈表示
                var color : Number;
                if( n < 11 ) {
                    color = GREEN;
                } else if( n < 101 ) {
                    color = YELLOW;
                } else if( n < 1001 ) {
                    color = ORANGE;
                } else {
                    color = RED;
                }
                sprite.graphics.beginFill(color, 0.25);                                    
                sprite.graphics.drawCircle(0, 0, m_radius);
                sprite.graphics.endFill();

                sprite.graphics.beginFill(color, 0.75);                                    
                sprite.graphics.drawCircle(0, 0, 20);
                sprite.graphics.endFill();
            }

            // 获得TextField显示点的数量
            const textField:TextField = sprite.getChildByName("textField") as TextField;
            textField.text = n.toString();
            textField.setTextFormat(m_textFormat);
            textField.x = -(textField.width >> 1);
            textField.y = 1 - (textField.height >> 1);
        }
    }
}