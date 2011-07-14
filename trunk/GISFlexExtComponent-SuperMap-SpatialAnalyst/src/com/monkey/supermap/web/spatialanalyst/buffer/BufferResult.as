package com.monkey.supermap.web.spatialanalyst.buffer {
    /**
     * SuperMap几何对象缓冲区分析结果
     * 
     * @author Sun
     * @see SuperMap.Web.iServerJava6R.SpatialAnalyst.GeometryBufferAnalystResult
     * @see http://support.supermap.com.cn/DataWarehouse/WebDocHelp/6.0/iSever6R/mergedProjects/SuperMapiServerRESTAPI/root/spatialanalyst/geometry/geometryBufferResults/geometryBufferResult.htm 几何要素缓冲区分析结果
     */
    public class BufferResult {
        public var succeed:Boolean;
        public var message:String;
        public var image:String;
        public var resultGeometry:Object;
    }
}
