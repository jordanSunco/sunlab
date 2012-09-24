// ==UserScript==
// @name 12306RemainTicketQueryEnhance
// @namespace www.douban.com/people/ufologist/12306
// @description 增强12306余票查询的便捷性
// @include *://dynamic.12306.cn/TrainQuery/leftTicketByStation.jsp
// @match *://dynamic.12306.cn/TrainQuery/leftTicketByStation.jsp
// @author www.douban.com/people/ufologist/
// @version 1.0.1
// ==/UserScript==
/**
 * v1.0.1 2012-9-20
 * 为保证兼容其他版本的firefox和greasemonkey, 改用插入script的方式来运行脚本
 * 
 * v1.0 2012-9-20
 * 增强余票查询的便捷性
 * 1. 打开<a href="http://dynamic.12306.cn/TrainQuery/leftTicketByStation.jsp">铁路客户服务中心-余票查询</a>
 * 2. 输入验证码后直接回车开始查询(发站/到站数据加载较慢时直接输入完整站名即可)
 * 3. 加载验证码异常时自动重新加载
 * 4. 通过xhr来异步查询
 * 5. 查询失败时给予提示
 */
(function() {
    function main() {
        var logPlaceholderEl;
        var stationDiv;

        function log(info) {
            logPlaceholderEl.innerHTML = info;
        }

        function warn(info) {
            logPlaceholderEl.innerHTML = '<span style="color: red">' + info + '</span>';    
        }

        function addLogPlaceholder() {
            logPlaceholderEl = document.createElement('div');
            stationDiv = document.getElementById('stationDIV');
            stationDiv.parentNode.insertBefore(logPlaceholderEl, stationDiv);
        }

        function clearPreviousResultInfo() {
            stationDiv.innerHTML = '';
        }

        function listenRandCodeInput() {
            var inputEl = document.getElementById('randCode');
            var ENTER_KEY_CODE = 13;
            inputEl.onkeypress = function(event) {
                if (event.keyCode == ENTER_KEY_CODE) {
                    queryRemainTicket();
                }
            };
        }

        function listenRandCodeImgLoadError() {
            var imgEl = document.getElementById("img_rrand_code");
            if (!imgEl.onerror) {
                imgEl.onerror = function() {
                    warn('验证码加载失败, 自动重新加载');
                    refreshImg();
                };
            }
            if (!imgEl.onload) {
                imgEl.onload = function() {
                    document.getElementById('randCode').focus();
                    document.getElementById('randCode').select();
                    log('验证码加载成功, 请输入值');
                };
            }
        }

        function queryRemainTicket() {
            log('正在查询...');
            clearPreviousResultInfo();

            var key = 'liusheng';
            var REMAIN_TICKET_API = 'http://dynamic.12306.cn/TrainQuery/iframeLeftTicketByStation.jsp';

            var nmonth3 = document.getElementsByName('nmonth3')[1].value;
            var nday3 = document.getElementsByName('nday3')[1].value;
            // 坑爹的方法名: a1ert(调用余票查询页面中js的方法), 用于给站点名加密
            var startStation_ticketLeft = a1ert(document.getElementsByName('startStation_ticketLeft')[1].value, key);
            var arriveStation_ticketLeft = a1ert(document.getElementsByName('arriveStation_ticketLeft')[1].value, key);

            var trainCode = document.getElementsByName('trainCode')[0].value;
            var randCode = document.getElementById('randCode').value;

            var formData = ['nmonth3=' + nmonth3, 'nday3=' + nday3,
                            'startStation_ticketLeft=' + startStation_ticketLeft,
                            'arriveStation_ticketLeft=' + arriveStation_ticketLeft,
                            'trainCode=' + trainCode,
                            'randCode=' + randCode,
                            'rFlag=1', 'tFlagDC=DC', 'tFlagZ=Z', 'tFlagT=T', 'tFlagK=K', 'tFlagPK=PK', 'tFlagPKE=PKE', 'tFlagLK=LK',
                            'ictO=7653', 'fdl=', 'lx=00'];

            var xhr = new XMLHttpRequest();
            xhr.open('POST', REMAIN_TICKET_API, true);
            xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
            xhr.onreadystatechange = function() {
                if (xhr.readyState == 4) {
                    if (xhr.status == 200) {
                        document.getElementById('iframeID1').contentDocument.write(xhr.responseText);
                        log('');
                        // console.log(xhr.responseText);
                    } else {
                        warn('查询失败, 自动重新加载验证码');
                        // 调用余票查询页面中js的方法
                        refreshImg();
                    }
                }
            };
            xhr.send(formData.join('&'));
        }

        addLogPlaceholder();
        listenRandCodeInput();
        listenRandCodeImgLoadError();
    }

    /**
     * 老版本的Greasemonkey不能在其作用域中调用页面中的方法(如调用脚本作用页面中的jQuery)
     * 因此采用插入script标签和内容的方式来运行整个脚本
     * 
     * PS: 经测试Greasemonkey 1.1@Firefox 15.0.1完全不需要这么蹩脚的方式
     */
    function injectScript(fn) {
        var script =document.createElement("script");
        script.textContent = "(" + fn + ")();";
        document.body.appendChild(script);
    }

    injectScript(main);
})();
