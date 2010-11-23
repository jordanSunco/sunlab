/**
 * 在淘宝历史宝贝记录页面使用, 通过firebug console导出宝贝名称和宝贝URL地址, 做成csv文件, 用于重新上架.
 * 由于翻页后页面跳转, 需要重新运行此段代码, 手工将console中的结果追加到csv文件中.
 * 历史宝贝记录页面:
 * http://archive.taobao.com/auction/goods/goods_in_stock.htm?recently=false
 * 
 * TODO 一次性将历史宝贝全部读取出来, 自动获取翻页数据.
 */
function exportHistoryGoods() {
    var historyGoodAnchors = $$(".desc > a");
    for (var i = 0, length = historyGoodAnchors.length; i < length; i++) {
        // td > a
        var anchor = historyGoodAnchors[i];

        // tr > td > a
        var trElement = anchor.parentNode.parentNode;
        // tr > td
        var trTds = trElement.getElementsByTagName("td");
        // 价格放在最后一个td里
        var priceTdElement = trTds[trTds.length - 1];
        var price = priceTdElement.firstChild.nodeValue.replace("元", "");

        // 以逗号分隔, 方便做成csv文件查看
        console.log(anchor.firstChild.nodeValue + "," + price + ","
            + anchor.href);
    }
}
exportHistoryGoods();

/**
 * 通过XHR获取历史宝贝页面的内容, 用正则表达式来匹配字符串, 提取出想要的数据, 例如宝贝标题, 价格等等.
 * 历史宝贝页面:
 * http://archive.taobao.com/auction/item_detail-0dbh-b7478772fd6bdf8690a190784babd671.jhtml
 * 
 * @param historyGoodUrl
 * @return
 */
function publishHistoryGood(historyGoodUrl) {
    var xhr = new XMLHttpRequest();
    xhr.open("get", historyGoodUrl, true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4) {
            loadGoodDesc(extractDescScriptSrc(xhr.responseText));
        }
    };
    xhr.send(null);
}

/**
 * 从responseText中提取出描述内容script的src.
 * 淘宝宝贝描述是怎么生成的?
 * 通过加载这段script, 赋值window.desc变量, 里面的内容就是html, 然后就是element.innerHTML = window.desc, 不过之前还调用了一个过滤方法, 没去深究了.
 * html片段格式如下, 通过正则表达式提取src属性的内容.
 * <script type="text/javascript" src="http://dsc03.taobao.com/i3/b70/780/b7478772fd6bdf8690a190784babd671/T1WxtFXlJvXXXXXXXX.desc|var^desc;sign^32c5a4991696ad0490cf72ba148f78b1;lang^gbk;t^1278646304">
 * 
 * @param historyGoodResponseText
 * @return
 */
function extractDescScriptSrc(historyGoodResponseText) {
    // 正则表达式分组, 只要引号中的内容
    var pattern = /"(\S+\.desc\S+)"/g;
    var descScriptSrc = pattern.exec(historyGoodResponseText)[1];
    return descScriptSrc;
}

/**
 * 加载宝贝的描述数据, 是一段script, 通过xhr加载获取内容.
 * 描述内容格式为: var desc='<div></div>';
 * http://dsc03.taobao.com/i3/b70/780/b7478772fd6bdf8690a190784babd671/T1WxtFXlJvXXXXXXXX.desc|var^desc;sign^32c5a4991696ad0490cf72ba148f78b1;lang^gbk;t^1278646304
 */
function loadGoodDesc(descScriptSrc) {
    var xhr = new XMLHttpRequest();
    xhr.open("get", descScriptSrc, true);
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4) {
            // TODO xhr跨域, 读取responseText总是empty
            // 改用创建script标签来加载这段script
            console.log(xhr.responseText);
        }
    };
    xhr.send(null);
}

publishHistoryGood("http://archive.taobao.com/auction/item_detail-0dbh-b7478772fd6bdf8690a190784babd671.jhtml");

function typeGoodInfo(title, price, descScriptUrl) {
    // 宝贝类型: 全新
    $("on1").checked = true;
    changeStuffStatus(5);

    // 宝贝标题
    $("TitleID").value = title;
    onTitleChange($("TitleID"));

    // 一口价
    $("buynow").value = price;
    fillSkuPrice();

    // 宝贝数量
    $("quantityId").value = 1;

    // 这段script本身就会设置一个window.desc, 那我直接拿来用就行了...
    var scriptElement = document.createElement("script");
    scriptElement.onload = function () {
        // 宝贝描述
        $("J_ItemDescTextarea").value = window.desc;        
    };
    scriptElement.src = descScriptUrl;
    document.body.appendChild(scriptElement);

    // 所在地 湖南-长沙
    $("J_province").options[14].selected = true;
    setcity();

    // 使用运费模板
    afterSelectPostage('918130', 'version 1.0','0');
    
    // 不参与会员打折
    $("notAutoPromoted").checked = true;
}
typeGoodInfo("不织布DIY材料包 可爱情侣 男生女生配 卡包/套 材料包", 7.9, "http://dsc03.taobao.com/i3/b70/780/b7478772fd6bdf8690a190784babd671/T1WxtFXlJvXXXXXXXX.desc|var^desc;sign^32c5a4991696ad0490cf72ba148f78b1;lang^gbk;t^1278646304");
