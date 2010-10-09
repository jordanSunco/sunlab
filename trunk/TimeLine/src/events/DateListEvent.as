package events {
    import flash.events.Event;
    
    import mx.formatters.DateFormatter;

    public class DateListEvent extends Event {
        public static const DATE_LIST_CHANGE:String = "dateListChange";

        [ArrayElementType("Date")]
        private var _dates:Array;

        /**
         * 放置格式化后的日期字符串, 例如月日期格式化为201001, 日日期格式化为20100101
         */
        [ArrayElementType("String")]
        private var _formattedDates:Array;

        /**
         * 日期字段(month, date...)
         */
        private var _dateFieldName:String;

        private var dateFormatter:DateFormatter = new DateFormatter();

        public function DateListEvent(type:String, bubbles:Boolean=false,
                cancelable:Boolean=false, dates:Array=null,
                dateFieldName:String=null) {
            super(type, bubbles, cancelable);

            this._dates = dates;
            this._dateFieldName = dateFieldName;

            initDateFormatter();
            formatDates();
        }

        /**
         * 根据日期字段获取格式化日期的规格
         */
        protected function initDateFormatter():void {
            switch (_dateFieldName) {
                case "month":
                    dateFormatter.formatString = "YYYYMM";
                    break;
                case "date":
                    dateFormatter.formatString = "YYYYMMDD";
                    break;
                default:
                    trace("default");
            }
        }

        private function formatDates():void {
            _formattedDates = new Array();
            for each (var d:Date in _dates) {
                _formattedDates.push(dateFormatter.format(d));
            }
        }

        public function get dates():Array {
            return this._dates;
        }

        public function get dateFieldName():String {
            return this._dateFieldName;
        }

        public function get formattedDates():Array {
            return this._formattedDates;
        }
    }
}
