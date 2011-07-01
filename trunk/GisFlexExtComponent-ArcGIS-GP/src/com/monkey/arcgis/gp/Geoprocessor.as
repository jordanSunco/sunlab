package com.monkey.arcgis.gp {
    import com.adobe.serialization.json.JSON;
    import com.darronschall.serialization.ObjectTranslator;
    import com.monkey.arcgis.FeatureSetUtil;
    
    import flash.net.URLRequestMethod;
    
    import mx.rpc.AsyncResponder;
    import mx.rpc.AsyncToken;
    import mx.rpc.IResponder;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.http.HTTPService;
    
    import org.openscales.core.feature.Feature;

    /**
     * 通过ArcGIS Server REST API执行GP服务(GPServer)的Task
     * 
     * @author Sun
     */
    public class Geoprocessor {
        private static const JSON_RESULT_FORMAT:String = "json";
        private static const EXECUTE_API:String = "execute";

        private var httpService:HTTPService;

        private var _executeLastResult:ExecuteResult;

        public function Geoprocessor(gpTaskUrl:String) {
            this.httpService = new HTTPService();
            this.httpService.url = gpTaskUrl;
            this.httpService.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
        }

        /**
         * 执行同步的GP Task
         * 
         * @param inputParameters GP Task所需的输入参数
         * @param responder
         * @return AsyncToken
         */
        public function execute(inputParameters:Object,
                responder:IResponder):AsyncToken {
            prepareTask(inputParameters);
            this.httpService.url = getApiUrl(this.httpService.url, EXECUTE_API);

            var asyncToken:AsyncToken = this.httpService.send(inputParameters);
            asyncToken.addResponder(new AsyncResponder(handleExecuteResult,
                defaultFault, responder));

            return asyncToken;
        }

        private function prepareTask(inputParameters:Object):void {
            serializeInputParameterValue(inputParameters);
            // 告诉GP服务任务执行结果返回JSON格式数据
            inputParameters.f = JSON_RESULT_FORMAT;
            httpGetOrPostAccordingToInputParametersContentLength(inputParameters);
        }

        /**
         * 对输入参数中的复杂数据类型进行序列化, 以确保提供GP能够识别的数据.
         * 例如参数中包含Feature, 则需要将其转为ArcGIS FeatureSet的JSON字符串格式.
         */
        private function serializeInputParameterValue(inputParameters:Object):void {
            for (var propertyName:String in inputParameters) {
                var value:Object = inputParameters[propertyName];
                serializeValueByType(inputParameters, propertyName, value);
            }
        }

        private function serializeValueByType(inputParameters:Object,
                propertyName:String, value:Object):void {
            if (value is Vector.<Feature>) {
                inputParameters[propertyName] = features2Json(value);
            } else if (value is Feature) {
                var features:Vector.<Feature> = new Vector.<Feature>();
                features.push(value);

                inputParameters[propertyName] = features2Json(features);
            }
        }

        private function features2Json(value:Object):String {
            return FeatureSetUtil.convertToFeatureSetJson(value as Vector.<Feature>);
        }

        /**
         * TODO 根据inputParameters数据量大小选择GET还是POST, ArcGIS本身有这样的机制
         */
        private function httpGetOrPostAccordingToInputParametersContentLength(inputParameters:Object):void {
            this.httpService.method = URLRequestMethod.POST;
        }

        private function getApiUrl(baseUrl:String, api:String):String {
            var apiUrl:String = "";

            if (baseUrl.lastIndexOf("/") == (baseUrl.length - 1)) {
                apiUrl = baseUrl + api;
            } else {
                apiUrl = baseUrl + "/" + api;
            }

            return apiUrl;
        }

        private function handleExecuteResult(event:ResultEvent,
                responder:IResponder):void {
            var executeResultObject:Object = JSON.decode(event.result.toString());
            var executeResult:ExecuteResult = ObjectTranslator.objectToInstance(
                executeResultObject, ExecuteResult);

            var parameterValues:Array = [];
            for each (var parameterValueObject:Object in executeResult.results) {
                var parameterValue:ParameterValue = ObjectTranslator.objectToInstance(
                    parameterValueObject, ParameterValue);
                convertData(parameterValue);
                parameterValues.push(parameterValue);
            }

            executeResult.results = parameterValues;
            responder.result(executeResult);

            this._executeLastResult = executeResult;
        }

        /**
         * 转换特有数据, 例如ArcGIS特有的FeatureSet
         * 
         * @param parameterValue
         */
        private function convertData(parameterValue:ParameterValue):void {
            if (parameterValue.dataType == GpDataType.FEATURE_SET_DATA_TYPE) {
                // 将返回参数中的值(ArcGIS FeatureSet)转成OpenScales Feature
                parameterValue.value = FeatureSetUtil.convertFromFeatureSet(
                    parameterValue.value);
            }
        }

        public function get executeLastResult():ExecuteResult {
            return this._executeLastResult;
        }

        public function getExecuteResultValue(paramName:String):Object {
            var value:Object = null;

            for each (var parameterValue:ParameterValue in _executeLastResult.results) {
                if (parameterValue.paramName == paramName) {
                    value = parameterValue.value;
                    break;
                }
            }

            return value;
        }

        private function defaultFault(info:Object, responder:IResponder):void {
            responder.fault(info);
        }
    }
}
