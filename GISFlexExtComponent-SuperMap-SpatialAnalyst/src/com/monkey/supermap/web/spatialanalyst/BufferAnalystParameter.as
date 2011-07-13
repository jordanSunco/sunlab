package com.monkey.supermap.web.spatialanalyst {
    /**
     * SuperMap缓冲区分析参数类
     * 
     * @author Sun
     * @see com.supermap.services.components.commontypes.BufferAnalystParameter
     * @see com.supermap.web.iServerJava2.queryServices
     */
    public class BufferAnalystParameter {
        public static const END_TYPE_ROUND:String = "ROUND";
        public static const END_TYPE_FLAT:String = "FLAT";

        public var leftDistance:BufferDistance = new BufferDistance(2);
        public var rightDistance:BufferDistance = new BufferDistance(2);
        public var endType:String = END_TYPE_ROUND;
        public var semicircleLineSegment:uint = 4;
    }
}
