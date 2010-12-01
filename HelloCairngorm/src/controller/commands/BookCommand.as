/*
 * Copyright
 */

package controller.commands {
    import com.adobe.cairngorm.business.ServiceLocator;
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    
    import controller.events.BookEvent;
    
    import model.Book;
    
    import mx.rpc.AsyncToken;
    import mx.rpc.Responder;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.http.HTTPService;
    
    import view.BookModelLocator;

    /**
     * 通过FrontController关联了event和command后, 如果有对应的事件发生,
     * 则会调用command.excute响应事件
     * 
     * @author Sun
     */
    public class BookCommand implements ICommand {
        private var modelLocator:BookModelLocator = BookModelLocator.getInstance();

        public function execute(event:CairngormEvent):void {
            var actualEvent:BookEvent = event as BookEvent;

            // 判断event.type, 这样使一个Command可以处理多个事件(一系列的),
            // 减少编写Command文件
            switch (event.type) {
                case BookEvent.ADD_BOOK:
                    addBook(actualEvent.book);
                    break;
                case BookEvent.DELETE_BOOK:
                    deleteBook(actualEvent.book);
                    break;
                default:
                    trace("default");
            }
        }

        private function addBook(book:Book):void {
            // 简单业务, 直接操作ModelLocator影响view
            modelLocator.books.addItem(book);
            invokeService("add");
        }

        private function deleteBook(book:Book):void {
            modelLocator.books.removeItemAt(modelLocator.books.getItemIndex(book));
            invokeService("delete");
        }

        private function invokeService(from:String):void {
            // 获取service调用远程方法, 通过AsyncToken而不是事件监听来获取结果,
            // 这样才能使调用是一次性的, 不会造成相互影响
            var service:HTTPService = ServiceLocator.getInstance()
                .getHTTPService("bookService");
            var asyncToken:AsyncToken = service.send();
            var responder:Responder = new Responder(function (data:Object):void {
                trace(from, (data as ResultEvent).result);
            }, function (info:Object):void {
                trace(from, info);
            });
            asyncToken.addResponder(responder);
        }
    }
}
