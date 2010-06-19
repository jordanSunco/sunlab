package info.flexer {
    import flash.external.ExternalInterface;
    import mx.core.Application;
 
    public class QueryString {
        private var _queryStringFromUrl:String;
        private var _paramsFromUrl:Object;
        private var _noOfParamsFromUrl:uint = 0;

        private var _paramsFromSwfObject:Object;
        private var _noOfParamsFromSwfObject:uint = 0;

        private var _params:Object;
        private var _noOfParams:uint = 0;

        /**
         * getters and setters for the general array containing both
         * params from URL and from SWF Object
         */
        public function get parameters():Object {
            return _params;
        }

        public function get noOfParams():uint {
            return _noOfParams;
        }

        public function QueryString() {
            readQueryString();
            getParamsFromSwf();
            combineParams();
        }

        /**
         * method used to read parameters from SWF Object
         */
        private function getParamsFromSwf():void {
            _paramsFromSwfObject = mx.core.Application.application.parameters;
        }

        /**
         * method used to read URL query string
         */
        private function readQueryString():void {
            _paramsFromUrl = {};
            try {
                _queryStringFromUrl = ExternalInterface.call("window.location.search.substring", 1);

                if(_queryStringFromUrl) {
                    var params:Array = _queryStringFromUrl.split('&');
                    var length:uint = params.length;
                    _noOfParamsFromUrl = length;

                    for (var i:uint=0, index:int=-1; i < length; i++) {
                        var kvPair:String = params[i];
                        if ((index = kvPair.indexOf("=")) > 0) {
                            var key:String = kvPair.substring(0,index);
                            var value:String = kvPair.substring(index+1);
                            _paramsFromUrl[key] = value;
                        }
                    }
                }
            } catch(e:Error) {
                trace("Some error occured. ExternalInterface doesn't work in Standalone player.");
            }
        }
     
        /**
         * method used to combine the 2 associative arrays
         */
        private function combineParams():void {
            if (_noOfParamsFromUrl > 0) {
                _params = _paramsFromUrl;

                for (var p:String in _paramsFromUrl) {
                    for (var p1:String in _paramsFromSwfObject) {
                        _params[p1] = _paramsFromSwfObject[p1];
                    }
                }
            } else {
                _params = _paramsFromSwfObject;
            }

            //  Count the number of parameters
            _noOfParams=0;
            for (var pp:String in _params) {
                _noOfParams++;
            }
        }
    }
}