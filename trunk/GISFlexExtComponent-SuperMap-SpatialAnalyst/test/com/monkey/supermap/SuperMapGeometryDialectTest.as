package com.monkey.supermap {
    import com.monkey.GeometryDialect;

    /**
     * @author Sun
     */
    public class SuperMapGeometryDialectTest {
        private var geometryDialect:GeometryDialect;

        [Before]
        public function setUp():void {
            geometryDialect = new SuperMapGeometryDialect();
        }

        [Test]
        public function getGeometry():void {
            
        }
    }
}