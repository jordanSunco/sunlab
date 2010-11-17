package flare.events {
    import flash.events.Event;

    public class TweenFlareContainerEffectEvent extends Event {
        public static const FLARE_CONTAINER_CLOSE_START:String = "flareContainerCloseStart";
        public static const FLARE_CONTAINER_CLOSE_COMPLETE:String = "flareContainerCloseComplete";

        public function TweenFlareContainerEffectEvent(type:String, bubbles:Boolean=false,
                cancelable:Boolean=false) {
            super(type, bubbles, cancelable);
        }
    }
}
