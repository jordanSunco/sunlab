package  {
    import org.flexunit.asserts.assertEquals;

    /**
     * FlexUnit4 单元测试示例
     * 
     * @author Sun
     */
    public class Test {
        [Before]
        public function setUp():void {
        }

        [After]
        public function tearDown():void {
        }

        [Test]
        public function testFoo():void {
            assertEquals("hello world", "hello world");
        }
    }
}
