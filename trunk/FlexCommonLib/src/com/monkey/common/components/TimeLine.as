package com.monkey.common.components {
    import com.monkey.common.components.renderers.ListButtonRenderer;
    import com.monkey.utils.DateUtil;
    
    import mx.core.ClassFactory;

    /**
     * 时间轴组件, 用于显示一段时间周期, 支持多种时间维度, 例如年, 月, 日...
     * 
     * @author Sun
     */
    public class TimeLine extends NoIndicatorTileList {
        /**
         * 时间轴默认起始时间为系统当前时间
         */
        protected var _startDate:Date = new Date();

        /**
         * 时间轴默认显示月维度
         */
        protected var _dateType:String = "month";

        /**
         * 时间轴上容纳多少个日期选择项
         */
        protected var _size:uint = 10;

        public function TimeLine() {
            super();
            this.itemRenderer = new ClassFactory(ListButtonRenderer);
            this.rowCount = 1;
            this.labelFunction = getDateLabel;
            // 在构造函数中初始化数据源, 否则首次展现的Button日期项会有异常的宽高
            initDataProvider();

//            TODO 设置了itemRenderer造成无法显示Tip
//            this.showDataTips = true;
//            this.dataTipFunction = getDateTip;
        }

        /**
         * 根据日期类型提取出Date中的日期值
         */
        protected function getDateLabel(item:Object):String {
            var dateValue:Number = (item as Date)[_dateType];
            var dateString:String;

            // 由于月份是从0开始的, 需要特殊处理
            if (_dateType == "month") {
                dateString = (dateValue + 1).toString();
            } else {
                dateString = dateValue.toString();
            }

            return dateString;
        }

//        TODO 设置了itemRenderer造成无法显示Tip
//        private function getDateTip(item:Object):String {
//            return (item as Date).toLocaleDateString();
//        }

        public function set startDate(value:Date):void {
            // clone传入的日期以免在改变时间轴时影响传入的参数
            this._startDate = new Date(value.time);
            invalidateProperties();
        }

        /**
         * 日期类型, 时间轴根据该值来决定显示哪个时间维度的值.
         * 例如设置日期类型为fullYear, 时间轴将显示Date中fullYear的值,
         * 这样便是一个显示年维度的时间轴.
         * 
         * @param dateField 日期字段
         * @see Date
         */
        public function set dateType(dateField:String):void {
            this._dateType = dateField;
            invalidateProperties();
        }

        public function set size(value:uint):void {
            this._size = value;
            // 有多少个日期项就有多少列
            this.columnCount = value;
            invalidateProperties();
        }

        override protected function commitProperties():void {
            super.commitProperties();
            // 相关设置(例如dateType)发生改变时需要重新初始化时间轴中的数据源
            initDataProvider();
        }

        protected function initDataProvider():void {
            this.dataProvider = DateUtil.getIncreaseDateArray(_startDate,
                _size, _dateType);
        }
    }
}
