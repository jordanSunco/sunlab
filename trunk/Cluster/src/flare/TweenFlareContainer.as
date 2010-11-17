package flare {
    import flare.events.TweenFlareContainerEffectEvent;
    
    import flash.events.MouseEvent;
    
    import mx.effects.CompositeEffect;
    import mx.effects.Parallel;
    import mx.events.EffectEvent;
    
    [Event(name="flareContainerCloseComplete", type="flare.events.TweenFlareContainerEffectEvent")]
    
    public class TweenFlareContainer extends FlareContainer {
        private var compositeEffect:CompositeEffect;

        public function TweenFlareContainer(data:Array) {
            super(data);
            initCompositeEffect();
            expand();
            handleMouseEvent();
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

            compositeEffect.removeEventListener(EffectEvent.EFFECT_START, handlecloseStart);
            compositeEffect.removeEventListener(EffectEvent.EFFECT_END, handlecloseComplete);
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

            compositeEffect.addEventListener(EffectEvent.EFFECT_START, handlecloseStart);
            compositeEffect.addEventListener(EffectEvent.EFFECT_END, handlecloseComplete);

            for (var i:uint = 0, length:uint = this.numChildren; i < length; i++) {
                var tweenFlareBrance:TweenFlareBrance = this.getChildAt(i) as TweenFlareBrance;

                compositeEffect.addChild(tweenFlareBrance.back(false));
            }

            compositeEffect.play();
        }

        private function handlecloseStart(event:EffectEvent):void {
            dispatchEvent(new TweenFlareContainerEffectEvent(
                TweenFlareContainerEffectEvent.FLARE_CONTAINER_CLOSE_START,
                true, true));
        }

        private function handlecloseComplete(event:EffectEvent):void {
            dispatchEvent(new TweenFlareContainerEffectEvent(
                TweenFlareContainerEffectEvent.FLARE_CONTAINER_CLOSE_COMPLETE,
                true, true));
        }

        private function handleMouseEvent():void {
            this.addEventListener(MouseEvent.ROLL_OVER, function ():void {
                expand();
            });
            this.addEventListener(MouseEvent.ROLL_OUT, function ():void {
                close();
            });
        }
    }
}