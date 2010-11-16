package flare {
    import flash.display.Sprite;

    /**
     * 放置FlareBrance的容器, 计算每个分支的半径和旋转角度, 形成一个只有顶点和圆心连线的多边形.
     * 如果分支很多, 则会以分组的形式由内到外展现嵌套的多边形, 为避免多边形的重叠, 每组会递增半径和分支的旋转角度.
     */
    public class FlareContainer extends Sprite {
        // TODO 定制属性
        /**
         * 每组(一个圆中)最多允许多少个分支
         */
        private var maxBrancePerGroup:uint = 6;
        private var radius:uint = 30;
        /**
         * 每组半径递增的基数
         */
        private var radiusIncrease:uint = 20;

        /**
         * 分支的旋转角度
         */
        private var rotationAngle:uint = 0;
        /**
         * 每个分支旋转角度递增的基数
         */
        private var rotationAngleIncrease:uint = 15;

        /**
         * 分支对应的数据, 有多少条数据就会有多少个分支
         */
        private var data:Array;

        public function FlareContainer(data:Array) {
            this.data = data;

            addFlareBrance();
        }

        private function addFlareBrance():void {
            if (data.length <= maxBrancePerGroup) {
                addFlareBranceEquably();
            } else {
                addFlareBranceGroup();
            }
        }

        /**
         * 如果数据条数少于每组允许的最大分支数, 则将其全部归为一组, 等分一个圆
         */
        private function addFlareBranceEquably():void {
            for (var i:uint = 0, length:uint = data.length; i < length; i++) {
                this.addChild(createFlareBrance(radius, length, i, rotationAngle));
            }
        }

        protected function createFlareBrance(radius:Number, slice:uint, n:uint,
                rotation:Number):FlareBrance {
            return new FlareBrance(radius, slice, n, rotation);
        }

        /**
         * 如果数据条数多于每组允许的最大分支数, 则需要分组排列分支, 由内到外递增半径和旋转角度.
         */
        private function addFlareBranceGroup():void {
            var flareBranceRadius:Number = radius;
            var flareBranceRotationAngle:Number = rotationAngle;

            for (var i:uint = 0, length:uint = data.length; i < length; i++) {
                // 按每组允许的最大分支数分组, 每增加一组则递增半径和旋转角度
                if (i != 0 && i % maxBrancePerGroup == 0) {
                    flareBranceRadius += radiusIncrease;
                    flareBranceRotationAngle += rotationAngleIncrease;
                }

                // 每次将分支添加到显示列表的最底部, 这样长半径分支就不会将短半径分支的顶部节点切成2半, 线会位于顶点的下方
                this.addChildAt(createFlareBrance(flareBranceRadius,
                    maxBrancePerGroup, i, flareBranceRotationAngle), 0);
            }
        }
    }
}
