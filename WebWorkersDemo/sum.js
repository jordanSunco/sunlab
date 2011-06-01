/**
 * 计算从1 ~ max的累加总数, 例如 1 + 2 + 3 + ... + 100 = 5050
 */
function sum(max) {
    var _sum = 0;
    for (var i = 1; i <= max; i++) {
        _sum += i;
    }
    return _sum;
}
