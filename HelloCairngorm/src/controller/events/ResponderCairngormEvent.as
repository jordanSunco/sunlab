/*
 * Copyright
 */

package controller.events {
    import com.adobe.cairngorm.control.CairngormEvent;
    
    import mx.rpc.IResponder;

    /**
     * 扩展CairngormEvent, 在event中放置IResponder, 可以将IResponder.result写在view中,
     * 获得view的控制权, 而且不会让command对view有依赖.
     * 
     * @author Sun
     */
    public class ResponderCairngormEvent extends CairngormEvent {
        public var responder:IResponder;

        public function ResponderCairngormEvent(type:String,
                responder:IResponder = null, bubbles:Boolean = false,
                cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
            this.responder = responder;
        }
    }
}
