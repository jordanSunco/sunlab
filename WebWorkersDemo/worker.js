importScripts("sum.js");

/**
 * 得到主线程传过的消息, 启动线程进行大数据计算.
 * mainThread.postMessage -> workerThread.onmessage
 */
onmessage = function (event) {
    var a = this;
    // 从event.data中取得主线程传来的数据
    var max = event.data;
    // 将结果传递给主线程
    // 不可进行访问/操作主线程界面(DOM)数据, 即使通过postMessage传递过来
    // workerThread.postMessage -> mainThread.onmessage
    postMessage(sum(max));
};
