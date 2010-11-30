/*
 * Copyright
 */

package view {
    import com.adobe.cairngorm.CairngormError;
    import com.adobe.cairngorm.CairngormMessageCodes;
    
    import mx.collections.ArrayCollection;

    /**
     * View展现需要的数据模型
     * 
     * @author Sun
     */
    public class BookModelLocator {
        private static var instance:BookModelLocator;

        [Bindable]
        public var books:ArrayCollection = new ArrayCollection();

        public function BookModelLocator() {
            if (instance != null) {
                throw new CairngormError(CairngormMessageCodes.SINGLETON_EXCEPTION,
                    "BookModelLocator");
            }
            instance = this;
        }

        public static function getInstance():BookModelLocator {
            if (instance == null) {
                instance = new BookModelLocator();
            }
            return instance;
        }
    }
}
