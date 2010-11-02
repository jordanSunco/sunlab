package effects {
    import mx.effects.IEffectInstance;
    import mx.effects.TweenEffect;

    /**
     * DrawEffectInstance工厂类
     */
    public class DrawEffect extends TweenEffect {
        public var startValue:Number;
        public var endValue:Number;
        public var properties:Object;
        public var draw:Function;

        public function DrawEffect(target:Object=null) {
            super(target);
            instanceClass = DrawEffectInstance;
        }

        override protected function initInstance(instance:IEffectInstance):void {
            super.initInstance(instance);
            initProperties(instance);
        }

        protected function initProperties(instance:IEffectInstance):void {
            DrawEffectInstance(instance).startValue = startValue;
            DrawEffectInstance(instance).endValue = endValue;
            DrawEffectInstance(instance).properties = properties;
            DrawEffectInstance(instance).draw = draw;
        }
    }
}
