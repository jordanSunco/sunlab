package com.monkey.supermap {
    import com.monkey.supermap.web.spatialanalyst.SpatialAnalystServiceTest;

    /**
     * @author Sun
     */
    [Suite]
    [RunWith("org.flexunit.runners.Suite")]
    public class SpatialAnalystTestSuite {
        public var superMapGeometryDialectTest:SuperMapGeometryDialectTest;
        public var superMapFeatureDialectTest:SuperMapFeatureDialectTest;
        public var spatialAnalystServiceTest:SpatialAnalystServiceTest;
    }
}
