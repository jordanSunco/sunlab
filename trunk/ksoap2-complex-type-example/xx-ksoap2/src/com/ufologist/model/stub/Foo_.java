/*
 * copyright
 */

package com.ufologist.model.stub;

import java.util.Hashtable;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.PropertyInfo;

import com.ufologist.model.Foo;

/**
 * KSOAP2模型序列化实现类
 * 
 * @author Sun
 * @version 1.0 2012-9-8
 */
public class Foo_ extends Foo implements KvmSerializable {
    /**
     * 自定义类型(对象)所处的命名空间.
     * 从wsdl(xsd:schema节点targetNamespace属性)中可以找到
     * 
     * 例如:
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
                // 必须设置对象属性所处的命名空间.
                // KSOAP2将对象序列化成SOAP XML时才会在对应的命名空间下.
                // 生成的XML类似:
                // <n0:foo i:type="n0:Foo" xmlns:n0="http://model.ufologist.com">
                //     <n0:id i:type="d:int">0</n0:id>
                // </n0:foo>
                // 
                // 如果没有设置命名空间, 生成的XML类似(foo处于默认命名空间下明显不对):
                // <foo i:type="n0:Foo" xmlns:n0="http://model.ufologist.com">
                //     <id i:type="d:int">0</id>
                // </foo>
                // 通过KSOAP2调用WebService会返回错误信息
                // <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                //     <soap:Body>
                //         <soap:Fault>
                //             <faultcode>soap:Server</faultcode>
                //             <faultstring>Fault: java.lang.NullPointerException</faultstring>
                //         </soap:Fault>
                //     </soap:Body>
                // </soap:Envelope>
                // 抛出异常
                // SoapFault - faultcode: 'soap:Server' faultstring: 'Fault: java.lang.NullPointerException' faultactor: 'null' detail: null
                // 
                // XXX 只要设置一个属性的namespace, 其他属性就可以不设置了
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
        // XXX 可以不实现?
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
