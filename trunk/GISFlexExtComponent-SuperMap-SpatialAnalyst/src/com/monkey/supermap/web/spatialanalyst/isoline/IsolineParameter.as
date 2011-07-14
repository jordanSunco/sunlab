package com.monkey.supermap.web.spatialanalyst.isoline {
    import com.monkey.supermap.web.spatialanalyst.DataReturnOption;

    /**
     * SuperMap基于几何对象的等值线/面分析参数类
     * 
     * @author Sun
     * @see http://support.supermap.com.cn/DataWarehouse/WebDocHelp/6.0/iSever6R/mergedProjects/SuperMapiServerRESTAPI/root/spatialanalyst/geometry/geometryIsolineResults/geometryIsolineResults.htm 请求体中的参数
     */
    public class IsolineParameter {
        /**
         * 采样点
         */
        public var points:Array;

        /**
         * Z值
         */
        public var zValues:Array;

        /**
         * 分辨率
         */
        public var resolution:Number = 3500;

        /**
         * 提取操作需要的参数
         */
        public var extractParameter:ExtractParameter = new ExtractParameter();

        /**
         * 返回的提取结果设置
         */
        public var resultSetting:DataReturnOption = new DataReturnOption();
    }
}
