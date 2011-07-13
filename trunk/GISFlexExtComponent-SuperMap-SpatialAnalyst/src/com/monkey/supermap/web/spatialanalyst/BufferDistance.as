package com.monkey.supermap.web.spatialanalyst {
    /**
     * 由于SuperMap REST API要求BufferAnalystParameter.leftDistance/rightDistance做为参数
     * 在序列化为JSON时需要包装成一个对象, 而不是简单的数值.
     * 例如leftDistance=2 -&gt; "leftDistance ":{"value":2}
     * 
     * @see com.monkey.supermap.web.spatialanalyst.BufferAnalystParameter
     * @see com.supermap.services.components.commontypes.BufferDistance
     * @see http://support.supermap.com.cn/DataWarehouse/WebDocHelp/6.0/iSever6R/mergedProjects/SuperMapiServerRESTAPI/root/spatialanalyst/geometry/geometryBufferResults/geometryBufferResults.htm 几何对象的缓冲区分析请求体中的参数
     */
    public class BufferDistance {
        public var value:Number;

        public function BufferDistance(value:Number) {
            this.value = value;
        }
    }
}