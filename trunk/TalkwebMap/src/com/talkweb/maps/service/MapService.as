package com.talkweb.maps.service {
    import com.esri.ags.Map;
    import com.esri.ags.SpatialReference;
    import com.esri.ags.geometry.Geometry;
    import com.esri.ags.tasks.ExecuteResult;
    import com.esri.ags.tasks.FeatureSet;
    import com.esri.ags.tasks.GeometryService;
    import com.esri.ags.tasks.Geoprocessor;
    import com.esri.ags.tasks.IdentifyParameters;
    import com.esri.ags.tasks.IdentifyTask;
    import com.esri.ags.tasks.Query;
    import com.esri.ags.tasks.QueryTask;
    import com.esri.ags.tasks.RouteParameters;
    import com.esri.ags.tasks.RouteSolveResult;
    import com.esri.ags.tasks.RouteTask;
    import com.esri.ags.toolbars.Draw;
    import com.talkweb.maps.config.MapConfig;
    
    import mx.rpc.AsyncResponder;
    
    /**
     * 地图通用服务
     */
    public class MapService {
        private var _map:Map;
        private var _draw:Draw;
        
        public function get map():Map {
            return _map;
        }
        
        public function set map(_map:Map):void {
            this._map = _map;
        }
        
        public function get draw():Draw {
            return _draw;
        }
        
        public function set draw(_draw:Draw):void {
            this._draw = _draw;
        }
        
        /**
         * 单图层查询
         * 
         * @param mapServiceUrl 地图图层服务地址
         * @param layerId 图层索引ID
         * @param geometry 做查询操作的空间要素
         * @param text 模糊查询(like)图层中的显示字段(display field)
         * @param where SQL查询where语句
         * @param callback 查询完成后的回调函数(featureSet:FeatureSet, token:Object)
         * @param token 回调函数中的额外参数引用
         * @param outFields 返回数据字段(默认返回所有字段)
         * @param isReturnGeometry 查询结果中是否包含空间要素(默认包含)
         * 
         * @see com.esri.ags.tasks.Query
         * @see com.esri.ags.tasks.FeatureSet
         */
        protected function query(mapServiceUrl:String, layerId:int,
                geometry:Geometry, text:String, where:String, callback:Function, 
                token:Object = null, outFields:Array = null,
                isReturnGeometry:Boolean = true):void {
            // 查询参数
            var queryParam:Query = new Query();
            queryParam.geometry = geometry;
            queryParam.outFields = outFields ? outFields : MapConfig.RETURN_ALL_FIELDS;
            queryParam.returnGeometry = isReturnGeometry;
            queryParam.text = text;
            queryParam.where = where;
            
            // 查询任务
            var queryTask:QueryTask = new QueryTask(mapServiceUrl+layerId);
            queryTask.showBusyCursor = true;
            
            queryTask.execute(queryParam, new AsyncResponder(onQueryResult, onQueryFault, token));
            function onQueryResult(featureSet:FeatureSet, token:Object):void {
                callback(featureSet, token);
            }
            function onQueryFault(info:Object, token:Object):void {
                trace("Query Problem", info);
            }
        }
        
        /**
         * 通过SQL语句执行空间图层查询
         * 
         * @see com.talkweb.maps.service.MapService.query
         */
        public function queryByWhereClause(mapServiceUrl:String, layerId:int,
                where:String, callback:Function, token:Object = null, 
                outFields:Array = null, isReturnGeometry:Boolean = true):void {
            query(mapServiceUrl, layerId, null, null, where, callback, token,
                outFields, isReturnGeometry);
        }
        
        /**
         * 通过LIKE语句执行空间图层查询, LIKE字段为图层的显示字段(display field)
         * 
         * @see com.talkweb.maps.service.MapService.query
         */
        public function queryByLike(mapServiceUrl:String, layerId:int,
                text:String, callback:Function, token:Object = null,
                outFields:Array = null, isReturnGeometry:Boolean = true):void {
            query(mapServiceUrl, layerId, null, text, null, callback, token,
                outFields, isReturnGeometry);
        }
        
        /**
         * 通过空间要素执行空间图层查询
         * 
         * @see com.talkweb.maps.service.MapService.query
         */
        public function queryByGeometry(mapServiceUrl:String, layerId:int,
                geometry:Geometry, callback:Function, token:Object = null,
                outFields:Array = null, isReturnGeometry:Boolean = true):void {
            query(mapServiceUrl, layerId, geometry, null, null, callback, token,
                outFields, isReturnGeometry);
        }
        
        /**
         * 多图层查询
         * 
         * @param mapServiceUrl 地图图层服务地址
         * @param layerIds 多个图层索引ID
         * @param geometry 做查询操作的空间要素
         * @param callback 查询完成后的回调函数(indentifyResultArray:Array, token:Object)
         * @param token 回调函数中的额外参数引用
         * @param layerOption 查询图层方式(默认查询所有提供的图层)
         * @param tolerance 查询容差(默认为2)
         * @param isReturnGeometry 查询结果中是否包含空间要素(默认包含)
         * 
         * @see com.esri.ags.tasks.IdentifyParameters
         * @see com.esri.ags.tasks.IdentifyResult
         */
        public function identify(mapServiceUrl:String, layerIds:Array,
                geometry:Geometry, callback:Function = null, token:Object = null,
                layerOption:String = IdentifyParameters.LAYER_OPTION_ALL,
                tolerance:Number = 2, isReturnGeometry:Boolean = true):void {
            // 查询参数
            var identifyParam:IdentifyParameters = new IdentifyParameters();
            identifyParam.mapExtent = this._map.extent;
            identifyParam.width = this._map.width;
            identifyParam.height = this._map.height;
            
            identifyParam.layerIds = layerIds;
            identifyParam.layerOption = layerOption;
            identifyParam.geometry = geometry;
            identifyParam.tolerance = tolerance;
            identifyParam.returnGeometry = isReturnGeometry;
            
            // 查询任务
            var identifyTask:IdentifyTask = new IdentifyTask(mapServiceUrl);
            identifyTask.showBusyCursor = true;
            
            identifyTask.execute(identifyParam, new AsyncResponder(onIndentifyResult, onIndentifyFault, token));
            function onIndentifyResult(indentifyResultArray:Array, token:Object):void {
                callback(indentifyResultArray, token);
            }
            function onIndentifyFault(info:Object, token:Object):void {
                trace("Identify Problem", info);
            }
        }
        
        /**
         * 路径分析
         * 
         * @param routeServiceUrl 路径服务地址
         * @param stops 途经点或者完整的路径分析参数
         * @param callback 路径分析完成后的回调函数(routeSolveResult:RouteSolveResult, token:Object)
         * @param token 回调函数中的额外参数引用
         * 
         * @see com.esri.ags.tasks.RouteParameters
         * @see com.esri.ags.tasks.RouteSolveResult
         */
        public function route(routeServiceUrl:String, stops:Object, 
                callback:Function, token:Object = null):void {
            var routeParam:RouteParameters = new RouteParameters();
            
            if (stops is RouteParameters) { // 如果是一个路径分析参数, 则直接使用
                routeParam = stops as RouteParameters;
            } else { // 只是设置路径分析的停靠点
                routeParam.stops = stops;
            }
            
            var routeTask:RouteTask = new RouteTask(routeServiceUrl);
            routeTask.showBusyCursor = true;
            
            routeTask.solve(routeParam, new AsyncResponder(onSolveResult, onSolveFault, token));
            function onSolveResult(routeSolveResult:RouteSolveResult, token:Object):void {
                callback(routeSolveResult, token);
            }
            function onSolveFault(info:Object, token:Object):void {
                trace("Route Problem", info);
            }
        }
        
        /**
         * GP服务
         * 
         * @param gpServiceUrl GP服务地址
         * @param gpParams GP参数
         * @param callback GP服务完成后的回调函数(executeResult:ExecuteResult, token:Object)
         * @param token 回调函数中的额外参数引用
         * 
         * @see com.esri.ags.tasks.ExecuteResult
         */
        public function geoprocess(gpServiceUrl:String, gpParams:Object,
                callback:Function, token:Object = null):void {
            var gp:Geoprocessor = new Geoprocessor(gpServiceUrl);
            gp.showBusyCursor = true;
            
            gp.execute(gpParams, new AsyncResponder(onGpResult, onGpFault, token));
//            gp.submitJob(params, new AsyncResponder(onGpResult, onGpFault, token));
            function onGpResult(executeResult:ExecuteResult, token:Object):void {
                callback(executeResult, token);
            }
            function onGpFault(info:Object, token:Object):void {
                trace("Geoprocess sync Problem", info);
            }
        }
        
        /**
         * 测距
         * 
         * @param graphics 需要测距的图形要素
         * @param callback 测距完成后的回调函数(lengths:Array, token:Object)
         * @param token 回调函数中的额外参数引用
         * @param wkid 空间索引标准(默认为32618)
         */
        public function measureDistance(graphics:Array, callback:Function,
                token:Object = null, wkid:Number = MapConfig.DEFAULT_MEASURE_WIKI):void {
            // 地理信息服务
            var geometryService:GeometryService = new GeometryService(MapConfig.GEOMETRY_SERVICE_URL);
            geometryService.showBusyCursor = true;
            
            // project
            geometryService.project(graphics, new SpatialReference(wkid), new AsyncResponder(onProjectResult, onProjectFault, token));
            // project complete
            function onProjectResult(graphics:Array, token:Object):void {
                // length
                geometryService.lengths(graphics, new AsyncResponder(onLengthsResult, onLengthsFault, token));
                // length complete
                function onLengthsResult(lengths:Array, token:Object):void {
                    callback(lengths, token);
                }
                function onLengthsFault(info:Object, token:Object):void {
                    trace("measureLengths length Problem", info);
                }
            }
            function onProjectFault(info:Object, token:Object):void {
                trace("measureLengths project Problem", info);
            }
        }
        
        /**
         * 测面
         * 
         * @param graphics 需要测面的图形要素
         * @param callback 测面完成后的回调函数(areaLengths:Object, token:Object)
         * @param token 回调函数中的额外参数引用
         */
        public function measureArea(graphics:Array, callback:Function,
                token:Object = null):void {
            // 地理信息服务
            var geometryService:GeometryService = new GeometryService(MapConfig.GEOMETRY_SERVICE_URL);
            geometryService.showBusyCursor = true;
            
            // simplify
            geometryService.simplify(graphics, new AsyncResponder(onSimplifyResult, onSimplifyFault, token));
            // simplify complete
            function onSimplifyResult(graphics:Array, token:Object):void {
                // area&length
                geometryService.areasAndLengths(graphics, new AsyncResponder(onAreasAndLengthsResult, onAreasAndLengthsFault, token));
                // area&length complete
                function onAreasAndLengthsResult(areaLengths:Object, token:Object):void {
                    callback(areaLengths, token);
                }
                function onAreasAndLengthsFault(info:Object, token:Object):void {
                    trace("measureArea area&length Problem", info);
                }
            }
            function onSimplifyFault(info:Object, token:Object):void {
                trace("measureArea simplify Problem", info);
            }
        }
    }
}
