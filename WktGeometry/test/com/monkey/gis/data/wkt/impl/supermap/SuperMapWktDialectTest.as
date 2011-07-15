package com.monkey.gis.data.wkt.impl.supermap {
    import com.monkey.gis.data.wkt.WktDialect;
    
    import org.flexunit.asserts.fail;

    public class SuperMapWktDialectTest {
        private var wktDialect:WktDialect;

        [Before]
        public function setUp():void {
            this.wktDialect = new SuperMapWktDialect();
        }

        [Test]
        public function testGetPoint():void {
            fail("未实现");
        }
    }
}
