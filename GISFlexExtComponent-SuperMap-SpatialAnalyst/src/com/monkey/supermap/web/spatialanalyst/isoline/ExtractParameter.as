package com.monkey.supermap.web.spatialanalyst.isoline {
    /**
     * SuperMap等值线/面的提取参数设置类
     * 
     * @author Sun
     * @see com.supermap.services.components.commontypes.ExtractParameter
     */
    public class ExtractParameter {
        /**
         * 光滑方法: B 样条法
         */
        public static const SMOOTH_METHOD_BSPLINE:String = "BSPLINE";

        /**
         * 光滑方法: 磨角法
         */
        public static const SMOOTH_METHOD_POLISH:String = "POLISH";

        /**
         * 操作区域
         * TODO 还不知道这个参数如何使用
         */
//        public var clipRegion:Geometry;
        /**
         * 基准值
         */
        public var datumValue:Number = 0;

        /**
         * 等值线Z值集合
         * TODO 还不知道这个参数如何使用
         */
//        public var expectedZValues:Array;

        /**
         * 等值距
         */
        public var interval:Number = 10;

        /**
         * 重采样容限
         */
        public var resampleTolerance:Number = 0.7;

        /**
         * 光滑方法
         */
        public var smoothMethod:String = SMOOTH_METHOD_BSPLINE;

        /**
         * 光滑度
         */
        public var smoothness:uint = 3;
    }
}
