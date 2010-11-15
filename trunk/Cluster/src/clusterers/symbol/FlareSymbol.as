package clusterers.symbol {
    import clusterers.Cluster;
    
    import com.esri.ags.Map;
    import com.esri.ags.geometry.Geometry;
    import com.esri.ags.symbol.MarkerSymbol;
    
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class FlareSymbol extends MarkerSymbol {
        public function FlareSymbol() {
            super();
        }

        override public function draw(sprite:Sprite, geometry:Geometry,
                attributes:Object, map:Map):void {
            var cluster:Cluster = geometry as Cluster;
            sprite.x = toScreenX(map, cluster.x);
            sprite.y = toScreenY(map, cluster.y);

            removeAllChildren(sprite);
            sprite.addChild(createFlareContainer(cluster.mapPointGraphics));
        }

        private function createFlareContainer(graphics:Array):Sprite {
            var graphicsLength:uint = graphics.length;

            // TODO 定制属性
            var maxBrance:uint = 6;
            var radius:uint = 30;
            var radiusIncrease:uint = 20;
            var rotationAngle:uint = 0;
            var rotationAngleIncrease:uint = 15;

            var flareContainer:Sprite = new Sprite();
            if (graphicsLength <= maxBrance) { // 如果聚合点少于6个, 则将其全部归为一组, 等分一个圆
                for (var i:uint = 0; i < graphicsLength; i++) {
                    flareContainer.addChild(drawFlareBrance(radius, graphicsLength,
                        i, rotationAngle));
                }
            } else { // 如果聚合点多于6个, 则需要分组排列分支
                for (var j:uint = 0; j < graphicsLength; j++) {
                    // 每6个分支为一组, 每一组半径增加20, 旋转角度增加15
                    if (j != 0 && j % maxBrance == 0) {
                        radius += radiusIncrease;
                        rotationAngle += rotationAngleIncrease;
                    }

                    // 每次将分支添加到显示列表的最底部, 这样长半径分支就不会将短半径分支的顶部节点切成2半
                    flareContainer.addChildAt(drawFlareBrance(radius, maxBrance, j,
                        rotationAngle), 0);
                }
            }

            return flareContainer;
        }

        /**
         * 将圆均匀地切成n份, 沿着圆心画一条线到顶点(等分点)
         * 
         * @param radius
         * @param slice 切几份
         * @param n 第几份
         * @param rotation
         */
        private function drawFlareBrance(radius:Number, slice:uint = 6,
                n:uint = 0, rotation:Number = 0):Sprite {
            var an:Number = 2 * Math.PI / slice;
            var dx:Number = radius * Math.cos(an * n);
            var dy:Number = radius * Math.sin(an * n);

            // 分支
            var flareBrance:Sprite = new Sprite();
            flareBrance.rotation = rotation;

            // 等分点顶点
            var node:Sprite = new Sprite();
            node.addEventListener(MouseEvent.CLICK, closure(n));
            flareBrance.addChild(node);

            // 填充透明的实心圆, 这样整个圆都是sprite的有效点击范围, 而不仅限于线框
            flareBrance.graphics.beginFill(0, 0);
            flareBrance.graphics.drawCircle(0, 0, radius);
            // 连接圆心的线(圆心到等分点)
            // TODO 定制线的样式
            flareBrance.graphics.lineStyle(1);
            flareBrance.graphics.moveTo(0, 0);
            flareBrance.graphics.lineTo(dx, dy);

            // TODO 定制顶点的样式
            node.graphics.lineStyle(1);
            node.graphics.beginFill(0x76D100, 1);
            node.graphics.drawCircle(dx, dy, 5);
            node.graphics.endFill();

            return flareBrance;
        }

        private function closure(i:uint):Function {
            function a(event:MouseEvent):void {
                trace(i);
            }

            return a;
        }
    }
}
