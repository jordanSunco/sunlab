package com.monkey.arcgis.gp {
    /**
     * 提交异步GP Task每一个Job的信息.
     * 由于是异步的每次提交都会产生一个新的Job, 因此需要持续检测单个Job的执行状态,
     * 直到Job状态为STATUS_SUCCEEDED时才能去取执行结果.
     * 
     * @author Sun
     * @see com.esri.ags.tasks.JobInfo
     */
    public class JobInfo {
        public static const STATUS_FAILED:String = "esriJobFailed";
        public static const STATUS_SUCCEEDED:String = "esriJobSucceeded";
        public static const STATUS_TIMED_OUT:String = "esriJobTimedOut";

        public var jobId:String;
        public var jobStatus:String;
        public var results:Object;
        public var messages:Array;
    }
}
