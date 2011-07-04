package com.monkey.arcgis.gp {
    /**
     * Job执行完成后, 会给出result的url, 告诉你去哪里取最终GP的输出结果.
     * 返回的JSON格式为:
     * {
     *     "jobId" : "j9cf42332bdd0403d88964f1d45a9c31e",
     *      "jobStatus" : "esriJobSucceeded",
     *      "results" : {
     *          "POINT_FS_Project" : {"paramUrl" : "results/POINT_FS_Project"},
     *          "POINT_FS_Project1" : {"paramUrl" : "results/POINT_FS_Project1"}
     *      }
     * }
     * JobResultInfo用于表示results中的一个属性(输出参数名)对应的值
     * 
     * @author Sun
     */
    public class JobResultInfo {
        public var paramUrl:String;
    }
}
