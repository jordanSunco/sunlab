/*
 * Copyright
 */

package controller.commands {
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    
    import controller.commands.business.BookDelegate;
    import controller.events.BookEvent;
    
    import model.Book;
    
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
                    addBook(actualEvent);
                    break;
                case BookEvent.DELETE_BOOK:
                    deleteBook(actualEvent.book);
                    break;
                default:
                    trace("default");
            }
        }

        private function addBook(bookEvent:BookEvent):void {
            // 简单业务, 直接操作ModelLocator影响view
            modelLocator.books.addItem(bookEvent.book);

            // 通过在event中放置responder, 可以获得view的控制权且command与view不依赖.
            // 也可以主动提供delegate一个IResponder
            var delegate:BookDelegate = new BookDelegate(bookEvent.responder);
            delegate.addBook(bookEvent.book);
        }

        private function deleteBook(book:Book):void {
            modelLocator.books.removeItemAt(modelLocator.books.getItemIndex(book));
        }
    }
}
