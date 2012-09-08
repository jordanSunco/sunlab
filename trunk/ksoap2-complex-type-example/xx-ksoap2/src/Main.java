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
 * ����ͨ��KSOAP2Զ�̵��ú��Զ������Ͳ�����WebService����
 * 
 * @author Sun
 * @version 1.0 2012-9-8
 * @see http://seesharpgears.blogspot.in/2010/10/ksoap-android-web-service-tutorial-with.html
 * @see http://code.google.com/p/ksoap2-android/wiki/CodingTipsAndTricks#sending/receiving_array_of_complex_types_or_primitives
 * @see http://ksoap2.sourceforge.net/doc/api/
 */
public class Main {
    /**
     * web service����������ռ�, ������wsdl(wsdl:definitions�ڵ�targetNamespace����)���ҵ�
     * ����:
     * <wsdl:definitions targetNamespace="http://communication.service.server">
     */
    private final String NAMESPACE = "http://communication.service.server";

    /**
     * �����õ�web service������ʵ��
     * ����:
     * public Foo helloFoo(Foo foo) {
     *     foo.setId(foo.hashCode());
     *     return foo;
     * }
     */
    private final String METHOD_NAME = "helloFoo";

    /**
     * web service�����ַ
     */
    private final String URL = "http://localhost:8080/xfiredemo/services/demo";

    public static void main(String[] args) {
        new Main().testKsoap2InvokeWs();
    }

    private void testKsoap2InvokeWs() {
        SoapObject request = new SoapObject(NAMESPACE, METHOD_NAME);

        // ����Ҫ���õ�web service�����Ĳ���
        Foo_ foo = new Foo_();
        foo.setName("Զ�̵��ú��Զ������Ͳ�����WebService����");
        PropertyInfo argument = new PropertyInfo();
        // web serviceʵ�ַ����в���������
        argument.setName("foo");
        argument.setValue(foo);
        // ���Ҫ���õ�web service�������Զ������Ͳ���,
        // �������ò����������ռ�(����ڲ������л�ʵ����Foo_���������Ѿ�ָ���������ռ�, ʡ���ƺ�ûʲôӰ��, ���Ƽ�ָ��)
        argument.setNamespace(Foo_.NAMESPACE);
        argument.setType(Foo_.class);
        request.addProperty(argument);

        // ����web sevice SOAP envelope
        SoapSerializationEnvelope envelope = new SoapSerializationEnvelope(SoapEnvelope.VER11);
        envelope.dotNet = true;
        envelope.setOutputSoapObject(request);
        // ӳ�����WebServiceҪ���ݵ����л������
        // namespace��name����wsdl�ж����complexType, clazzָ��Ҫ���л��������
        envelope.addMapping(Foo_.NAMESPACE, "Foo", Foo_.class);

        HttpTransportSE httpTransport = new HttpTransportSE(URL);
        // debugΪtrueʱ����httpTransport.requestDump/responseDump����ֵ,
        // ����Ϊnull, ���Խ����ɵ�SOAPЭ��ȫ����ӡ�����Թ��Ŵ�
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
            //                 <name xmlns="http://model.ufologist.com">远程调用各WebService方法</name>
            //             </ns1:out>
            //         </ns1:helloFooResponse>
            //     </soap:Body>
            // </soap:Envelope>
            System.out.println(httpTransport.responseDump);

            // WebService�������ص��Զ������Ͷ������ΪSoapObject, ���ƶ�̬JavaBean
            // TODO �����Ƿ�Ҳ����ӳ��Ϊ�Զ������, ����ǿ��������ȡ��������
            SoapObject response = (SoapObject) envelope.getResponse();
            // ��ȡ����ֵ
            System.out.println(response.getProperty("id"));
            System.out.println(response.getProperty("name"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
