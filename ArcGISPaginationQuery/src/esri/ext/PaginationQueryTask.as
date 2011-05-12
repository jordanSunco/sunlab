/*
 * WTFPL
 */

package esri.ext {
    import com.esri.ags.tasks.FeatureSet;
    import com.esri.ags.tasks.Query;
    import com.esri.ags.tasks.QueryTask;
    
    import mx.rpc.AsyncResponder;
    import mx.rpc.IResponder;
    
    /**
     * 分页查询空间数据.
     * 
     * <h2>全量查PK, PK分页查</strong></h2>
     * <ol>
     *     <li>ALL --过滤条件--> PKs</li>
     *     <li>PKs --对PK进行分页--> 当页对应的PKs --PKs--> 当页FeatureSet</li>
     * </ol>
     * 
     * <h3>细说原理</h3>
     * <ol>
     *     <li>
     *     只查询出符合条件的空间数据集(FeatureSet)所有PK字段值(例如OBJECTID字段值)
     *         <ul>
     *             <li>
     *                 <strong>
     *                 需要注意地图服务配置中限制的最大返回结果数, 必须做出适当调整, 不然返回的结果可能不是全集
     *                 </strong>
     *             </li>
     *             <li>
     *             以最小的数据量代价得到所有FeatureSet对应的PK值 
     *             </li>
     *             <li>
     *             从返回的FeatureSet中提取出所有PK值, 可以得知总记录数, 以便计算分页
     *             </li>
     *         </ul>
     *     </li>
     *     <li>
     *     对PK值数组进行分页, 查询其对应的FeatureSet, 即得到一页的FeatureSet
     *         <ul>
     *             <li>
     *             例如每页5条数据, 第一页则从PK值数组中取出第0~4条PK值, 以此为过滤条件来获取分页结果, 类似OBJECTID in (0, 1, 2, 3, 4) 
     *             </li>
     *         </ul>
     *     </li>
     * </ol>
     * 
     * <h3>多图层分页查询</h3>
     * 例如对IdentifyTask进行分页, 原理类似, 不过IdentifyParameters无法控制只返回PK字段值, 只能控制不返回geometry以减少数据量
     * 
     * <h3>缺陷</h3>
     * 不能得到按某个属性字段排序后的分页结果, 例如希望按Feature的NAME属性来排序,
     * 这就要求第一次查询返回的PK值数组也是经过NAME排序后的结果, 按照目前的ArcGIS REST Query无法实现
     * 
     * @author Sun
     * @see http://help.arcgis.com/en/webapi/flex/samples/index.html?sample=PagingTable Paging through results
     * @see http://bbs.esrichina-bj.cn/ESRI/viewthread.php?tid=78273 ArcGIS API for Flex 2.0开发应用之分页查询
     */
    public class PaginationQueryTask extends QueryTask {
        // TODO 当分页条件(例如_pageSize, _pkFieldName)改变时需要重新获取分页数据
        private var _pageSize:uint;
        private var _numPages:uint;

        private var _numRecords:uint;

        /**
         * 分页序号, 从1开始
         */
        protected var pageNumber:uint;

        /**
         * 空间数据集中的主键字段名, 大小写敏感, 必须按照REST图层说明中Fields中给定的一样.
         * 虽然在将其做为过滤字段过滤条件时, SQL条件语句对字段大小写不敏感, 但是返回的属性名大小写敏感.
         * 例如字段名为objectid, 做为SQL可以是objectid或者OBJECTID, 但当去取返回数据时,
         * 必须使用attributes["objectid"]
         */
        private var _pkFieldName:String;
        protected var pkValues:Array = [];

        private var _queryParam:Query;

        /**
         * 查询条件中原本设置的查询结果返回哪些字段值
         */
        private var originalOutFields:Array;

        /**
         * 查询条件中原本设置的查询结果是否返回geometry信息
         */
        private var originalReturnGeometry:Boolean;

        /**
         * 初始化分页查询条件.
         * 
         * @param layerUrl
         * @param queryParam 空间数据过滤条件
         * @param pkFieldName 空间数据集中的主键字段名, 例如FID, OBJECTID
         * @param pageSize
         */
        public function PaginationQueryTask(layerUrl:String, queryParam:Query,
                pkFieldName:String, pageSize:uint = 10) {
            super(layerUrl);
            this.showBusyCursor = true;

            this._queryParam = queryParam;
            // 抽取出原本的查询条件, 查询所有PK值的时候, 会覆盖它们, 但真正做分页查询时需要还原
            this.originalOutFields = queryParam.outFields;
            this.originalReturnGeometry = queryParam.returnGeometry;

            this._pkFieldName = pkFieldName;
            this._pageSize = pageSize;
        }

        public function queryPage(pageNumber:uint, responder:IResponder):void {
            this.pageNumber = pageNumber;

            if (pkValues.length == 0) {
                queryPkValues(responder);
            } else {
                queryPaginationFsByPkValues(responder);
            }
        }

        /**
         * 查询出所有符合条件的FeatureSet的PK值
         */
        private function queryPkValues(responder:IResponder):void {
            // 覆盖原本的查询条件, 限制全量查询结果只返回PK字段的值
            _queryParam.outFields = [_pkFieldName];
            _queryParam.returnGeometry = false;

            execute(_queryParam,
                new AsyncResponder(extractPkValues, fault, responder));
        }

        private function extractPkValues(fs:FeatureSet, responder:IResponder):void {
            for each (var attribute:Object in fs.attributes) {
                pkValues.push(attribute[_pkFieldName]);
            }

            _numRecords = pkValues.length;
            _numPages = Math.ceil(_numRecords / _pageSize);

            queryPaginationFsByPkValues(responder);
        }

        private function queryPaginationFsByPkValues(responder:IResponder):void {
            // 恢复原本的查询条件
            _queryParam.outFields = originalOutFields;
            _queryParam.returnGeometry = originalReturnGeometry;

            // 去掉多余的查询条件, 已经由限制PK字段值来取代, 减少发送HTTP请求时的数据量
            _queryParam.text = null;
            _queryParam.geometry = null;

            // 分页查询条件
            _queryParam.where = getPaginationWhereClause();

            execute(_queryParam, responder);
        }

        /**
         * 将PK值数组分页后, 组装成过滤PK字段值的SQL条件语句
         */
        protected function getPaginationWhereClause():String {
            var paginationPkValues:Array = getPaginationPkValues();
            return _pkFieldName + " in (" + paginationPkValues.join() +")";
        }

        private function getPaginationPkValues():Array {
            var pageIndex:uint = pageNumber - 1;

            var startIndex:uint = pageIndex * _pageSize;
            // 本页到该条数据结束, 但不包含该条数据
            var endIndex:uint = startIndex + _pageSize;

            return pkValues.slice(startIndex, endIndex);
        }

        private function fault(info:Object, token:Object):void {
            trace(info, token);
        }

        public function get numPages():uint {
            return _numPages;
        }

        public function get numRecords():uint {
            return _numRecords;
        }
    }
}
