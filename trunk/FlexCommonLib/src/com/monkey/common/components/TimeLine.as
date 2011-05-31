package com.monkey.common.components{
    import com.monkey.common.components.renderers.ListButtonRenderer;
    
    import mx.core.ClassFactory;

    /**
     * 时间轴组件, 用于显示一段时间周期, 支持多种时间维度, 例如年, 月, 日...
     * 
     * @author Sun
     */
    public class TimeLine extends NoIndicatorTileList {
        private var _dateType:String;

        public function TimeLine() {
            this.itemRenderer = new ClassFactory(ListButtonRenderer);
            this.rowCount = 1;
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
            this.labelFunction = getDateLabel;

//             TODO 设置了itemRenderer后无法显示Tip
//             this.showDataTips = true;
//             this.dataTipFunction = getDateTip;
        }

        /**
         * 根据日期类型提取出Date中的日期值
         */
        private function getDateLabel(item:Object):String {
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

//        TODO 设置了itemRenderer后无法显示Tip
//        private function getDateTip(item:Object):String {
//            return (item as Date).toLocaleDateString();
//        }
    }
}
