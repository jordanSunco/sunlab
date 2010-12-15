package utils {
    import mx.rpc.Responder;

    /**
     * 默认的Responder, 只关注处理结果, 错误处理只是简单的trace错误信息便于调试
     * 
     * @author Sun
     */
    public class DefaultResponder extends Responder {
        public function DefaultResponder(result:Function) {
            super(result, traceFault);
        }

        /**
         * TODO 实现一个统一的公共错误处理函数 
         */
        public function traceFault(info:Object):void {
            trace(info);
        }
    }
}
