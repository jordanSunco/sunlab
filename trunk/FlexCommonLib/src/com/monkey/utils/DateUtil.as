package com.monkey.utils {
    import mx.formatters.DateFormatter;

    /**
     * 日期工具类, 用于获取递增的时间段
     * 
     * @author Sun
     */
    public class DateUtil {
        /**
         * 获取往前推日期
         * 
         * @param currentDate
         * @param n
         * @param dateFieldName 日期字段(month, date...)
         */
        public static function getBackDate(currentDate:Date, n:uint,
                dateFieldName:String):Date {
            var backDate:Date = new Date(currentDate.getTime());
            // 日期往前推
            // 例如月份往前推: backDate.month -= back;
            backDate[dateFieldName] -= n;

            return backDate;
        }

        /**
         * 获取递增的日期段(包含开始日期)
         * 
         * @param firstDate
         * @param size
         * @param dateFieldName 日期字段(month, date...)
         */
        public static function getIncreaseDateArray(firstDate:Date, size:uint,
                dateFieldName:String):Array {
            // clone开始的日期值(firstDate), 确保以后的操作不会对其有影响
            var firstDateClone:Date = new Date(firstDate.getTime());
            var dateList:Array = [new Date(firstDate.getTime())];

            // 如果要获取递增的月份, 将日期设置到1号, 防止出现2月日期越界再跨月的情况
            // 例如当前日期是1月30号, 累加月份后变为是2月30号, 由于2月没有30号, 日期自动跳到3月
            // 这个问题实在太费解了, 开始还以为ActionScript计算0+1=2, 后来才顿悟了, 是自己愚钝啊.
            if (dateFieldName == "month") {
                firstDateClone.setDate(1);
            }

            // 数组中已经加入了开始日期, 计数从1开始
            for (var i:uint = 1; i < size; i++) {
                firstDateClone[dateFieldName]++;
                dateList.push(new Date(firstDateClone.getTime()));
            }

            return dateList;
        }

        /**
         * 获取日期在某个维度完整的日期值, 即日期的确切值, 用于判断2个日期在同一维度是否相等.
         * 例如2个日期, 2010-05-03, 2011-05-04, 需要判断在月维度上这2个日期是否相等.
         * 由于他们的月份是一样的, 如果只通过月份值来判断他们是否相等显然是不正确的.
         * 因此必须得到日期在这个维度的完整值, 那么2010-05-03在月维度下应该是2010-05,
         * 2011-05-04应该是2011-05, 这样就可以判断出2个日期在同一维度是否相等了.
         */
        public static function getDateFullValue(dateFieldName:String,
                date:Date):String {
            var formatString:String = "YYYY";

            switch (dateFieldName) {
                case "fullYear":
                    formatString = "YYYY";
                    break;
                case "month":
                    formatString = "YYYY-MM";
                    break;
                case "date":
                    formatString = "YYYY-MM-DD";
                    break;
                default:
                    trace("暂不支持这样的日期维度");
            }

            var dateFormatter:DateFormatter = new DateFormatter();
            dateFormatter.formatString = formatString;

            return dateFormatter.format(date);
        }
    }
}
