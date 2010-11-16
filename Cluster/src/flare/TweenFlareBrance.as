package flare {
    import effects.DrawEffect;
    
    import mx.effects.IEffect;
    import mx.effects.easing.Bounce;
    import mx.effects.easing.Linear;

    /**
     * 以缓动效果展开分支/合拢分支
     */
    public class TweenFlareBrance extends FlareBrance {
        private var expectRadius:Number;

        private var drawEffect:DrawEffect;

        public function TweenFlareBrance(radius:Number, slice:uint = 6, n:uint = 0,
                rotation:Number = 0, data:Object = null) {
            super(0, slice, n, rotation, data);

            this.expectRadius = radius;

            initTween();
        }

        private function initTween():void {
            drawEffect = new DrawEffect(this);
            drawEffect.draw = redrawFlareBrance;
        }

        /**
         * 缓动过程中重新绘制分支
         * 
         * @param target
         * @param value 缓动渐变值
         * @param properties
         */
        private function redrawFlareBrance(target:Object, value:Object,
                properties:Object):void {
            this.radius = Number(value);

            this.drawFlareBrance();
        }

        /**
         * 展开分支, 分支的半径从0开始到期望的长度, 这是一个缓动过程
         * 
         * @param play
         * @return IEffect
         */
        public function out(play:Boolean = true):IEffect {
            drawEffect.easingFunction = Bounce.easeOut;
            drawEffect.startValue = 0;
            drawEffect.endValue = expectRadius;

            if (play) {
                drawEffect.play();
            }

            return drawEffect;
        }

        /**
         * 合拢分支, 分支的半径从期望的长度开始到0, 这是一个缓动过程
         * 
         * @param play
         * @return IEffect
         */
        public function back(play:Boolean = true):IEffect {
            drawEffect.easingFunction = Linear.easeIn;
            drawEffect.startValue = expectRadius;
            drawEffect.endValue = 0;

            if (play) {
                drawEffect.play();
            }

            return drawEffect;
        }
    }
}
