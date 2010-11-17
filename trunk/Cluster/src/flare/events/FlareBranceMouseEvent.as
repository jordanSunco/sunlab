package flare.events {
    import flash.display.InteractiveObject;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class FlareBranceMouseEvent extends MouseEvent {
        public static const VERTEX_CLICK:String = "vertexClick";

        public var data:Object;

        public function FlareBranceMouseEvent(type:String, bubbles:Boolean = true,
                cancelable:Boolean = false, localX:Number = NaN,
                localY:Number = NaN, relatedObject:InteractiveObject = null,
                ctrlKey:Boolean = false, altKey:Boolean = false,
                shiftKey:Boolean = false, buttonDown:Boolean=false,
                delta:int = 0, data:Object = null) {
            super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey,
                altKey, shiftKey, buttonDown, delta);
            this.data = data;
        }

        override public function clone():Event {
            return new FlareBranceMouseEvent(type, bubbles, cancelable, localX,
                localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
        }
    }
}
