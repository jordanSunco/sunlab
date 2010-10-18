/*
 * Copyright
 */

package test.jws;

import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import javax.xml.ws.soap.SOAPBinding;

import test.jws.service.HelloWorld;

/**
 * Accessing Web service
 * 
 * @author Sun
 * @version Client.java 2010-10-18 上午09:54:38
 */
public class Client {
    private static final QName SERVICE_NAME = new QName(
            "http://service.jws.test/", "HelloWorld");
    private static final QName PORT_NAME = new QName(
            "http://service.jws.test/", "HelloWorldPort");

    public static void main(String args[]) throws Exception {
        Service service = Service.create(SERVICE_NAME);
        // Endpoint Address
        String endpointAddress = "http://localhost:9000/helloWorld";

        // Add a port to the Service
        service.addPort(PORT_NAME, SOAPBinding.SOAP11HTTP_BINDING,
                endpointAddress);

        HelloWorld hw = service.getPort(HelloWorld.class);
        System.out.println(hw.sayHi("World"));
    }
}
