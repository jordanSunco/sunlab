/*
 * copyright
 */

package com.ufologist.model.stub;

import java.util.Hashtable;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.PropertyInfo;

import com.ufologist.model.Foo;

/**
 * KSOAP2ģ�����л�ʵ����
 * 
 * @author Sun
 * @version 1.0 2012-9-8
 */
public class Foo_ extends Foo implements KvmSerializable {
    /**
     * �Զ�������(����)�����������ռ�.
     * ��wsdl(xsd:schema�ڵ�targetNamespace����)�п����ҵ�
     * 
     * ����:
     * <xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" attributeFormDefault="qualified" elementFormDefault="qualified"
     *         targetNamespace="http://model.ufologist.com">
     *     <xsd:complexType name="Foo">
     *         <xsd:sequence>
     *             <xsd:element minOccurs="0" name="id" type="xsd:int"/>
     *             <xsd:element minOccurs="0" name="name" nillable="true" type="xsd:string"/>
     *         </xsd:sequence>
     *     </xsd:complexType>
     * </xsd:schema>
     */
    public static final String NAMESPACE = "http://model.ufologist.com";

    @Override
    public Object getProperty(int index) {
        Object value = null;
        switch (index) {
            case 0:
                value = getId();
                break;
            case 1:
                value = getName();
                break;
        }
        return value;
    }

    @Override
    public int getPropertyCount() {
        return 2;
    }

    @Override
    public void getPropertyInfo(int index, Hashtable properties,
            PropertyInfo info) {
        switch (index) {
            case 0:
                info.name = "id";
                info.type = PropertyInfo.INTEGER_CLASS;
                // �������ö������������������ռ�.
                // KSOAP2���������л���SOAP XMLʱ�Ż��ڶ�Ӧ�������ռ���.
                // ���ɵ�XML����:
                // <n0:foo i:type="n0:Foo" xmlns:n0="http://model.ufologist.com">
                //     <n0:id i:type="d:int">0</n0:id>
                // </n0:foo>
                // 
                // ���û�����������ռ�, ���ɵ�XML����(foo����Ĭ�������ռ������Բ���):
                // <foo i:type="n0:Foo" xmlns:n0="http://model.ufologist.com">
                //     <id i:type="d:int">0</id>
                // </foo>
                // ͨ��KSOAP2����WebService�᷵�ش�����Ϣ
                // <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                //     <soap:Body>
                //         <soap:Fault>
                //             <faultcode>soap:Server</faultcode>
                //             <faultstring>Fault: java.lang.NullPointerException</faultstring>
                //         </soap:Fault>
                //     </soap:Body>
                // </soap:Envelope>
                // �׳��쳣
                // SoapFault - faultcode: 'soap:Server' faultstring: 'Fault: java.lang.NullPointerException' faultactor: 'null' detail: null
                // 
                // XXX ֻҪ����һ�����Ե�namespace, �������ԾͿ��Բ�������
                info.namespace = NAMESPACE;
                break;
            case 1:
                info.name = "name";
                info.type = PropertyInfo.STRING_CLASS;
                info.namespace = NAMESPACE;
                break;
            default:
                break;
        }
    }

    @Override
    public void setProperty(int index, Object value) {
        // XXX ���Բ�ʵ��?
//        switch (index) {
//            case 0:
//                setId(Integer.valueOf(value.toString()));
//                break;
//            case 1:
//                setName(value.toString());
//                break;
//            default:
//                break;
//        }
    }
}
