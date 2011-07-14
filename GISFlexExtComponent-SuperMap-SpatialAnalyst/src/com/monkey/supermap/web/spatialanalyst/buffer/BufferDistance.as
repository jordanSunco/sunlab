package com.monkey.supermap.web.spatialanalyst.buffer {
    /**
     * 由于SuperMap REST API要求BufferAnalystParameter.leftDistance/rightDistance做为参数
     * 在序列化为JSON时需要包装成一个对象, 而不是简单的数值.
     * 例如leftDistance=2 -&gt; "leftDistance ":{"value":2}
     * 
     * @see com.monkey.supermap.web.spatialanalyst.BufferAnalystParameter
     * @see com.supermap.services.components.commontypes.BufferDistance
     */
    public class BufferDistance {
        public var value:Number;

        public function BufferDistance(value:Number) {
            this.value = value;
        }
    }
}
