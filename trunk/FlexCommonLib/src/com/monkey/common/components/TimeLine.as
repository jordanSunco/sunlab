package com.monkey.common.components {
    import com.monkey.common.components.renderers.ListButtonRenderer;
    import com.monkey.utils.DateUtil;
    
    import mx.core.ClassFactory;
    import mx.events.ListEvent;

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

        protected var _selectedDates:Array = [];

        public function TimeLine() {
            super();
            this.itemRenderer = new ClassFactory(ListButtonRenderer);
            this.rowCount = 1;
            this.labelFunction = getDateLabel;
            this.addEventListener(ListEvent.CHANGE, changeSelectedDates);
            // 在构造函数中初始化数据源, 否则首次展现的Button日期项会有异常的宽高
            initDataProvider();

//            TODO 设置了itemRenderer造成无法显示Tip
//            this.showDataTips = true;
//            this.dataTipFunction = getDateTip;
        }

        /**
         * 当List所选项发生改变时记录选中的日期是哪些
         */
        private function changeSelectedDates(event:ListEvent):void {
            _selectedDates = selectedItems;
        }

        /**
         * 根据时间轴的维度, 取得时间轴上各个日期值应该显示的label.
         * 例如月维度的时间轴, 就应该取出Date中的month值, 假设得到3, 那么应该显示为4月.
         */
        private function getDateLabel(item:Object):String {
            var date:Date = item as Date;
            var dateValue:Number = getDateValue(date);

            return getDateString(dateValue, date);
        }

        /**
         * 根据时间轴的维度取出Date中的日期值.
         * 例如月维度的时间轴, 则取出Date.month.
         */
        protected function getDateValue(date:Date):Number {
            return date[_dateType];
        }

        /**
         * 根据时间轴的维度和Date中的日期值, 决定如何显示日期值.
         * 
         * @param dateValue Date中的日期值
         * @param date
         */
        protected function getDateString(dateValue:Number, date:Date):String {
            var dateString:String;

            // 由于Date中的月份是从0开始的(0表示1月份), 但现实中月份是从1开始的(1表示1月份)
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

        public function get startDate():Date {
            return this._startDate;
        }

        public function set startDate(value:Date):void {
            // clone传入的日期以免在改变时间轴时影响传入的参数
            this._startDate = new Date(value.time);
            invalidateProperties();
        }

        public function get dateType():String {
            return this._dateType;
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

        public function get size():uint {
            return this._size;
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
            selectDates();
        }

        /**
         * 在List更新数据后, 根据以往选中的日期项, 再次选中这些日期
         */
        private function selectDates():void {
            if (_selectedDates.length > 0) {
                // 必须从DataProvider中获取上一次选中的日期, 再赋值给selectedItems.
                // 直接selectedItems = _selectedDates无效
                selectedItems = getSelectedDatesFromDataProvider();
            }
        }

        /**
         * 从DataProvider中获取上一次选中的日期
         */
        private function getSelectedDatesFromDataProvider():Array {
            var selectedDatesInDataProvider:Array = [];

            for each (var previousSelectedDate:Date in _selectedDates) {
                for each (var date:Date in dataProvider) {
                    // 如果dataProvider中的日期完整值和上一次选中的日期完整值相等, 则表示需要再次选中
                    if (DateUtil.getDateFullValue(_dateType, date) == DateUtil.getDateFullValue(_dateType, previousSelectedDate)) {
                        selectedDatesInDataProvider.push(date);
                    }
                }
            }

            return selectedDatesInDataProvider;
        }

        public function back():void {
            moveStartDate(false);
            initDataProvider();
        }

        public function forward():void {
            moveStartDate(true);
            initDataProvider();
        }

        /**
         * 对时间轴进行前/后移动时改变时间轴的起始日期项.
         * 
         * @see DateUtil.getIncreaseDateArray
         */
        protected function moveStartDate(increase:Boolean):void {
            // 时间轴默认从开始时间起加载连续的一段时间
            // 例如从2010.1.31起, 加载3个月份递增时间, 因此时间轴上的数据为:
            // 2010.1.31, 2010.2.1, 2010.3.1
            // 当需要向右移动时间轴时, 我们对2010.1.31的month进行++操作, 会发生日期越界情况
            // 2010.1.31 --> (1++) --> 2010.2.31(不存在的日期31 - 28 = 3) --> 2010.3.3
            // 同理当2010.11.31向左移动时, 也会发生日期越界情况
            // 2010.12.31 --> (12--) --> 2010.11.31(不存在的日期31 - 30 = 1) --> 2010.12.1
            // 为了解决这个问题, 当对month进行移动操作时, 将date设置为1来防止越界
            if (_dateType == "month") {
                this._startDate.setDate(1);
            }

            if (increase) {
                this._startDate[_dateType]++;
            } else {
                this._startDate[_dateType]--;
            }
        }
    }
}
