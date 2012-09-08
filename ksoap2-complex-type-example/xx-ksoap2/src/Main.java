/*
 * copyright
 */

import org.ksoap2.SoapEnvelope;
import org.ksoap2.serialization.PropertyInfo;
import org.ksoap2.serialization.SoapObject;
import org.ksoap2.serialization.SoapSerializationEnvelope;
import org.ksoap2.transport.HttpTransportSE;

import com.ufologist.model.stub.Foo_;

/**
 * 测试通过KSOAP2远程调用含自定义类型参数的WebService方法
 * 
 * @author Sun
 * @version 1.0 2012-9-8
 * @see http://seesharpgears.blogspot.in/2010/10/ksoap-android-web-service-tutorial-with.html
 * @see http://code.google.com/p/ksoap2-android/wiki/CodingTipsAndTricks#sending/receiving_array_of_complex_types_or_primitives
 * @see http://ksoap2.sourceforge.net/doc/api/
 */
public class Main {
    /**
     * web service服务的命名空间, 可以在wsdl(wsdl:definitions节点targetNamespace属性)中找到
     * 例如:
     * <wsdl:definitions targetNamespace="http://communication.service.server">
     */
    private final String NAMESPACE = "http://communication.service.server";

    /**
     * 测试用的web service方法的实现
     * 例如:
     * public Foo helloFoo(Foo foo) {
     *     foo.setId(foo.hashCode());
     *     return foo;
     * }
     */
    private final String METHOD_NAME = "helloFoo";

    /**
     * web service服务地址
     */
    private final String URL = "http://localhost:8080/xfiredemo/services/demo";

    public static void main(String[] args) {
        new Main().testKsoap2InvokeWs();
    }

    private void testKsoap2InvokeWs() {
        SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

        // 设置要调用的web service方法的参数
        Foo_ foo = new Foo_();
        foo.setName("远程调用含自定义类型参数的WebService方法");
        PropertyInfo argument = new PropertyInfo();
        // web service实现方法中参数的名称
        argument.setName("foo");
        argument.setValue(foo);
        // 如果要调用的web service方法有自定义类型参数,
        // 建议设置参数的命名空间(如果在参数序列化实现类Foo_的属性中已经指定了命名空间, 省略似乎没什么影响, 但推荐指定)
        argument.setNamespace(Foo_.NAMESPACE);
        argument.setType(Foo_.class);
        request.addProperty(argument);

        // 设置web sevice SOAP envelope
        SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
        envelope.dotNet = true;
        envelope.setOutputSoapObject(request);
        // 映射调用WebService要传递的序列化类对象
        // namespace和name就是wsdl中定义的complexType, clazz指定要序列化的类对象
        envelope.addMapping(Foo_.NAMESPACE, "Foo", Foo_.class);

        HttpTransportSE httpTransport = new HttpTransportSE(URL);
        // debug为true时调用httpTransport.requestDump/responseDump才有值,
        // 否则为null, 可以将生成的SOAP协议全部打印出来以供排错
        httpTransport.debug = true;

        try {
            httpTransport.call(null, envelope);
            // <v:Envelope xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns:d="http://www.w3.org/2001/XMLSchema" xmlns:c="http://schemas.xmlsoap.org/soap/encoding/" xmlns:v="http://schemas.xmlsoap.org/soap/envelope/">
            //     <v:Header />
            //     <v:Body>
            //         <helloFoo xmlns="http://communication.service.server" id="o0" c:root="1">
            //             <n0:foo i:type="n0:Foo" xmlns:n0="http://model.ufologist.com">
            //                 <n0:id i:type="d:int">0</n0:id>
            //                 <n0:name i:type="d:string">&#36828;&#31243;WebService&#26041;</n0:name>
            //             </n0:foo>
            //         </helloFoo>
            //     </v:Body>
            // </v:Envelope>
            System.out.println(httpTransport.requestDump);
            // <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            //     <soap:Body>
            //         <ns1:helloFooResponse xmlns:ns1="http://communication.service.server">
            //             <ns1:out>
            //                 <id xmlns="http://model.ufologist.com">5784348</id>
            //                 <name xmlns="http://model.ufologist.com">杩滅▼璋冪敤鍚刉ebService鏂规硶</name>
            //             </ns1:out>
            //         </ns1:helloFooResponse>
            //     </soap:Body>
            // </soap:Envelope>
            System.out.println(httpTransport.responseDump);

            // WebService方法返回的自定义类型对象表现为SoapObject, 类似动态JavaBean
            // TODO 这里是否也可以映射为自定义对象, 采用强类型来获取返回数据
            SoapObject response = (SoapObject) envelope.getResponse();
            // 获取属性值
            System.out.println(response.getProperty("id"));
            System.out.println(response.getProperty("name"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
