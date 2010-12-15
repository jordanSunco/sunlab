package maps.business {
    import com.esri.ags.tasks.Query;
    import com.esri.ags.tasks.QueryTask;
    
    import mx.rpc.IResponder;

    /**
     * 空间操作业务(例如空间查询操作...)的代理, 返回结果可以复用
     * 
     * @author Sun
     */
    public class SpatialBusinessDelegate {
        private var responder:IResponder;

        public function SpatialBusinessDelegate(responder:IResponder) {
            this.responder = responder;
        }

        public function queryLayer(layerUrl:String, queryParameter:Query):void {
            var queryTask:QueryTask = new QueryTask(layerUrl);
            queryTask.execute(queryParameter, responder);
        }
    }
}
