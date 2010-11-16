package clusterers {
    import flash.display.Sprite;

    /**
     * 将圆均匀地切分成n份, 连接圆心和等份顶点, 画出其中的一个分支, 形成钟摆的样子
     */
    public class FlareBrance extends Sprite {
        private var radius:Number;
        private var slice:uint;
        private var n:uint;

        private var data:Object;

        private var vertex:Sprite;

        private var vertexX:Number;
        private var vertexY:Number;

        private var vertexFillColor:uint = 0x76D100;
        private var vertexSize:Number = 5;

        public function FlareBrance(radius:Number, slice:uint = 6, n:uint = 0,
                rotation:Number = 0, data:Object = null) {
            this.radius = radius;
            this.slice = slice;
            this.n = n;

            this.rotation = rotation;

            this.data = data;

            vertex = new Sprite();
            this.addChild(vertex);

            computeVertexCoordinate();

            clear();
            fillCircle();
            drawBrance();
            drawVertex();
        }

        private function clear():void {
            this.graphics.clear();
            vertex.graphics.clear();
        }

        private function computeVertexCoordinate():void {
            var an:Number = 2 * Math.PI / slice;
            vertexX = radius * Math.cos(an * n);
            vertexY = radius * Math.sin(an * n);
        }

        /**
         * 填充一个等半径的透明实心圆, 这样整个圆都是sprite的有效点击范围, 而不仅限于线框
         */
        private function fillCircle():void {
            this.graphics.beginFill(0, 0);
            this.graphics.drawCircle(0, 0, radius);
        }

        /**
         * 画一条连接圆心和等份顶点的线
         */
        private function drawBrance():void {
            // TODO 定制线的样式
            this.graphics.lineStyle(1);

            this.graphics.moveTo(0, 0);
            this.graphics.lineTo(vertexX, vertexY);
        }

        /**
         * 在圆的等份点处画一个填充圆代表顶点
         */
        private function drawVertex():void {
            // TODO 定制顶点的样式
            vertex.graphics.lineStyle(1);
            vertex.graphics.beginFill(vertexFillColor, 1);

            vertex.graphics.drawCircle(vertexX, vertexY, vertexSize);
            vertex.graphics.endFill();
        }
    }
}
