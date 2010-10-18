/*
 * Copyright
 */

package test.jws;

import javax.xml.ws.Endpoint;

import test.jws.service.HelloWorldImpl;

/**
 * Publishing Web service
 * 
 * @author Sun
 * @version Server.java 2010-10-18 上午09:33:17
 */
public class Server {
    public Server() {
        System.out.println("Starting Server");

        HelloWorldImpl implementor = new HelloWorldImpl();
        String address = "http://localhost:9000/helloWorld";
        Endpoint.publish(address, implementor);
    }

    public static void main(String args[]) throws Exception {
        new Server();
        System.out.println("Server ready...");

        Thread.sleep(5 * 60 * 1000);
        System.out.println("Server exiting");
        System.exit(0);
    }
}
