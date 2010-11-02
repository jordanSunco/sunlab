package effects {
    import mx.effects.effectClasses.TweenEffectInstance;

    /**
     * 在做Drawing API时, 可以以动画的形式慢慢画出整个图形.
     */
    public class DrawEffectInstance extends TweenEffectInstance {
        public var startValue:Number;
        public var endValue:Number;

        /**
         * 其他不需要变动的属性
         */
        public var properties:Object;

        /**
         * 这里实现具体的绘图逻辑, 调用target的Drawing API.
         * 参数为target, value, properties.
         */
        public var draw:Function;

        public function DrawEffectInstance(target:Object) {
            super(target);
        }

        override public function play():void{
            super.play();
            this.tween = createTween(this, startValue, endValue, duration);
        }

        override public function onTweenUpdate(value:Object):void {
            super.onTweenUpdate(value);
            draw(target, value, properties);
        }
    }
}
