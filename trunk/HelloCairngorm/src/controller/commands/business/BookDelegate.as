/*
 * Copyright
 */

package controller.commands.business {
    import com.adobe.cairngorm.business.ServiceLocator;
    
    import model.Book;
    
    import mx.rpc.AsyncToken;
    import mx.rpc.IResponder;
    import mx.rpc.http.HTTPService;

    /**
     * 在command中, 可能有事情是他所不能处理的,
     * 这时他找来帮手(delegate)协助他完成任务(委派模式),
     * delegate中处理具体事宜, 将结果返回给command,
     * 这时的command需要实现mx.rpc.IResponder接口接收异步结果.
     * 
     * @author Sun
     */    
    public class BookDelegate {
        private var responder:IResponder;
        private var service:HTTPService;

        public function BookDelegate(responder:IResponder) {
            this.responder = responder;
            this.service = ServiceLocator.getInstance().getHTTPService("bookService");
        }

        public function deleteBook(book:Book):void {
            var token:AsyncToken = service.send();
            token.addResponder(this.responder);
        }
    }
}
