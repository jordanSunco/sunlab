/*
 * Copyright
 */

package controller {
    import com.adobe.cairngorm.control.FrontController;
    
    import controller.commands.BookCommand;
    import controller.events.BookEvent;

    /**
     * 关联event和command, 告诉你发出event会被哪个command处理.
     * 类似于web mvc中前端总指挥的角色, 按照URL映射action动作.
     * 
     * @author Sun
     */
    public class BookController extends FrontController {
        public function BookController() {
            addCommand(BookEvent.ADD_BOOK, BookCommand);
            addCommand(BookEvent.DELETE_BOOK, BookCommand);
        }
    }
}
