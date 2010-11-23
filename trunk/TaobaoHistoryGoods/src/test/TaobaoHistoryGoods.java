/*
 * Copyright
 */

package test;

import java.io.File;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.FileUtils;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;

/**
 * 获取淘宝历史宝贝的描述script src
 * 
 * @author Sun
 * @version TaobaoHistoryGoods.java 2010-11-22 下午09:37:51
 */
public class TaobaoHistoryGoods {
    private static final String TAOBAO_HISTORY_GOODS_CSV_FILE_URL = "D:/talkweb/workspace/TaobaoHistoryGoods/src/TaobaoHistoryGoods.csv";

    public static void main(String[] args) {
        new TaobaoHistoryGoods().loadTaobaoHistoryGoodsDesc();
    }

    private void loadTaobaoHistoryGoodsDesc() {
        try {
            String csvString = FileUtils.readFileToString(new File(
                    TAOBAO_HISTORY_GOODS_CSV_FILE_URL));
            String[] rows = csvString.split("\n");
            for (String row : rows) {
                String[] columns = row.split(",");
                // 从firebug console复制出来的url中有 /, 空格 + 一个斜杠, 替换成只有斜杠
                // url中有- , 杠 + 空格, 替换成只有杠
                // url中\r 回车, 替换成空字符串
                String taobaoHistoryGoodUrl = columns[columns.length - 1]
                        .replace(" /", "/").replace("- ", "-")
                        .replace("\r", "");
                String html = getTaobaoHistoryGood(taobaoHistoryGoodUrl);
                System.out.println(extractDescScriptSrc(html));
                break;
            }
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    private String getTaobaoHistoryGood(String taobaoHistoryGoodUrl) {
        HttpClient httpclient = new DefaultHttpClient();
        HttpGet httpget = new HttpGet(taobaoHistoryGoodUrl);

        // Create a response handler
        ResponseHandler<String> responseHandler = new BasicResponseHandler();
        String responseBody = null;
        try {
            responseBody = httpclient.execute(httpget, responseHandler);
        } catch (ClientProtocolException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        // When HttpClient instance is no longer needed,
        // shut down the connection manager to ensure
        // immediate deallocation of all system resources
        httpclient.getConnectionManager().shutdown();

        return responseBody;
    }

    /**
     * 从淘宝历史宝贝页面中提取出描述内容script的src. html片段格式如下, 通过正则表达式提取src属性的内容.
     * <script type="text/javascript" src="http://dsc03.taobao.com/i3/b70/780/b7478772fd6bdf8690a190784babd671/T1WxtFXlJvXXXXXXXX.desc|var^desc;sign^32c5a4991696ad0490cf72ba148f78b1;lang^gbk;t^1278646304">
     * 
     * @param taobaoHistoryGoodUrl
     * @return
     */
    private String extractDescScriptSrc(String taobaoHistoryGoodHtml) {
        // 正则表达式分组, 只要引号中的内容
        // TODO 还是有部分匹配不上?
        Pattern pattern = Pattern.compile("\"(\\S+\\.desc\\S+)\"");
        Matcher m = pattern.matcher(taobaoHistoryGoodHtml);
        m.find();

        return m.group(1);
    }
}
