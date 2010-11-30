/*
 * Copyright
 */

package controller.commands {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    
    import controller.commands.business.BookDelegate;
    import controller.events.BookEvent;
    
    import model.Book;
    
    import mx.rpc.IResponder;
    import mx.rpc.events.ResultEvent;
    
    import view.BookModelLocator;

    /**
     * 通过FrontController关联了event和command后, 如果有对应的事件发生,
     * 则会调用command.excute响应事件
     * 
     * @author Sun
     */
    public class BookCommand implements ICommand, IResponder {
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

        public function result(data:Object):void {
            trace((data as ResultEvent).result);
        }

        public function fault(info:Object):void {
            trace(info);
        }

        private function addBook(book:Book):void {
            // 简单业务, 直接操作ModelLocator影响view
            modelLocator.books.addItem(book);
        }

        private function deleteBook(book:Book):void {
            modelLocator.books.removeItemAt(modelLocator.books.getItemIndex(book));

            // 复杂业务, 如调用远程服务, 通过delegate模式委派, 结果返回到Command中的IResponder.result
            var delegate:BookDelegate = new BookDelegate(this);
            delegate.deleteBook(book);
        }
    }
}
