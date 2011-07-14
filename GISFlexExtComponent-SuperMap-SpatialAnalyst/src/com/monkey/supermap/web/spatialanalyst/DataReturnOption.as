package com.monkey.supermap.web.spatialanalyst {
    /**
     * SuperMap空间分析数据返回选项类
     * 
     * @author Sun
     * @see com.supermap.services.components.commontypes.DataReturnOption
     */
    public class DataReturnOption {
        /**
         * 数据返回模式: 只返回记录集
         */
        public static const DATA_RETURN_MODE_RECORDSET_ONLY:String = "RECORDSET_ONLY";

        /**
         * 结果数据集名称
         */
        public var dataset:String = "";

        /**
         * 最大返回记录数
         */
        public var expectCount:uint = 100;

        /**
         * 数据返回模式, 需要设置为返回记录集, 否则返回的数据集标识是用于做二次分析的
         */
        public var dataReturnMode:String = DATA_RETURN_MODE_RECORDSET_ONLY;

        /**
         * 是否覆盖已有数据集
         */
        public var deleteExistResultDataset:Boolean = false;
    }
}
