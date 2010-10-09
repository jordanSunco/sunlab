package util {
    import mx.formatters.DateFormatter;
    
    public class DateUtils {
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
         * 对一组已经过排序的日期按日期字段进行分组, 分组后形成一个二维数组, 第一位表示组名, 第二位表示成员个数
         * 如将[2009-11, 2009-12, 2010-01] 按年份分组 [[2009, 2], [2010, 1]]
         * 
         * @param sortedDateArray
         * @param dateFieldName 日期字段(month, date...)
         */
        public static function groupDate(sortedDateArray:Array,
                dateFieldName:String):Array {
            var dateGroup:Array = new Array();

            var dateFormatter:DateFormatter = new DateFormatter();
            // 通过格式化日期来确定哪些日期是一组的
            switch (dateFieldName) {
                case "fullYear":
                    dateFormatter.formatString = "YYYY";
                    break;
                case "month":
                    // TODO 太长了
                    dateFormatter.formatString = "YYYY-M";
                    break;
                default:
                    trace("default");
            }

            // 取出第一个分组的日期字段值
            var groupName:String = dateFormatter.format(sortedDateArray[0]);
            // 第一个分组的成员出现1次
            dateGroup.push([groupName, 1]);

            for (var i:uint = 1, length:uint = sortedDateArray.length; i < length; i++) {
                var dateValue:String = dateFormatter.format(sortedDateArray[i]);

                // 判断最后一组是否与当前取出的日期是一组的
                var group:Array = dateGroup[dateGroup.length - 1];

                if (dateValue == group[0]) {
                    group[1]++;
                } else {
                    dateGroup.push([dateValue, 1]);
                }
            }

            return dateGroup;
        }
    }
}
