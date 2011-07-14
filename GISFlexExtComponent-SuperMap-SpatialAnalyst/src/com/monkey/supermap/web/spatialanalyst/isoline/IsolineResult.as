package com.monkey.supermap.web.spatialanalyst.isoline {
    /**
     * SuperMap几何对象等值线分析结果
     * 
     * @author Sun
     * @see SuperMap.Web.iServerJava6R.SpatialAnalyst.SurfaceAnalystResult
     * @see http://support.supermap.com.cn/DataWarehouse/WebDocHelp/6.0/iSever6R/mergedProjects/SuperMapiServerRESTAPI/root/spatialanalyst/geometry/geometryIsolineResults/geometryIsolineResult.htm 几何对象等值线分析结果
     */
    public class IsolineResult {
        public var succeed:Boolean;

        /**
         * 结果数据集标识
         */
        public var dataset:String;
        public var message:String;

        /**
         * 结果记录集, 用于存放空间对象信息.
         * 只有在对 geometryIsolineResults资源执行POST请求时,
         * dataReturnOption字段的dataReturnMode属性设置为返回Recordset,
         * 此处才会显示结果数据集中的对象信息.
         */
        public var recordset:Object;
    }
}
