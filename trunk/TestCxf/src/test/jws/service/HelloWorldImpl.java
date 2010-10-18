/*
 * Copyright
 */

package test.jws.service;

public class HelloWorldImpl implements HelloWorld {
    public String sayHi(String text) {
        System.out.println("sayHi called");
        return "Hello " + text;
    }
}
