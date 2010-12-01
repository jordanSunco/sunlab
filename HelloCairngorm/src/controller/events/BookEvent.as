/*
 * Copyright
 */

package controller.events {
    import model.Book;
    
    import mx.rpc.IResponder;

    /**
     * 自定义业务事件, 扩展属性用于传值, 由Command接收到值并处理事件 
     * 
     * @author Sun
     */
    public class BookEvent extends ResponderCairngormEvent {
        public var book:Book;

        public static const ADD_BOOK:String = "addBook";
        public static const DELETE_BOOK:String = "deleteBook";

        public function BookEvent(type:String, responder:IResponder, book:Book) {
            super(type, responder);
            this.book = book;
        }
    }
}
