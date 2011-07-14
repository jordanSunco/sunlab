package com.monkey.supermap.web.spatialanalyst {
    import com.adobe.serialization.json.JSON;
    import com.darronschall.serialization.ObjectTranslator;
    import com.monkey.GeometryDialect;
    import com.monkey.supermap.SuperMapGeometryDialect;
    import com.monkey.supermap.web.spatialanalyst.buffer.BufferParameter;
    import com.monkey.supermap.web.spatialanalyst.buffer.BufferResult;
    import com.monkey.supermap.web.spatialanalyst.isoline.IsolineParameter;
    import com.monkey.supermap.web.spatialanalyst.isoline.IsolineResult;
    import com.monkey.supermap.web.spatialanalyst.overlay.OverlayParameter;
    
    import flash.net.URLRequestMethod;
    
    import mx.rpc.AsyncResponder;
    import mx.rpc.AsyncToken;
    import mx.rpc.IResponder;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.http.HTTPService;
    
    import org.openscales.geometry.Geometry;
    import org.openscales.geometry.Polygon;

    /**
     * SuperMap的空间分析服务
     * 
     * @author Sun
     * @see com.supermap.services.components.SpatialAnalyst
     * @see http://support.supermap.com.cn/DataWarehouse/WebDocHelp/6.0/iSever6R/mergedProjects/SuperMapiServerRESTAPI/root/spatialanalyst/spatialanalyst.htm iServer Spatial Analyst REST API
     */
    public class SpatialAnalystService {
        private static const CONTENT_TYPE_JSON:String = "application/json";

        private static const BUFFER_API:String = "buffer.json";
        private static const OVERLAY_API:String = "overlay.json";
        private static const ISOLINE_API:String = "isoline.json";

        /**
         * 如果在做分析时添加returnContent=true请求参数, 则会立即返回分析结果, 而不是返回结果的URI,
         * 再读取该URI中的内容才是分析结果
         */
        private static const RETURN_CONTENT:String = "returnContent=true";

        private var spatialAnalystServiceUrl:String;
        private var httpService:HTTPService;
        private var geometryDialect:GeometryDialect;

        private var _bufferLastResult:BufferResult;
        private var _isolineLastResult:IsolineResult;

        /**
         * 空间分析服务
         * 
         * @param spatialAnalystServiceUrl 空间分析的URL地址必须指定到确切的分析级别, 例如基于几何对象的空间分析, 则需指定URL为: http://a.com/iserver/services/{空间分析服务的名称}/restjsr/spatialanalyst/geometry
         */
        public function SpatialAnalystService(spatialAnalystServiceUrl:String) {
            this.spatialAnalystServiceUrl = spatialAnalystServiceUrl;

            this.httpService = new HTTPService();
            this.httpService.method = URLRequestMethod.POST;
            this.httpService.contentType = CONTENT_TYPE_JSON;
            this.httpService.resultFormat = HTTPService.RESULT_FORMAT_TEXT;

            this.geometryDialect = new SuperMapGeometryDialect();
        }

        public function geometryBuffer(bufferParameter:BufferParameter,
                responder:IResponder):AsyncToken {
            bufferParameter.sourceGeometry = convert2SuperMapGeometry(
                bufferParameter.sourceGeometry);

            return sendApiRequest(BUFFER_API, bufferParameter,
                handleBufferResult, responder);
        }

        private function convert2SuperMapGeometry(geometry:Object):Object {
            return this.geometryDialect.toGeometry(geometry as Geometry);
        }

        private function sendApiRequest(api:String, param:Object,
                resultHandler:Function, responder:IResponder):AsyncToken {
            this.httpService.url = getApiUrl(this.spatialAnalystServiceUrl, api);

            var asyncToken:AsyncToken = this.httpService.send(JSON.encode(param));
            asyncToken.addResponder(new AsyncResponder(resultHandler,
                defaultFault, responder));

            return asyncToken;
        }

        private function handleBufferResult(event:ResultEvent,
                responder:IResponder):void {
            this._bufferLastResult = getBufferResult(event.result.toString());
            this._bufferLastResult.resultGeometry = convert2Geometry(
                this._bufferLastResult.resultGeometry);

            if (this._bufferLastResult.succeed) {
                responder.result(this._bufferLastResult);
            } else {
                responder.fault(this._bufferLastResult);
            }
        }

        private function getBufferResult(json:String):BufferResult {
            var bufferResultObject:Object = JSON.decode(json);
            var bufferResult:BufferResult = ObjectTranslator.objectToInstance(
                bufferResultObject, BufferResult);

            return bufferResult;
        }

        private function convert2Geometry(superMapGeometryObject:Object):Geometry {
            return this.geometryDialect.getGeometryFromObject(superMapGeometryObject);
        }

        public function getBufferResultGeometry():Polygon {
            return this._bufferLastResult.resultGeometry as Polygon;
        }

        private function getApiUrl(baseUrl:String, api:String):String {
            var apiUrl:String = "";

            if (baseUrl.lastIndexOf("/") == (baseUrl.length - 1)) {
                apiUrl = baseUrl + api;
            } else {
                apiUrl = baseUrl + "/" + api;
            }

            return apiUrl + "?" + RETURN_CONTENT;
        }

        private function defaultFault(info:Object, responder:IResponder):void {
            responder.fault(info);
        }

        public function geometryOverlay(overlayParameter:OverlayParameter,
                responder:IResponder):AsyncToken {
            overlayParameter.sourceGeometry = convert2SuperMapGeometry(
                overlayParameter.sourceGeometry);
            overlayParameter.operateGeometry = convert2SuperMapGeometry(
                overlayParameter.operateGeometry);

            return sendApiRequest(OVERLAY_API, overlayParameter,
                handleOverlayResult, responder);
        }

        /**
         * 叠加分析返回的数据格式和缓冲区分析是一样的, 因此采用相同的处理机制
         */
        private function handleOverlayResult(event:ResultEvent,
                responder:IResponder):void {
            handleBufferResult(event, responder);
        }

        public function getOverlayResultGeometry():Geometry {
            return getBufferResultGeometry();
        }

        public function geometryIsoline(isolineParameter:IsolineParameter,
                responder:IResponder):AsyncToken {
            return sendApiRequest(ISOLINE_API, isolineParameter,
                handleIsolineResult, responder);
        }

        public function handleIsolineResult(event:ResultEvent,
                responder:IResponder):void {
            this._isolineLastResult = getIsolineResult(event.result.toString());
            this._isolineLastResult.recordset = convertRecordsetFeatures(
                this._isolineLastResult.recordset);

            if (this._isolineLastResult.succeed) {
                responder.result(this._isolineLastResult);
            } else {
                responder.fault(this._isolineLastResult);
            }
        }

        private function getIsolineResult(json:String):IsolineResult {
            var isolineResultObject:Object = JSON.decode(json);
            var isolineResult:IsolineResult = ObjectTranslator.objectToInstance(
                isolineResultObject, IsolineResult);

            return isolineResult;
        }

        private function convertRecordsetFeatures(recordsetObject:Object):Recordset {
            var recordset:Recordset = ObjectTranslator.objectToInstance(
                recordsetObject, Recordset);
//            recordset.features = convert2Features(recordset.features);

            return recordset;
        }

        private function convert2Features(features:Array):Array {
            // TODO 转换SuperMap Feature -> OpenScales Feature
            return null;
        }

        public function getIsolineResultFeatures():Array {
            // TODO 从IsolineResult中获取Features
            return null;
        }
    }
}
