package com.monkey.arcgis.gp {
    import com.adobe.serialization.json.JSON;
    import com.darronschall.serialization.ObjectTranslator;
    import com.monkey.arcgis.FeatureSetUtil;
    
    import flash.net.URLRequestMethod;
    import flash.utils.setTimeout;
    
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
        private static const SUBMIT_JOB_API:String = "submitJob";
        private static const CHECK_JOB_STATUS_API:String = "jobs";

        private var gpTaskUrl:String;
        private var httpService:HTTPService;

        private var _executeLastResult:ExecuteResult;

        public function Geoprocessor(gpTaskUrl:String) {
            this.gpTaskUrl = gpTaskUrl;

            this.httpService = new HTTPService();
            this.httpService.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
        }

        /**
         * 执行同步的GP Task
         * 
         * @param inputParameters GP Task所需的输入参数
         * @param responder
         * @return AsyncToken
         * 
         * @see http://services.arcgisonline.com/ArcGIS/SDK/REST/gpexecute.html
         */
        public function execute(inputParameters:Object,
                responder:IResponder):AsyncToken {
            this.httpService.url = getApiUrl(this.gpTaskUrl, EXECUTE_API);
            prepareTask(inputParameters, true, this.httpService);

            var asyncToken:AsyncToken = this.httpService.send(inputParameters);
            asyncToken.addResponder(new AsyncResponder(handleExecuteResult,
                defaultFault, responder));

            return asyncToken;
        }

        /**
         * 执行GP Task之前的准备工作, 例如序列化参数, 追加特殊参数, 是发生GET请求还是POST?
         * 
         * @param inputParameters GP的输入参数
         * @param serialize 是否序列化请求参数的值, 例如将Feature转成FeatureSet JSON
         * @param httpService
         */
        private function prepareTask(inputParameters:Object,
                serialize:Boolean, httpService:HTTPService):void {
            if (serialize) {
                serializeInputParameterValue(inputParameters);
            }
            // 告诉GP服务任务执行结果返回JSON格式数据
            inputParameters.f = JSON_RESULT_FORMAT;

            httpGetOrPostAccordingToInputParametersContentLength(
                inputParameters, httpService);
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
        private function httpGetOrPostAccordingToInputParametersContentLength(
                inputParameters:Object, httpService:HTTPService):void {
            httpService.method = URLRequestMethod.POST;
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
            this._executeLastResult = executeResult;

            responder.result(executeResult);
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

            for each (var parameterValue:ParameterValue in this._executeLastResult.results) {
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

        /**
         * 提交异步的GP Task
         * 
         * @param inputParameters GP Task所需的输入参数
         * @param responder
         * @return AsyncToken
         * 
         * @see http://services.arcgisonline.com/ArcGIS/SDK/REST/gpsubmit.html
         */
        public function submitJob(inputParameters:Object, responder:IResponder):AsyncToken {
            this.httpService.url = getApiUrl(this.gpTaskUrl, SUBMIT_JOB_API);
            prepareTask(inputParameters, true, this.httpService);

            var asyncToken:AsyncToken = this.httpService.send(inputParameters);
            asyncToken.addResponder(new AsyncResponder(handleJobInfoResult,
                defaultFault, responder));

            return asyncToken;
        }

        private function handleJobInfoResult(event:ResultEvent,
                responder:IResponder):void {
            var jobInfoObject:Object = JSON.decode(event.result.toString());
            var jobInfo:JobInfo= ObjectTranslator.objectToInstance(
                jobInfoObject, JobInfo);

            if (jobInfo.jobStatus == JobInfo.STATUS_SUCCEEDED) {
                responder.result(jobInfo);
            } else if (jobInfo.jobStatus == JobInfo.STATUS_FAILED
                    || jobInfo.jobStatus == JobInfo.STATUS_TIMED_OUT) {
                trace(jobInfo.jobId, jobInfo.jobStatus, jobInfo.messages);
            } else {
                setTimeout(function ():void {
                    checkJobStatus(jobInfo.jobId, responder);
                }, 1000);
            }
        }

        /**
         * 检测Job执行的状态, 看其在运行中还是已经执行成功?
         * 
         * @param jobId
         * @param responder
         * 
         * @see http://services.arcgisonline.com/ArcGIS/SDK/REST/gpjob.html
         */
        private function checkJobStatus(jobId:String, responder:IResponder):void {
            var checkJobHttpService:HTTPService = new HTTPService();
            checkJobHttpService.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
            checkJobHttpService.url = getApiUrl(this.gpTaskUrl,
                CHECK_JOB_STATUS_API) + "/" + jobId;

            var checkJobParameter:Object = {};
            prepareTask(checkJobParameter, false, checkJobHttpService);

            var asyncToken:AsyncToken = checkJobHttpService.send(checkJobParameter);
            asyncToken.addResponder(new AsyncResponder(handleJobInfoResult,
                defaultFault, responder));
        }

        /**
         * 异步GP Task Job执行完成后, 获取GP的输出参数
         * 
         * @param jobInfo Job执行完成后的JobInfo
         * @param paramName GP的输出参数名
         * @param responder
         * 
         * @see http://services.arcgisonline.com/ArcGIS/SDK/REST/gpresult.html
         */
        public function getJobResultValue(jobInfo:JobInfo, paramName:String,
                responder:IResponder):void {
            var getJobResultHttpService:HTTPService = new HTTPService();
            getJobResultHttpService.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
            getJobResultHttpService.url = getApiUrl(this.gpTaskUrl, CHECK_JOB_STATUS_API)
                + "/" + jobInfo.jobId + "/"
                + getResultUrl(jobInfo, paramName);

            var checkJobParameter:Object = {};
            prepareTask(checkJobParameter, false, getJobResultHttpService);

            var asyncToken:AsyncToken = getJobResultHttpService.send(checkJobParameter);
            asyncToken.addResponder(new AsyncResponder(handleJobResult,
                defaultFault, responder));
        }

        private function getResultUrl(jobInfo:JobInfo, paramName:String):String {
            var jobResultInfo:JobResultInfo = ObjectTranslator.objectToInstance(
                jobInfo.results[paramName], JobResultInfo);

            return jobResultInfo.paramUrl;
        }

        private function handleJobResult(event:ResultEvent,
                responder:IResponder):void {
            var parameterValueObject:Object = JSON.decode(event.result.toString());
            var parameterValue:ParameterValue = ObjectTranslator.objectToInstance(
                parameterValueObject, ParameterValue);
            convertData(parameterValue);

            responder.result(parameterValue.value);
        }
    }
}
