package org.jinouts.webservice.android;

import org.jinos.webservice.android.R;
import org.jinouts.webservice.service.Login;
import org.jinouts.webservice.service.LoginService;
import org.jinouts.webservice.service.LoginServiceResponse;

import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

/**
 * 
 * @author asraf http://code.google.com/p/android-ws-client
 * @author Sun http://sunlab.googlecode.com/svn/trunk/android-ws-client-demo/ 修改/注释一些需要注意的地方 2012-11-7
 */
public class AndroidWSAppActivity extends Activity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
    }

    public void callWebService(View view) {
        Log.i("AndroidWSAppActivity", "call the webservice");
        LoginServiceTask loginTask = new LoginServiceTask();
        loginTask.execute(new Void[] {});
    }

    private class LoginServiceTask extends
            AsyncTask<Void, Void, LoginServiceResponse> {
        @Override
        protected LoginServiceResponse doInBackground(Void... params) {
            EditText userEditText = (EditText) findViewById(R.id.userIdText);
            EditText passEditText = (EditText) findViewById(R.id.passEditText);
            String user = userEditText.getText().toString();
            String passwd = passEditText.getText().toString();

            // 默认下载的这个app项目没有勾选export lib下面的jar
            // 执行会报错:
            // Unable to resolve superclass of Lorg/jinouts/webservice/service/LoginService;
            // 显然是找不到类, android runtime没有提供的库都必须export出来
            // Project - Properties - Java Build Path - Order and Export, 勾选lib下面的jar

            // 默认生成的LoginService中URL指向的是localhost(本机), 在模拟器中是无法连接的,
            // 要连接到本机必须修改为10.0.2.2
            // 否则执行报错:
            // Caused by: javax.wsdl.WSDLException: WSDLException: faultCode=OTHER_ERROR: Unable to resolve imported document at 'http://localhost:9010/LoginService?WSDL'.: java.net.ConnectException: localhost/127.0.0.1:9010 - Connection refused
            LoginService service = new LoginService();
            Login login = service.getLoginPort();
            // 调用成功时的logcat日志
//            I/AndroidWSAppActivity: call the webservice
//            I/System.out: login
//            I/System.out: Retrieving document at 'http://10.0.2.2:9010/LoginService?WSDL'.
//            I/System.out: Retrieving schema at 'http://10.0.2.2:9010/LoginService?xsd=1', relative to 'http://10.0.2.2:9010/LoginService?WSDL'.
//            I/System.out: soap Binding: http://schemas.xmlsoap.org/soap/http
//            I/System.out: Full Request XML Is <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://service.webservice.jinouts.org/" ><soap:Header/><soap:Body><ws:login><user>asraf</user><pass>asraf</pass></ws:login></soap:Body></soap:Envelope>
//            I/System.out: Response Class: org.jinouts.webservice.service.LoginResponse
//            I/System.out: Status  200
//            I/System.out: WSInvocationHandler: Status  200
//            I/System.out: WSInvocationHandler: Response: <?xml version="1.0" ?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:loginResponse xmlns:ns2="http://service.webservice.jinouts.org/"><return><successCode>200</successCode><successMessage>Login Successful</successMessage></return></ns2:loginResponse></S:Body></S:Envelope>
//            I/System.out: ReflectionHelper*java.lang.NoSuchFieldException: return
//            I/System.out: FieldnameFound for return
//            I/System.out: ReflectionHelper*java.lang.NoSuchFieldException: return
//            I/System.out: ReflectionHelper*java.lang.NoSuchFieldException: return
//            I/System.out: FieldnameFound for return
//            I/System.out: ReflectionHelper*java.lang.NoSuchFieldException: return
//            I/System.out: FieldnameFound for successCode
//            I/System.out: FieldnameFound for successCode
//            I/System.out: FieldnameFound for successMessage
//            I/System.out: FieldnameFound for successMessage
//            I/System.out: ReflectionHelper*java.lang.NoSuchFieldException: return
//            I/System.out: FieldnameFound for return
//            I/AndroidWSAppActivity: Resp Success Code: 200
//            I/AndroidWSAppActivity: Resp Error Code: null
            LoginServiceResponse resp = login.login(user, passwd);
            return resp;
        }

        @Override
        protected void onPostExecute(LoginServiceResponse resp) {
            TextView respTextView = (TextView) findViewById(R.id.respTextView);
            if (resp != null) {
                Log.i("AndroidWSAppActivity ",
                        "Resp Success Code: " + resp.getSuccessCode());
                Log.i("AndroidWSAppActivity ",
                        "Resp Error Code: " + resp.getErrorCode());

                respTextView.setText("SuccessCode: " + resp.getSuccessCode()
                        + " Message: " + resp.getSuccessMessage()
                        + " \nErrorCode: " + resp.getErrorCode() + " Message: "
                        + resp.getErrorMessage());
            } else {
                respTextView.setText("Couldn't get Response");
            }
        }
    }
}
