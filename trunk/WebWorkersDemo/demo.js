// 将要后台运行的一段代码
// TODO 为什么Worker加载js的网络通信Firebug监听不到?
// Worker在加载时初始化, Firebug可以监听得到Worker加载js的网络通信(看见一条加载js的HTTP请求),
// 但是如果Worker在任意方法中初始化, Firebug就监听不到网络通信, 太神奇了, 难道是版本问题?
// Firefox 3.5.1 & Firebug 1.3.3
var worker = new Worker("worker.js");

// 如何处理后台worker返回的结果
worker.onmessage = function (event) {
    showStatus("后台worker计算完毕: " + event.data);
}

function showStatus(htmlText) {
    document.getElementById("status").innerHTML = htmlText;
}

function getMax() {
    return document.getElementById("maxInput").value;
}

/**
 * 通过后台worker来进行sum计算, 界面不会假死, 计算完成后后台worker会返回数据
 */
function startWork() {
    showStatus("后台worker计算中...");
    // 将消息发送给worker启动后台计算, 主界面仍然可以操作, 不会假死.
    // 也可以在初始化worker时就开始执行, 只要在woker.js中直接运行js语句即可, 而不是放在onmessage里
    worker.postMessage(getMax());
}

/**
 * 通过当前线程来进行sum计算, 界面将会假死
 */
function workByMyself() {
    showStatus("当前线程计算中...");
    showStatus("当前线程计算完毕: " + sum(getMax()));
}
