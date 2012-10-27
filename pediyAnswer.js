/**
 * 看雪安全论坛小测试自动答题工具(脚本)
 * 论坛小测试(可以赚取30 Kx): http://bbs.pediy.com/answer.php
 * 
 * 主要是利用题目/答案不会变(只是出现位置会随机改变), 提交答案可以从中得知回答是否正确.
 * 例如:
 * 你尝试回答[题目1], 选择[答案1], 其他题目都选择[答案1].
 * 提交答案, 会被告知"您有13道问题回答错误".
 * 那么我们重新选择[题目1]为[答案2], 其他题目仍旧都选择[答案1].
 * 再次提交, 如果被告知"您有12道问题回答错误", 那就是说[答案2]就是[题目1]的正确答案了!
 * 
 * 使用方法:
 * 1. 需要firefox/firebug
 * 2. 登录看雪论坛, 打开论坛小测试页面, http://bbs.pediy.com/answer.php
 * 3. F12打开firebug Console, 如果Console Panel is disabled, 请先Enabled
 * 4. 将脚本代码复制到Console中, Run!
 * 5. 答题完毕后会显示所有题目和正确答案, 再会跳转到社区银行(用户必须激活才能查看)
 * 
 * @author ufologist
 * @version 1.0 2012-10-26
 */
(function() {
    function getAnswerRadioEls() {
        var radioEls = [];
        var inputEls = document.getElementById('answerForm').getElementsByTagName('input');
        for (var i = 0, length = inputEls.length; i < length; i++) {
            var inputEl = inputEls[i];
            if (inputEl.type === 'radio') {
                radioEls.push(inputEl);
            }
        }
        return radioEls;
    }

    function findAnswerRadioEls(radioEls, radioName) {
        var answerRadioEls = [];
        for (var i = 0, length = radioEls.length; i < length; i++) {
            var radioEl = radioEls[i];
            if (radioEl.name === radioName) {
                answerRadioEls.push(radioEl);
            }
        }
        return answerRadioEls;
    }

    function getRadioName(index) {
        return 'question[question' + index + ']';
    }

    function submitAnswer() {
        var xhr = new XMLHttpRequest();
        xhr.open('POST', 'http://bbs.pediy.com/answer.php?action=submit', false);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.send(encodeURI(getFormData().join('&')));

        if (xhr.status == 200) {
            return getWrongCount(xhr.responseText);
        } else {
            // HTTP异常时重试
            return submitAnswer();
        }
    }

    function getWrongCount(text) {
        // '<p><strong>您有13道问题回答错误!</strong></p>'
        var getWrongCountRegExp = /您有(\d+)道问题回答错误!/m;
        // <p><strong>恭喜您,问题全部回答正确,您获得了30Kx!正在转向论坛首页...</strong></p>
        var getSuccessRegExp = /恭喜您/m;
        // <p><strong>对不起,您已经参加了这次答题活动!</strong></p>
        var hasJoinedRegExp = /对不起/m

        if (getWrongCountRegExp.test(text)) {
            return parseInt(getWrongCountRegExp.exec(text)[1]);
        } else if (getSuccessRegExp.test(text)) { // 问题全部回答正确
            return 0;
        } else if (hasJoinedRegExp.test(text)) { // 已经参考过答题活动了
            return 0;
        } else {
            return 0;
        }
    }

    function getFormData() {
        var inputEls = document.getElementById('answerForm').getElementsByTagName('input');
        var data = ['action=submit'];
        for (var i = 0, length = inputEls.length; i < length; i++) {
            var inputEl = inputEls[i];
            if (inputEl.checked) {
                data.push(inputEl.name + '=' + inputEl.value);
            }
        }
        return data;
    }

    function defaultCheckAnswer(radioEls, startQuestionIndex, questionCount) {
        for (var i = startQuestionIndex; i <= questionCount; i++) {
            var answerRadioEls = findAnswerRadioEls(radioEls, getRadioName(i));
            answerRadioEls[0].checked = true;
        }
    }

    function tryAnswerQuestion(radioEls, index) {
        var answerRadioEls = findAnswerRadioEls(radioEls, getRadioName(index));

        var answer1WrongCount;
        var rightAnswerIndex;
        for (var i = 0, length = answerRadioEls.length; i < length; i++) {
            answerRadioEls[i].checked = true;
            var wrongCount = submitAnswer();
            // 全部回答正确了
            if (wrongCount === 0) {
                return;
            }

            if (i == 0) { // 选择答案1时, 提示有多少道问题回答错误, 有可能答案1就是正确答案
                answer1WrongCount = wrongCount;
                rightAnswerIndex = 0;
            } else if (wrongCount < answer1WrongCount) { // 如果错误数量减小了, 则说明这个答案就是对的
                rightAnswerIndex = i;
                break;
            }
        }

        // 重新选中正确答案
        answerRadioEls[rightAnswerIndex].checked = true;
    }

    function showAnswers(radioEls, startQuestionIndex, questionCount) {
        var questionAnswers = [];
        for (var i = startQuestionIndex; i <= questionCount; i++) {
            var answerRadioEls = findAnswerRadioEls(radioEls, getRadioName(i));
            for (var j = 0, length = answerRadioEls.length; j < length; j++) {
                var answerRadioEl = answerRadioEls[j];
                if (answerRadioEl.checked) {
                    var question = answerRadioEl.parentNode.parentNode.parentNode.previousSibling.textContent
                    var answer = answerRadioEl.parentNode.textContent;
                    questionAnswers.push(question + '\n' + answer);
                }
            }
        }
        alert(questionAnswers.join('\n\n'));
    }

    function main() {
        var startQuestionIndex = 1;
        var questionCount = 16;
        var radioEls = getAnswerRadioEls();
        defaultCheckAnswer(radioEls, startQuestionIndex, questionCount);

        // 逐个尝试各个问题的各个答案来确定正确答案
        for (var i = startQuestionIndex; i <= questionCount; i++) {
            tryAnswerQuestion(radioEls, i);
        }

        showAnswers(radioEls, startQuestionIndex, questionCount);
        alert('跳转到社区银行查看资产');
        window.location.href = 'http://bbs.pediy.com/bank.php';
    }

    main();
})();
