package com.monkey.supermap.web.spatialanalyst.buffer {
    import org.openscales.geometry.Geometry;

    /**
     * SuperMap基于几何对象的缓冲区分析参数类
     * 
     * @author Sun
     * @see com.supermap.web.iServerJava2.queryServices.BufferQueryParameters
     * @see SuperMap.Web.iServerJava6R.SpatialAnalyst.GeometryBufferAnalystParameters
     * @see http://support.supermap.com.cn/DataWarehouse/WebDocHelp/6.0/iSever6R/mergedProjects/SuperMapiServerRESTAPI/root/spatialanalyst/geometry/geometryBufferResults/geometryBufferResults.htm 几何对象的缓冲区分析请求体中的参数
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
