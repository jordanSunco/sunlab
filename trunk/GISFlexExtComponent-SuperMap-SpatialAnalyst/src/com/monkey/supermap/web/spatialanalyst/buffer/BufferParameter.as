package com.monkey.supermap.web.spatialanalyst.buffer {
    import org.openscales.geometry.Geometry;

    /**
     * SuperMap基于几何对象的缓冲区分析参数类
     * 
     * @author Sun
     * @see com.supermap.web.iServerJava2.queryServices.BufferQueryParameters
     */
    public class BufferParameter {
        public var sourceGeometry:Object;
        public var analystParameter:BufferAnalystParameter;

        public function BufferParameter(sourceGeometry:Geometry,
                analystParameter:BufferAnalystParameter) {
            this.sourceGeometry = sourceGeometry;
            this.analystParameter = analystParameter;
        }
    }
}
