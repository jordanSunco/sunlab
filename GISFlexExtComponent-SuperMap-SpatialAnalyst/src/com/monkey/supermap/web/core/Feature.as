package com.monkey.supermap.web.core {
    /**
     * SuperMap要素类
     * 
     * @author Sun
     * @see com.supermap.services.components.commontypes.Feature
     * @see http://support.supermap.com.cn/DataWarehouse/WebDocHelp/6.0/iSever6R/mergedProjects/SuperMapiServerRESTAPI/root/data/featureResults/featureResults.htm#POST%20%E8%AF%B7%E6%B1%82 Feature单个元素的描述结构
     */
    public class Feature {
        public var ID:Number;
        public var fieldNames:Array;
        public var fieldValues:Array;
        public var geometry:Object;
    }
}
