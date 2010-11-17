package flare {
    import mx.effects.CompositeEffect;
    import mx.effects.Parallel;
    
    public class TweenFlareContainer extends FlareContainer {
        private var compositeEffect:CompositeEffect;

        public function TweenFlareContainer(data:Array) {
            super(data);
            initCompositeEffect();
            expand();
        }

        override protected function createFlareBrance(radius:Number, slice:uint,
                n:uint, rotation:Number, data:Object):FlareBrance {
            return new TweenFlareBrance(radius, slice, n, rotation, data);
        }

        protected function initCompositeEffect():void {
            compositeEffect = new Parallel();
        }

        private function resetCompositeEffect():void {
            compositeEffect.children.length = 0;
        }

        public function expand():void {
            resetCompositeEffect();

            for (var i:uint = 0, length:uint = this.numChildren; i < length; i++) {
                var tweenFlareBrance:TweenFlareBrance = this.getChildAt(i) as TweenFlareBrance;

                compositeEffect.addChild(tweenFlareBrance.out(false));
            }

            compositeEffect.play();
        }

        public function close():void {
            resetCompositeEffect();

            for (var i:uint = 0, length:uint = this.numChildren; i < length; i++) {
                var tweenFlareBrance:TweenFlareBrance = this.getChildAt(i) as TweenFlareBrance;

                compositeEffect.addChild(tweenFlareBrance.back(false));
            }

            compositeEffect.play();
        }
    }
}