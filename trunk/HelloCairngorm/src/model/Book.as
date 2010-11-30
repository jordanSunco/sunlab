/*
 * Copyright
 */

package model {
    /**
     * 模型类, 可以在各个视图中重用
     * 
     * @author Sun
     */
    public class Book {
        public var name:String;
        public var author:String;
        public var price:String;

        public function Book(name:String, author:String, price:String) {
            this.name = name;
            this.author = author;
            this.price = price;
        }
    }
}
