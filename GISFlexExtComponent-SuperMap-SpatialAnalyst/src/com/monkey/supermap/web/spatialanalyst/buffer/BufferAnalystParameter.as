package com.monkey.supermap.web.spatialanalyst.buffer {
    /**
     * SuperMap缓冲区分析参数类
     * 
     * @author Sun
     * @see com.supermap.services.components.commontypes.BufferAnalystParameter
     * @see com.supermap.web.iServerJava2.queryServices
     */
    public class BufferAnalystParameter {
        /**
         * 端点类型: 圆头缓冲
         */
        public static const END_TYPE_ROUND:String = "ROUND";

        /**
         * 端点类型: 平头缓冲
         */
        public static const END_TYPE_FLAT:String = "FLAT";

        /**
         * 左缓冲距离
         */
        public var leftDistance:BufferDistance = new BufferDistance(2);

        /**
         * 右缓冲距离
         */
        public var rightDistance:BufferDistance = new BufferDistance(2);

        /**
         * 端点类型
         */
        public var endType:String = END_TYPE_ROUND;

        /**
         * 圆头缓冲圆弧处线段的个数
         */
        public var semicircleLineSegment:uint = 4;
    }
}
