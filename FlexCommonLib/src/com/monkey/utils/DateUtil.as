package com.monkey.utils {
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
    }
}
