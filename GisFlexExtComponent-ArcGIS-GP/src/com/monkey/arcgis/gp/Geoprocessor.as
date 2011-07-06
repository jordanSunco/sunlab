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

        private static const CHECK_JOB_STATUS_INTERVAL:uint = 1000;

        private var gpTaskUrl:String;
        private var httpService:HTTPService;

        private var _executeLastResult:ExecuteResult;

        private var lastJobInfo:JobInfo;

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
            this._executeLastResult = getExecuteResult(event.result.toString());
            convertExecuteResultData(this._executeLastResult);
            responder.result(this._executeLastResult);
        }

        private function getExecuteResult(json:String):ExecuteResult {
            var executeResultObject:Object = JSON.decode(json);
            var executeResult:ExecuteResult = ObjectTranslator.objectToInstance(
                executeResultObject, ExecuteResult);
            return executeResult;
        }

        private function convertExecuteResultData(executeResult:ExecuteResult):void {
            for (var i:uint = 0, length:uint = executeResult.results.length; i < length; i++) {
                var parameterValueObject:Object = executeResult.results[i];
                var parameterValue:ParameterValue = convertParameterValue(
                    parameterValueObject);

                executeResult.results[i] = parameterValue;
            }
        }

        /**
         * 根据ParameterValue的类型转换GP输出的数据为OpenScales中的数据格式.
         * 例如ArcGIS特有的FeatureSet转变为Vector.&lt;Feature&gt;
         * 
         * @param parameterValueObject
         * @return 转换了数据格式后的ParameterValue
         */
        private function convertParameterValue(parameterValueObject:Object):ParameterValue {
            var parameterValue:ParameterValue = ObjectTranslator.objectToInstance(
                parameterValueObject, ParameterValue);

            if (parameterValue.dataType == GpDataType.FEATURE_SET_DATA_TYPE) {
                // 将返回参数中的值(ArcGIS FeatureSet)转成OpenScales Feature
                parameterValue.value = FeatureSetUtil.convertFromFeatureSet(
                    parameterValue.value);
            }

            return parameterValue;
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
            this.lastJobInfo = getJobInfo(event.result.toString());
            checkJobFinished(this.lastJobInfo, responder);
        }

        private function getJobInfo(json:String):JobInfo {
            var jobInfoObject:Object = JSON.decode(json);
            var jobInfo:JobInfo = ObjectTranslator.objectToInstance(
                jobInfoObject, JobInfo);

            return jobInfo;
        }

        private function checkJobFinished(jobInfo:JobInfo, responder:IResponder):void {
            if (jobInfo.jobStatus == JobInfo.STATUS_SUCCEEDED) {
                responder.result(jobInfo);
            } else if (jobInfo.jobStatus == JobInfo.STATUS_FAILED
                    || jobInfo.jobStatus == JobInfo.STATUS_TIMED_OUT) {
                trace(jobInfo.jobId, jobInfo.jobStatus, jobInfo.messages);
                responder.fault(jobInfo);
            } else {
                setTimeout(function ():void {
                    checkJobStatus(jobInfo.jobId, responder);
                }, CHECK_JOB_STATUS_INTERVAL);
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
            var checkJobStatusService:HTTPService = getCheckJobStatusService(jobId);

            var checkJobParameter:Object = {};
            prepareTask(checkJobParameter, false, checkJobStatusService);

            var asyncToken:AsyncToken = checkJobStatusService.send(checkJobParameter);
            asyncToken.addResponder(new AsyncResponder(handleJobInfoResult,
                defaultFault, responder));
        }

        private function getCheckJobStatusService(jobId:String):HTTPService {
            var checkJobStatusHttpService:HTTPService = new HTTPService();
            checkJobStatusHttpService.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
            checkJobStatusHttpService.url = getApiUrl(this.gpTaskUrl,
                CHECK_JOB_STATUS_API) + "/" + jobId;

            return checkJobStatusHttpService;
        }

        /**
         * 异步GP Task Job执行完成后, 获取GP的输出参数
         * 
         * @param paramName GP的输出参数名
         * @param responder 由于获取Job的结果是异步的, 需要指定回调函数
         * 
         * @see http://services.arcgisonline.com/ArcGIS/SDK/REST/gpresult.html
         */
        public function getJobResultValue(paramName:String,
                responder:IResponder):void {
            var getJobResultService:HTTPService = getGetJobResultService(
                this.lastJobInfo, paramName);

            var getJobResultParameter:Object = {};
            prepareTask(getJobResultParameter, false, getJobResultService);

            var asyncToken:AsyncToken = getJobResultService.send(getJobResultParameter);
            asyncToken.addResponder(new AsyncResponder(handleJobResult,
                defaultFault, responder));
        }

        private function getGetJobResultService(jobInfo:JobInfo, paramName:String):HTTPService {
            var getJobResultService:HTTPService = new HTTPService();
            getJobResultService.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
            getJobResultService.url = getApiUrl(this.gpTaskUrl, CHECK_JOB_STATUS_API)
                + "/" + jobInfo.jobId + "/"
                + getResultUrl(jobInfo, paramName);

            return getJobResultService;
        }

        private function getResultUrl(jobInfo:JobInfo, paramName:String):String {
            var jobResultInfo:JobResultInfo = ObjectTranslator.objectToInstance(
                jobInfo.results[paramName], JobResultInfo);

            return jobResultInfo.paramUrl;
        }

        private function handleJobResult(event:ResultEvent,
                responder:IResponder):void {
            var parameterValueObject:Object = JSON.decode(event.result.toString());
            var parameterValue:ParameterValue = convertParameterValue(
                parameterValueObject);

            responder.result(parameterValue.value);
        }
    }
}
